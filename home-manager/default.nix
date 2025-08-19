{
  inputs,
  stateVersion,
  meta,
  ...
}:

{
  imports = [
    ./editor.nix
    ./shell.nix

    inputs.catppuccin.homeModules.catppuccin
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = stateVersion;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
