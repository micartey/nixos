{ pkgs-edge, pkgs, ... }:

{
  home.packages = [
    # Settings: Ctrl + Shift + X
    # Run as root 'sudo rpi-imager'
    pkgs-edge.rpi-imager

    # Another - more generic - imager
    # Run as root 'sudo caligula burn <PATH>'
    pkgs.caligula
  ];
}
