# Mullvad + Tailscale split tunnel (mullvad-exclude) breakage

Date: 2026-07-22

## Symptoms

- `mullvad-exclude curl ...` had no internet at all while Mullvad was connected.
- Disabling Tailscale made `mullvad-exclude` work again.
- With Mullvad connected and Tailscale in a bad state, the whole machine lost
  internet (DNS is systemd-resolved → pihole `100.72.132.37` via tailnet).
- Setup used to work; suspected causes were the NixOS 26.05 update or the
  switch to systemd-resolved. Turned out to be neither: it was a Tailscale
  update (1.9x stateful fwmark feature).

## Background: how the compatibility fix works

`modules/services/mullvad.nix` implements
<https://theorangeone.net/posts/tailscale-mullvad/>:

1. An `inet mullvad-tailscale` nftables table marks traffic to/from
   `100.64.0.0/10` (except Mullvad's DNS range `100.64.0.0/24`) with
   `meta mark 0x6d6f6c65` ("mole") and `ct mark 0x00000f41`.
2. `0x6d6f6c65` is Mullvad's "excluded" fwmark: its policy routing rule
   `5209: not from all fwmark 0x6d6f6c65 lookup 1836018789` sends everything
   *not* marked into the tunnel; marked packets fall through to Tailscale's
   `5270: from all lookup 52` and exit via `tailscale0`.
3. `ct mark 0x00000f41` makes Mullvad's kill-switch filter chains
   (`ct mark 0x00000f41 accept`) accept the bypassed traffic.
4. `mullvad-exclude` puts a process into a cgroup; Mullvad's
   `meta cgroup 5087041 ... meta mark set 0x6d6f6c65` mangle rule marks all
   its traffic the same way (split tunnel).

## Investigation approach

1. Read `modules/services/mullvad.nix`, `modules/services/dns.nix`,
   `modules/network/tailscale.nix`; checked git history of `mullvad.nix`.
2. Compared live state with VPN off vs on:
   - `ip rule show` — no Mullvad rules when disconnected (expected), rules
     `5208/5209` appear when connected, ordered *before* Tailscale's
     `5210–5270` rules.
   - `ip route show table 52` — tailnet routes, incl. pihole `100.72.132.37`.
3. Dumped full ruleset **while connected** (needs sudo, user ran it):
   `sudo nft list ruleset > /tmp/ruleset.txt`. This was the key step: it
   exposed Tailscale's new `ip mangle` chains (see below).
4. Reproduced with probes: plain curl, `mullvad-exclude curl`,
   `getent hosts google.com`, all with `timeout` so nothing hangs. Result:
   connected → everything `000`, DNS FAIL; disconnected → all fine.
5. Verified declarative config actually reached the live ruleset:
   `sudo nft list table inet mullvad-tailscale` (an earlier "empty" output
   was just the command being run before `nixos-rebuild switch`).
6. Checked `journalctl -u nftables` / `systemctl status nftables` to rule
   out a failed ruleset reload (was SUCCESS).

Note: a zsh gotcha cost one test round — `echo ===` triggers zsh's
`=command` expansion (`zsh:1: == not found`), aborting the command chain.
Quote separators (`echo "---"`) in zsh.

## Root cause

Tailscale >= 1.9x added a "stateful fwmark" scheme (its own mark moved to
`0x00040000`, saved/restored via conntrack). Its nftables chains (installed
via iptables-nft into `table ip mangle`) match on **any** fwmark with byte 3
(`0x00ff0000`) set. Mullvad's exclusion mark `0x6d6f6c65` has byte 3 =
`0x6d` ≠ 0, so it collides:

### Outbound path (breaks mullvad-exclude)

`ip mangle OUTPUT` at priority -150:

```text
ct state new meta mark & 0x00ff0000 != 0x00000000 ct mark set mark and 0xff0000
```

Mullvad's cgroup split-tunnel rule sets `ct mark 0x00000f41` at the same
priority; Tailscale's chain then rewrites the ct mark to `0x006d0000`.
Mullvad's kill-switch `output` filter (`ct mark 0x00000f41 accept`) no
longer matches → excluded packets hit `policy drop`.

### Inbound path (breaks all replies, incl. DNS)

`ip mangle PREROUTING` at priority -150:

```text
ct state related,established meta mark set ct mark and 0xff0000
```

Mullvad's own `inet mullvad prerouting` (-199) had already restored
`meta mark 0x6d6f6c65` for marked connections; Tailscale's chain then wipes
it to 0 (`0x0f41 & 0xff0000 == 0`). The nixos-fw `rpfilter` chain
(`fib saddr . mark . iif check exists`, priority mangle+10 = -140,
`policy drop`) then looks up the source *unmarked*: Mullvad rule 5209
routes it via `wg0-mullvad`, which ≠ `iif tailscale0` → **drop**. All
replies for marked connections died: tailnet DNS (pihole) and all
split-tunneled traffic → total connectivity loss while connected.

This also explains why it "used to work": the old Tailscale did not touch
foreign marks; the feature arrived with a Tailscale update, independent of
the NixOS/resolved changes.

## Fix applied

Two rules in `modules/services/mullvad.nix` that restore Mullvad's marks
*after* Tailscale's chains run, at well-chosen hook priorities:

```nft
chain prerouting {
  type filter hook prerouting priority -145; policy accept;
  # After Tailscale (-150), before nixos-fw rpfilter (-140)
  ct mark 0x00000f41 meta mark set 0x6d6f6c65;
}

chain output {
  type route hook output priority -100; policy accept;
  ip daddr 100.64.0.0/24 return;
  ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
  # After Tailscale's OUTPUT (-150), before Mullvad's filter (0)
  meta mark 0x6d6f6c65 ct mark set 0x00000f41;
}
```

- `prerouting` (-145): restores `meta mark` from ct mark for replies of
  marked connections, so rpfilter's `saddr . mark . iif` check resolves via
  table 52 / `tailscale0` again.
- `output` (dstnat/-100): restores `ct mark 0x00000f41` for any
  `0x6d6f6c65`-marked packet (i.e. mullvad-exclude traffic), so Mullvad's
  kill-switch accepts it.

Ordering is robust regardless of the registration order of Tailscale's and
Mullvad's same-priority (-150) chains, because the restore happens strictly
later.

Apply with:

```bash
sudo nixos-rebuild switch --flake /home/daniel/nixos#home
mullvad reconnect -w   # nftables reload flushes Mullvad's dynamic tables
```

No reboot needed; `switch` reloads nftables. Tailscale re-adds its own
chains on restart (`sudo systemctl restart tailscaled`) if they were
flushed.

## Smoke tests (all passing after fix)

With `mullvad connect -w` active and Tailscale up:

```text
curl https://ifconfig.me                      → 200 (via tunnel)
mullvad-exclude curl https://ifconfig.me      → 200 (bypassed)
mullvad-exclude curl https://am.i.mullvad.net/connected
  → "You are not connected to Mullvad. Your IP is 93.207.26.30" (real IP)
getent hosts google.com                       → OK (resolved → pihole via tailnet)
ping 100.72.132.37                            → OK (tailnet reachable under VPN)
```

Before the fix, the same probes gave `000` / DNS failure for everything
while connected.

## Useful checks

```bash
ip rule show                        # 5209 (mullvad) before 5270 (tailscale)
ip route show table 52              # tailnet routes
sudo nft list table inet mullvad-tailscale
sudo nft list table inet mullvad    # only while connected
sudo nft list table ip mangle       # Tailscale's stateful-mark chains
systemctl status nftables; journalctl -u nftables -b
mullvad status; mullvad split-tunnel list; tailscale status
```
