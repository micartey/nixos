{
  profiles = [ "default" ];

  programs.zsh = {
    enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
}
