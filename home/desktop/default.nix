{ ... }:

{
  imports = [
    ../default.nix

    ./app.nix
    ./dconf.nix
    ./development.nix
    ./editors.nix
    ./gaming.nix
    ./gtk.nix
    ./hyprland.nix
    ./mail.nix
    ./terminal.nix
    ./xdg.nix
  ];
}
