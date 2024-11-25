{
  inputs,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

with lib;
let
  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir = dir: mapAttrs
    (file: type:
      if type == "directory" then getDir "${dir}/${file}" else type
    )
    (builtins.readDir dir);

  # Collects all files of a directory as a list of strings of paths
  files = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));

  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  validFiles = dir: map
    (file: ./. + "/${file}")
    (filter
      (file: hasSuffix ".nix" file && file != "default.nix" &&
        ! lib.hasPrefix "x/taffybar/" file &&
        ! lib.hasSuffix "-hm.nix" file)
      (files dir));

in

{
  imports = [
    ./hardware-configuration.nix
    ../../base/desktop
  ] ++ validFiles ../../../modules;

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
