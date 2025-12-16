{
  modulesPath,
  system,
  lib,
  ...
}:

let
  # We need the absolute path to the project root for the imports
  # A requirement by nixos-generators
  PROJECT_ROOT = builtins.getEnv "PWD";
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"

    # Import the server configuration
    # This entrypoint would be called by the default in sirius which also imports the hardware configuration
    "${PROJECT_ROOT}/hosts/desktop/default.nix"
  ];

  # Is that required? Idk, but it's here
  nixpkgs.hostPlatform = system;

  # Use serial connection so that we can use the terminal correctly
  boot.kernelParams = [
    "console=ttyS0,115200"
    "console=tty1"
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];

  # Disable NVIDIA
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia-container-toolkit.enable = lib.mkForce false;
  services.xserver.videoDrivers = lib.mkForce [ ];
  networking.networkmanager.enable = lib.mkForce false;
  hardware.nvidia = lib.mkForce {
    modesetting.enable = false;
    nvidiaSettings = false;
  };
}
