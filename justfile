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
    ./bin/nixos-vm.sh

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

# Since 26.05 I have issues with my USB hub and keyboard. Running this will restart the usb controller instead of needing to reboot
fix-usb-controller:
    sudo ./bin/reset-usb-controller.sh

# Runtime check: TracerPid stays 0 while a process is actively straced.
# Only meaningful after rebuild+reboot with the patch applied.
verify-tracer-pid-hidden:
    ./bin/tracer-pid-test.sh
