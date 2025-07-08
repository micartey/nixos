default:
    @just --list

home-switch:
    nixos-rebuild switch --flake .#home

# Before you run this command, make sure to:
# 1. uncomment isoImage in flake.nix configuration
# 2. remove networking.networkmanager from cloudflare_dns.nix
# 3. comment openssh.authorizedKeys.keys in users.nix
home-iso:
    nix run github:nix-community/nixos-generators -- \
        --format qcow \
        --flake .#homeImg \
        -o result

    sudo cp result/*.qcow2 nixos.qcow2
    sudo chown $(id -u):$(id -g) nixos.qcow2
    sudo chmod 600 nixos.qcow2


home-vm:
    qemu-system-x86_64 \
            -enable-kvm \
            -m 16G \
            -smp cores=8 \
            -cdrom nixos.iso \
            -boot d \
            -netdev user,id=net0 \
            -device virtio-net-pci,netdev=net0

flake-update:
    nix flake update

flake-update-unstable:
    nix flake update nixpkgs-unstable
