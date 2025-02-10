default:
    @just --list

home-switch:
    nixos-rebuild switch --flake .#home

# Before you run this command, make sure to:
# 1. remove networking.networkmanager from cloudflare_dns.nix
# 2. comment openssh.authorizedKeys.keys in users.nix
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

generate-key:
    nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/keys.txt

get-public-key:
    nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt

sops:
    sops ./secrets/secrets.yml
