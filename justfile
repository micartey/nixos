default:
    @just --list

home-switch:
    sudo nixos-rebuild switch --flake .#home

home-iso:
    NIX_BUILD_CORES=25 nix build \
        .#nixosConfigurations.homeImg.config.system.build.isoImage \
        --impure

home-vm:
    qemu-system-x86_64 \
        -enable-kvm \
        -m 32G \
        -smp cores=16 \
        -cdrom nixos.iso \
        -boot d \
        -netdev user,id=net0,hostfwd=tcp::25565-:25565 \
        -device virtio-net-pci,netdev=net0 \
        -device virtio-vga,edid=on,xres=1920,yres=1080

flake-update:
    nix flake update

flake-update-unstable:
    nix flake update nixpkgs-unstable

flake-update-edge:
    nix flake update nixpkgs-edge

flake-update-development:
    nix flake update nix-vim
    nix flake update opencode

# Run 'nix run nixpkgs#gdrive3 account add' before you can use this command!
iso-upload:
    nix run nixpkgs#gdrive3 files upload nixos-$(date +%d.%m.%Y).iso

# Runtime check: TracerPid stays 0 while a process is actively straced.
# Only meaningful after rebuild+reboot with the patch applied.
verify-tracer-pid-hidden:
    #!/usr/bin/env bash
    set -euo pipefail
    strace -o /dev/null sleep 30 &
    tracer=$!
    trap 'kill "$tracer" 2>/dev/null || true' EXIT
    target=""
    for _ in $(seq 1 50); do
        target=$(pgrep -P "$tracer" sleep || true)
        [ -n "$target" ] && break
        sleep 0.1
    done
    [ -n "$target" ] || { echo "FAIL: could not find traced sleep" >&2; exit 1; }
    tpid=$(awk '/^TracerPid:/ {print $2}' "/proc/$target/status")
    echo "traced sleep pid: $target, strace pid: $tracer, TracerPid: $tpid"
    if [ "$tpid" = "0" ]; then
        echo "OK: TracerPid hidden (patch active)"
    else
        echo "FAIL: TracerPid=$tpid leaks tracer pid (patch inactive or not rebooted)" >&2
        exit 1
    fi
