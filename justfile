default:
    @just --list

home-iso:
    nix build .#nixosConfigurations.home.config.system.build.isoImage

home-switch:
    nixos-rebuild switch --flake .#home

flake-update:
    nix flake update

generate-key:
    nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/private > ~/.config/sops/age/keys.txt

get-public-key:
    nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt

sops:
    sops ./secrets/secrets.yml
