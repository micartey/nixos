{
  stateVersion,
  meta,
  ...
}:

{
  programs.home-manager.enable = true;
  home = {
    stateVersion = stateVersion;

    username = meta.user.username;
    homeDirectory = meta.user.homeDir;
  };
}
