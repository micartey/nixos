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

  hardware.i2c.enable = true;

  users.groups.vfio = { };

  security.pam.loginLimits = [
    { domain = "@vfio"; type = "-"; item = "memlock"; value = "infinity"; }
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
    # Get IDs from `lspci -nn | grep -i nvidia` — look for [vendor:device]
    # e.g. "03:00.0 ... [10de:1c02]" → 10de:1c02
    kernelParams = [
      "vfio-pci.ids=10de:1c02,10de:10f1"
    ];
    loader = {
      systemd-boot.enable = true;

      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = {
      ntfs = true;
    };

    # Emulate arm to build arm for e.g. pi4
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

  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
    "electron-39.8.10"
  ];

  environment.systemPackages = with pkgs; [
    ddcutil
    lm_sensors
    libthai
    OVMF
  ];
}
