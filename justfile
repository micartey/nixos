default:
    @just --list

home-vm-clean:
    rm -rf ./nixos.qcow2

home-vm-build:
    nixos-rebuild build-vm --flake .#home

home-vm-run:
    ./result/bin/run-home-vm

home-vm: home-vm-clean home-vm-build home-vm-run

home-iso:
    nix build .#nixosConfigurations.home.config.system.build.isoImage

home-switch:
    nixos-rebuild switch --flake .#home

sirius-vm-clean:
    rm -rf ./nixos.qcow2

sirius-vm-build:
    nixos-rebuild build-vm --flake .#sirius

sirius-vm-run:
    ./result/bin/run-sirius-vm

sirius-vm: sirius-vm-clean sirius-vm-build sirius-vm-run

sirius-iso:
    nix build .#nixosConfigurations.sirius.config.system.build.isoImage

sirius-switch:
    nixos-rebuild switch --flake .#sirius
