{ pkgs-edge, ... }:

# @profile home
{
  services.hardware.openrgb = {
    enable = true;
    package = pkgs-edge.openrgb;
  };

  environment.systemPackages = [
    pkgs-edge.openrgb
  ];
}
