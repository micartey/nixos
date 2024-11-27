{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../base/desktop

    ../../../modules
  ];

  networking.hostName = "home";

  boot = {
    kernelModules = [
      "nct6775"
      "coretemp"
    ];
    loader = {
      systemd-boot.enable = true;

      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = {
      ntfs = true;
    };
  };

  home-manager.users = {
    daniel = import ../../../home/daniel {
      inherit inputs pkgs pkgs-unstable;

      host = {
        # TODO: add config options for home manager modules
      };
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";

    MOZ_ENABLE_WAYLAND = "1";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
  };

  # hardware.fancontrol = {
  #   enable = true;
  #   config = '''';
  # };

  environment.systemPackages = with pkgs; [
    lm_sensors
    libthai
  ];

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
