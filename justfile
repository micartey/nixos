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
            -netdev user,id=net0 \
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
