default:
    @just --list

home-switch:
    # nixos-rebuild switch --flake .#home --max-jobs 1
    nixos-rebuild switch --flake .#home

# Before you run this command, make sure to:
# 1. uncomment isoImage in flake.nix configuration
# 2. remove networking.networkmanager from cloudflare_dns.nix
# 3. comment openssh.authorizedKeys.keys in users.nix
home-iso:
    # NixOS-generators does not seem to do the trick
    NIX_BUILD_CORES=32 nix build \
        .#nixosConfigurations.homeImg.config.system.build.isoImage \
        --impure

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
