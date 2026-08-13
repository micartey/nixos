{
  meta,
  ...
}:

{
  profiles = [ "default" ];
  programs.home-manager.enable = true;
  home = {
    username = meta.user.username;
    homeDirectory = meta.user.homeDir;
  };
}
