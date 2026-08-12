{
  modulesPath,
  system,
  lib,
  pkgs,
  ...
}:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"

    # Import the server configuration
    # This entrypoint would be called by the default in sirius which also imports the hardware configuration
    "${PROJECT_ROOT}/hosts/desktop/default.nix"
    ./nvidia.nix
  ];

  # Is that required? Idk, but it's here
  nixpkgs.hostPlatform = system;

  # Use serial connection so that we can use the terminal correctly
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
    "electron-39.8.10"
  ];

  # Workaround to mount /dev/vga using commands rather than nix
  systemd.services.mount-storage = {
    description = "Mount /mnt/storage";
    wantedBy = [ "multi-user.target" ];
    after = [ "dev-vda.device" ];
    bindsTo = [ "dev-vda.device" ];
    path = [
      pkgs.util-linux
      pkgs.e2fsprogs
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ! blkid /dev/vda; then
        mkfs.ext4 /dev/vda
      fi
      mkdir -p /mnt/storage
      mount /dev/vda /mnt/storage
    '';
  };

  # Disable pid on vm
  boot.kernelPatches = lib.mkForce [
    {
      name = "hide-tracer-pid";
      patch = ../../patches/hide-tracer-pid.patch;
    }
  ];
}
