{ pkgs-edge, pkgs, ... }:

{
  home.packages = [
    # Settings: Ctrl + Shift + X
    # Run as root 'nix-shell -p xorg.xhost --run "xhost +SI:localuser:root && sudo -E QT_QPA_PLATFORM=xcb rpi-imager"'
    pkgs-edge.rpi-imager

    # Another - more generic - imager
    # Run as root 'sudo caligula burn <PATH>'
    pkgs.caligula

    # Remove image meta data
    pkgs.imagemagick
  ];
}
