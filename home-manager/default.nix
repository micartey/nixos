{ inputs, ... }:

{
  imports = [
    ./editor.nix
    ./shell.nix

    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = "24.11";

    username = "daniel";
    homeDirectory = "/home/daniel";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
