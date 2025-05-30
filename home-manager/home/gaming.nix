{ pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    pkgs.lutris
    pkgs.protonup-qt
    pkgs.bottles
    pkgs.wineWowPackages.waylandFull
    pkgs.winetricks

    pkgs-unstable.prismlauncher
    pkgs-unstable.glfw-wayland-minecraft
    pkgs-unstable.lunar-client

    pkgs-unstable.r2modman

    pkgs.gamemode
    pkgs.gamescope
    pkgs.gamescope-wsi
  ];
}
