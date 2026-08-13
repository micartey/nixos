{ meta, pkgs, ... }:

{
  imports = [
    ../../modules
  ];

  hardware.i2c.enable = true;

  users.groups.vfio = { };
  users.users.${meta.user.username}.extraGroups = [ "vfio" ];

  security.pam.loginLimits = [
    {
      domain = "@vfio";
      type = "-";
      item = "memlock";
      value = "infinity";
    }
  ];

  services.udev.extraRules = ''
    KERNEL=="vfio", SUBSYSTEM=="misc", GROUP="vfio", MODE="0660"
    KERNEL=="[0-9]*", SUBSYSTEM=="vfio", GROUP="vfio", MODE="0660"
  '';

  boot = {
    kernelModules = [
      "nct6775"
      "coretemp"
      "vfio-pci"
    ];
    kernelParams = [
      "vfio-pci.ids=10de:1c02,10de:10f1"
    ];
  };

  environment.systemPackages = with pkgs; [
    ddcutil
    OVMF
  ];
}
