{ ... }:

{
  imports = [
    ../default.nix

    ./mpv.nix
    ./app.nix
    ./dconf.nix
    ./development.nix
    ./editors.nix
    ./gaming.nix
    ./video.nix
    ./gtk.nix
    ./hyprland.nix
    ./rofi.nix
    ./mail.nix
    ./terminal.nix
    ./xdg.nix
  ];
}
