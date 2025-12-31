{
  stateVersion,
  meta,
  inputs,
  ...
}:

{
  programs.home-manager.enable = true;
  home = {
    stateVersion = stateVersion;

    username = meta.user.username;
    homeDirectory = meta.user.homeDir;
  };

  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${meta.user.username}/.config/sops/age/keys.txt";
}
