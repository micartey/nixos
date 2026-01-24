{ pkgs, ... }:

let
  mullvad = pkgs.mullvad-vpn;
in
{
  services.mullvad-vpn = {
    enable = true;
    package = mullvad;
  };

  # Tailscale + Mullvad compatibility
  # See: https://theorangeone.net/posts/tailscale-mullvad/
  #
  # Two-part solution:
  # 1. nftables rules mark Tailscale IP traffic (100.64.0.0/10) to bypass Mullvad
  # 2. Split-tunnel excludes tailscaled process for control plane traffic
  #
  # IMPORTANT: Mullvad's content-blocking DNS uses 100.64.0.0/24, which overlaps
  # with Tailscale's CGNAT range. We must exclude that range from the bypass.
  networking.nftables.tables.mullvad-tailscale = {
    family = "inet";
    content = ''
      chain output {
        type route hook output priority -100; policy accept;
        # Skip Mullvad's DNS range (100.64.0.0/24) - let it go through the tunnel
        ip daddr 100.64.0.0/24 return;
        # Mark Tailscale traffic to bypass Mullvad
        ip daddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }

      chain input {
        type filter hook input priority -100; policy accept;
        # Skip Mullvad's DNS range
        ip saddr 100.64.0.0/24 return;
        # Mark Tailscale traffic to bypass Mullvad
        ip saddr 100.64.0.0/10 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    '';
  };

  systemd.services.tailscaled.serviceConfig.ExecStartPost = [
    "-${mullvad}/bin/mullvad split-tunnel add $MAINPID"
  ];

  systemd.services.mullvad-dns-fix = {
    description = "Configure Mullvad DNS for Tailscale compatibility";
    wantedBy = [ "multi-user.target" ];
    after = [ "mullvad-daemon.service" ];
    requires = [ "mullvad-daemon.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${mullvad}/bin/mullvad dns set default";
      RemainAfterExit = true;
    };
  };
}
