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
