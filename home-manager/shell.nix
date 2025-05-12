{ pkgs, meta, ... }:

let
  shellAliases = {
    cat = "bat";

    fernunivpn = "openconnect --protocol=anyconnect -u $(cat ~/.fernuni-hagen/matrikelnummer.txt) vpn.fernuni-hagen.de";
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
        if [ ! -e "/tmp/hyprlockshell" ]; then
            mktemp /tmp/hyprlockshell
            exec Hyprland
        fi
      fi

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';

    # initExtra = ''
    #   source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    #   bindkey "''${key[Up]}" up-line-or-search
    # '';
  };

  # oh-my-posh
  programs.oh-my-posh =
    let
      settings = builtins.fromJSON (builtins.readFile ../dots/oh-my-posh/settings.json);
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

    userEmail = meta.git.email;
    userName = meta.git.username;

    # fancier git diff
    delta.enable = true;

    extraConfig = {
      color.ui = true;
      core.editor = "vim";
      github.user = meta.git.username;
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
  programs.yt-dlp.enable = true;

  home.packages = [
    pkgs.just
    pkgs.tree
    pkgs.zip
    pkgs.unzip
    pkgs.hyperfine
    pkgs.playerctl
    pkgs.ffmpeg
    pkgs.imagemagick
  ];
}
