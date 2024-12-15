{ pkgs, ... }:

let
  shellAliases = {
    cat = "bat";

    bye = "shutdown -h now";
    cya = "reboot";

    # mpv /dev/video0 --audio-file=av://alsa:hw:3,0 \
    # --untimed \
    # --no-cache \
    # --demuxer-lavf-o=probesize=32 \
    # --demuxer-lavf-o=analyzeduration=0 \
    # --demuxer-lavf-o=live=1 \
    # --demuxer-lavf-o=fflags=nobuffer \
    # --demuxer-thread=no \
    # --video-sync=display-desync --no-audio-sync

    # TODO: Need to get hw:3,0 dynamically. "3" in this case stands for card 3,
    # arecord -l
    capture-card = ''
      CAPTURE_CARD_ID=$(arecord -l | grep UGREEN | awk '{print $2}' | cut -c 1)

      mpv /dev/video0 --profile=low-latency --untimed --vf=unsharp=luma_msize_x=5:luma_msize_y=5:luma_amount=-0.1 & PID1=$!; \

      ffplay -fflags nobuffer -flags low_delay -probesize 32 -analyzeduration 0 \
             -f alsa -i hw:$CAPTURE_CARD_ID,0 -nodisp & PID2=$!; \

      wait $PID1 && kill $PID2
    '';
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
