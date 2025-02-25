{ ... }:

{
  imports = [
    ../default.nix

    ./app.nix
    ./dconf.nix
    ./development.nix
    ./editors.nix
    ./gtk.nix
    ./hyprland.nix
    ./mpv.nix
    ./rofi.nix
    ./terminal.nix
    ./xdg.nix
  ];
}
