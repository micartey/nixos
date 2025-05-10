{ pkgs, ... }:

{
  home.packages = [
    pkgs.protonup-qt
    pkgs.wineWowPackages.waylandFull
    # pkgs.winetricks

    # pkgs-unstable.prismlauncher
    # pkgs-unstable.glfw-wayland-minecraft

    # pkgs.gamemode
    # pkgs.gamescope
    # pkgs.gamescope-wsi
  ];
}
