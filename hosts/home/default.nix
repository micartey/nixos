{ meta, ... }:

{
  imports = [
    ../graphical.nix
    ./hardware-configuration.nix
    ../../profiles/home
  ];

  networking.hostName = "home";

  system.stateVersion = "25.11";
  home-manager.users.${meta.user.username} = {
    imports = [ ../../profiles/home/home-manager.nix ];
    home.stateVersion = "25.11";
  };

  boot = {
    loader = {
      systemd-boot.enable = true;

      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = {
      ntfs = true;
    };
  };
}
