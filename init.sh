# Copy the hardware configuration
cp /etc/nixos/hardware-configuration.nix ./hosts/specific/home/hardware-configuration.nix

# Rebuild nixos
nixos-rebuild switch --flake .#home