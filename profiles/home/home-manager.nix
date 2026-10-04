{ lib, ... }:

let
  mkLua = lib.generators.mkLuaInline;
in
{
  imports = [
    ../../home-manager
  ];

  wayland.windowManager.hyprland.settings = {
    env = [
      {
        _args = [
          "NVD_BACKEND"
          "direct"
        ];
      }
    ];

    bind = [
      {
        _args = [
          "SUPER + 1"
          (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc add dev enp14s0 root netem delay 120ms\")")
        ];
      }
      {
        _args = [
          "SUPER + 2"
          (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc add dev enp14s0 root netem delay 10ms 50ms distribution normal loss 20%\")")
        ];
      }
      {
        _args = [
          "SUPER + 3"
          (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc add dev enp14s0 root netem loss 100%\")")
        ];
      }
      {
        _args = [
          "SUPER + 0"
          (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc del dev enp14s0 root\")")
        ];
      }
    ];
  };

  programs.zsh.shellAliases = {
    capture-card = ''
      CAPTURE_CARD_ID=$(arecord -l | grep UGREEN | awk '{print $2}' | cut -c 1)

      mpv /dev/video0 --profile=low-latency --untimed & PID1=$!; \

      ffplay -fflags nobuffer -flags low_delay -probesize 32 -analyzeduration 0 \
             -f alsa -i hw:$CAPTURE_CARD_ID,0 -nodisp & PID2=$!; \

      wait $PID1 && kill $PID2
    '';

    stream-audio = ''
      pw-cat -r --target $(wpctl status | grep "Easy Effects Source" | sed -n 's/^[^0-9]*\([0-9]*\)\..*/\1/p' | head -n 1) --format s16 --rate 44100 --channels 2 - \
        | nc homepod.local 12345
    '';
  };

  xdg.desktopEntries.steam = {
    name = "Steam (Mullvad)";
    genericName = "Game Library";
    comment = "Steam with mullvad exclude";
    exec = "mullvad-exclude steam %U";
    icon = "steam";
  };
}
