{ lib, pkgs, ... }:

# @profile default
{
  networking.firewall.enable = lib.mkDefault true;

  environment.systemPackages = [
    pkgs.nixos-firewall-tool
  ];
}
