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

    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  programs.home-manager.enable = true;
  home = {
    stateVersion = stateVersion;

    username = meta.user.username;
    homeDirectory = meta.user.homeDir;
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
