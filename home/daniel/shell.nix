{ pkgs, ... }:

let
  shellAliases = {
    cat = "bat";

    bye = "shutdown -h now";
    cya = "reboot";

    woman = "man";

    files = "yazi";
    f = "yazi";
  };
in
{
  # zsh
  programs.zsh = {
    enable = true;

    shellAliases = shellAliases;

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initExtra = ''
    if [ "$(tty)" = "/dev/tty1" ]; then
      exec Hyprland &> /dev/null
    fi
    '';
    # initExtra = ''
    #   source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    #   bindkey "''${key[Up]}" up-line-or-search
    # '';
  };

  # oh-my-posh
  programs.oh-my-posh =
    let
      settings = builtins.fromJSON (builtins.readFile ../../dots/oh-my-posh/settings.json);
    in
    {
      enable = true;

      enableZshIntegration = true;
      enableNushellIntegration = true;

      settings = settings;
    };

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
    };
  };

  programs.git = {
    enable = true;

    userEmail = "me@micartey.dev";
    userName = "micartey";

    # fancier git diff
    delta.enable = true;

    extraConfig = {
      color.ui = true;
      core.editor = "code";
      github.user = "micartey";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };

    aliases = {
      graph = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
    };
  };

  programs.zoxide = {
    enable = true;

    enableNushellIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.btop.enable = true;
  programs.fastfetch.enable = true;
  programs.fzf.enable = true;
  programs.carapace.enable = true;
  programs.ripgrep.enable = true;
  programs.mpv.enable = true;
  programs.yt-dlp.enable = true;

  home.packages = [
    pkgs.gh
    pkgs.just
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.speedtest-cli
    pkgs.hyperfine
    pkgs.playerctl
    pkgs.ffmpeg
    pkgs.imagemagick
  ];
}
