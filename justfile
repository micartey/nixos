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

generate-key:
    nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/keys.txt

get-public-key:
    nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt

sobs:
    sops ./secrets/secrets.yml