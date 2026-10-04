{
  meta,
  ...
}:

{
  imports = [
    ../graphical.nix
    ./hardware-configuration.nix
    ../../profiles/lenovo-yoga-7x-pro
  ];

  networking.hostName = "home-yoga";

  system.stateVersion = "25.05";
  home-manager.users.${meta.user.username} = {
    imports = [ ../../profiles/lenovo-yoga-7x-pro/home-manager.nix ];
    home.stateVersion = "25.05";
  };

  boot = {
    kernelModules = [
      "nct6775"
      "coretemp"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems.ntfs = true;
  };
}
