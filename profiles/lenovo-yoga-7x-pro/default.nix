{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-yoga-7-14ARH7-nvidia
  ];

  hardware.lenovoLegionLinux.enable = true;
  hardware.bluetooth.powerOnBoot = lib.mkForce false;
  services.upower.enable = true;

  environment.systemPackages = [ pkgs.brightnessctl ];
}
