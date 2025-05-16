default:
    @just --list

# Like home-switch but with only one job at a time
# When initially installing nixos you will run in an out-of-memory error
# Idk why nix is stpudid like that
home-init:
    nixos-rebuild switch --flake .#home --max-jobs 1

home-switch:
    nixos-rebuild switch --flake .#home

flake-update:
    nix flake update
