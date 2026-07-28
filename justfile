default:
    @just --list

home-switch:
    sudo nixos-rebuild switch --flake .#home

home-iso:
    NIX_BUILD_CORES=25 nix build \
        .#nixosConfigurations.homeImg.config.system.build.isoImage \
        --impure

    sudo cp result/iso/nixos-26.05.20260608.bd0ff2d-x86_64-linux.iso nixos.iso

home-vm:
    #!/usr/bin/env bash
    set -euo pipefail
    QEMU_DIR="$(qemu-system-x86_64 -L help 2>&1 | tail -1)"
    cp -n "$QEMU_DIR/edk2-i386-vars.fd" ovmf_vars.fd 2>/dev/null || true
    chmod +w ovmf_vars.fd
    [ -f storage.qcow2 ] || qemu-img create -f qcow2 storage.qcow2 100G
    # NVIDIA is primary renderer; virtio-vga provides QEMU window scanout.
    qemu-system-x86_64 \
        -enable-kvm \
        -machine q35 \
        -m 32G \
        -smp cores=16 \
        -drive if=pflash,format=raw,readonly=on,file="$QEMU_DIR/edk2-x86_64-code.fd" \
        -drive if=pflash,format=raw,file=ovmf_vars.fd \
        -cdrom nixos.iso \
        -drive file=storage.qcow2,if=virtio,format=qcow2 \
        -boot menu=on \
        -netdev user,id=net0,hostfwd=tcp::25565-:25565 \
        -device virtio-net-pci,netdev=net0 \
        -fsdev local,id=hostshare,path=/home/daniel/nixos,security_model=passthrough \
        -device virtio-9p-pci,fsdev=hostshare,mount_tag=hostshare,addr=0x5 \
        -object memory-backend-file,id=looking-glass,mem-path=/dev/shm/looking-glass,size=32M,share=on \
        -device ivshmem-plain,memdev=looking-glass,addr=0x6 \
        -device virtio-vga,addr=0x2 \
        -display gtk,gl=off \
        -spice addr=127.0.0.1,port=5900,disable-ticketing=on \
        -serial mon:stdio \
        -device vfio-pci,host=03:00.0,rombar=1,addr=0x3,multifunction=on \
        -device vfio-pci,host=03:00.1,addr=0x3.1

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
