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
    ./terminal.nix
    ./xdg.nix
  ];
}
