{
  inputs,
  pkgs,
  pkgs-edge,
  pkgs-legacy,
  pkgs-unstable,
  currentProfile,
  meta,
  ...
}:

{
  imports = [
    ./default.nix

    ../modules
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        pkgs-edge
        pkgs-legacy
        pkgs-unstable
        currentProfile
        meta
        ;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users = {
    ${meta.user.username} = {
      imports = [ ../home-manager ];
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "armv7l-linux"
  ];

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

  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
    "electron-39.8.10"
  ];

  environment.systemPackages = with pkgs; [
    lm_sensors
    libthai
  ];
}
