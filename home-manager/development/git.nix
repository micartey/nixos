{ meta, ... }:

{
  # fancier git diff
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user = {
        email = meta.git.email;
        name = meta.git.username;
      };

      color.ui = true;
      core.editor = "vim";
      github.user = meta.git.username;
      push.autoSetupRemote = true;
      pull.rebase = true;

      aliases = {
        graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
      };
    };
  };
}
