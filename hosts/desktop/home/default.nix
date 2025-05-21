{
  pkgs,
  ...
}:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
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

    # Emulate arm through qemu? to build arm
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "armv7l-linux"
    ];
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

}
