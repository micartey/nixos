{
  pkgs,
  meta,
  config,
  ...
}:

let
  shellAliases = {
    cat = "bat";

    fernunivpn = "openconnect --protocol=anyconnect -u $(cat ~/.fernuni-hagen/matrikelnummer.txt) vpn.fernuni-hagen.de";

    s = "nix-shell --run zsh -p";
    codex = "bunx @openai/codex";

    "?" = "opencode run";

    # git alias
    gp = "git push";
    gc = "git commit";
    ga = "git add";
    gs = "git status";

    capture-card = ''
      CAPTURE_CARD_ID=$(arecord -l | grep UGREEN | awk '{print $2}' | cut -c 1)

      mpv /dev/video0 --profile=low-latency --untimed & PID1=$!; \

      ffplay -fflags nobuffer -flags low_delay -probesize 32 -analyzeduration 0 \
             -f alsa -i hw:$CAPTURE_CARD_ID,0 -nodisp & PID2=$!; \

      wait $PID1 && kill $PID2
    '';

    stream-audio = ''
      pw-cat -r --target $(wpctl status | grep "Easy Effects Source" | sed -n 's/^[^0-9]*\([0-9]*\)\..*/\1/p') --format s16 --rate 44100 --channels 2 - \
        | nc pi.local 12345
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

    initContent = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland &> /dev/null
      fi

      cdn() {
        # Upload file
        curl --interface tailscale0 -X PUT -F "file=@$1" http://kvm-large:7080/api/v1/upload/blob || return 1

        echo -e "\n\n"

        local url="https://cdn.micartey.dev/api/v1/download/blob/$1"
        if [[ "$1" == *.mp4 ]]; then
          url="https://cdn.micartey.dev/api/v1/stream/blob/$1"
          local encoded_url=$(echo -n "$url" | base64 -w 0)
          url="https://cdn.micartey.dev/preview/video/$encoded_url"
        fi

        echo "$url"
        wl-copy "$url"
      }

      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';

    # initExtra = ''
    #   source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    #   bindkey "''${key[Up]}" up-line-or-search
    # '';
  };

  # Don't autostart Hyprland with "no-desktop" specialisation
  specialisation.no-desktop.configuration = {
    programs.zsh.initContent = ''
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
    '';
  };

  programs.bash = {
    enable = true;
  };

  programs.eza = {
    enable = true;

    git = config.programs.git.enable;
    icons = "auto";

    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
  };

  # oh-my-posh
  programs.oh-my-posh =
    let
      settings = builtins.fromJSON (builtins.readFile ../../dots/oh-my-posh/settings.json);
    in
    {
      enable = true;

      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;

      enableNushellIntegration = true;

      settings = settings;
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

  programs.btop = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.fastfetch.enable = true;
  programs.fzf.enable = true;
  programs.carapace.enable = true;
  programs.ripgrep.enable = true;
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
  ];
}
