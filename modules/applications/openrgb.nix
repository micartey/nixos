{ pkgs-edge, ... }:

{
  profiles = [ "home" ];

  services.hardware.openrgb = {
    enable = true;
    package = pkgs-edge.openrgb;
  };

  environment.systemPackages = [
    pkgs-edge.openrgb
  ];
}
