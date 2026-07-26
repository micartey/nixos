# Kernel patch: hide TracerPid in /proc

Date: 2026-07-26

## What it does

Always reports `TracerPid: 0` in `/proc/<pid>/status`, even when a process
is being ptraced. Based on a 2017 patch by Douglas Hellinger
(`acc0182c3d3869802bc20c8bf4e04c3464936bcc`), re-based onto kernel 6.18.x.

## Files

- `patches/hide-tracer-pid.patch` — the kernel patch.
- `modules/security/hide-tracer-pid.nix` — NixOS module applying it via
  `boot.kernelPatches`. No manual import needed: `modules/default.nix`
  auto-imports every `.nix` under `modules/` recursively.

Patch content (current, for 6.18.x):

```patch
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -159,7 +159,8 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 	rcu_read_lock();
 	tracer = ptrace_parent(p);
 	if (tracer)
-		tpid = task_pid_nr_ns(tracer, ns);
+		/* hide TracerPid */
+		tpid = 0;
 
 	ppid = task_ppid_nr_ns(p, ns);
 	tgid = task_tgid_nr_ns(p, ns);
```

Differences vs the original 2017 patch (why plain reuse fails):

- 2017 context had `tgid = ...; ngid = ...;` right after `tpid`; 6.18 has
  `rcu_read_lock();` before the `tracer` lines and `ppid`/`tgid` after.
- Indentation is tabs; the hunk header line number shifted (171 → 159/162).

## How the needed data was obtained

1. Kernel version in use, from the locked flake (no store reading needed):
   ```bash
   nix eval /home/daniel/nixos#nixosConfigurations.home.config.boot.kernelPackages.kernel.version
   # → 6.18.34
   ```
   (`home` = the desktop host config.) Cross-checked the pinned nixpkgs rev:
   `nixos-26.05beta1.705e9929918b` (see `flake.lock`).
2. Actual `fs/proc/array.c` source for that version: fetched the file from
   the kernel stable git web interface for tags `v6.18.33` and `v6.18.34`
   (e.g. `https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain/fs/proc/array.c?h=v6.18.34`
   or GitHub `torvalds/linux` / `stable/linux` mirrors). Rule of this repo:
   never read `/nix/store` directly, so web fetch of the tagged file was the
   clean path. The file was byte-identical between .33 and .34; target line
   `tpid = task_pid_nr_ns(tracer, ns);` sits around line 162 inside
   `task_state()`.
3. Patch apply test against the real source (in `/tmp`, not the store):
   ```bash
   # put array.c in /tmp/k/fs/proc/array.c, then:
   cd /tmp/k && patch -p1 --dry-run < /home/daniel/nixos/patches/hide-tracer-pid.patch
   ```
   → clean apply, zero fuzz/offset. `patch` accepts fuzz by default, so check
   the output says just "patching file ..." with no "with fuzz" / "offset"
   notes; ideally re-run with `--fuzz=0` to be strict.
4. Module evaluation (without building a kernel):
   ```bash
   nix eval /home/daniel/nixos#nixosConfigurations.home.config.boot.kernelPatches
   nix eval /home/daniel/nixos#nixosConfigurations.home.config.system.build.toplevel.drvPath
   ```
   Both evaluate fine. `nixfmt` run on the module.

## What to do when a kernel update breaks the patch

Symptom: `nixos-rebuild` fails during the kernel `patch` phase with
something like `Hunk #1 FAILED at 159` / `1 out of 1 hunk FAILED`.

Procedure:

1. Get the new kernel version (same eval as above).
2. Fetch `fs/proc/array.c` for the new tag `vX.Y.Z` from kernel stable git.
3. Find `task_state()` and the line
   `tpid = task_pid_nr_ns(tracer, ns);` inside `if (tracer)`.
   If it moved/renamed, search the file for `task_pid_nr_ns` or
   `ptrace_parent`.
4. Update `patches/hide-tracer-pid.patch`:
   - copy 1–2 lines of context above and below the target line from the new
     source (keep tabs exact — copy-paste, don't retype),
   - fix the `@@ -OLD,… +… @@` start line number,
   - keep the replacement body: `/* hide TracerPid */` + `tpid = 0;`.
5. Dry-run against the fetched source in `/tmp` with `patch -p1 --fuzz=0`
   until clean, then evaluate the toplevel (step 4 above) and rebuild.

Note: `boot.kernelPatches` rebuilds the whole kernel — expect a long build
on the first `switch` after any change here.

## Known unrelated issue

`nix flake check --no-build` fails on the `homeImg` configuration with
`access to absolute path '/hosts/desktop/default.nix' is forbidden` —
pre-existing, reproducible on a clean tree; unrelated to this patch.

## Apply

```bash
sudo nixos-rebuild switch --flake /home/daniel/nixos#home
```

Verify after reboot:

```bash
cat /proc/self/status | grep TracerPid   # → TracerPid: 0
```
