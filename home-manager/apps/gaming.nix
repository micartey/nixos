{ pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    pkgs.lutris
    pkgs.protonup-qt
    pkgs.bottles
    pkgs.wineWowPackages.waylandFull
    pkgs.winetricks

    pkgs.prismlauncher
    pkgs-unstable.glfw3-minecraft
    pkgs-unstable.lunar-client

    pkgs-unstable.r2modman

    pkgs.gamemode
    pkgs.gamescope
    pkgs.gamescope-wsi
  ];
}
