{ ... }:

{
  # waybar
  programs.waybar = {
    enable = false;
    style = builtins.readFile ../../dots/waybar/style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        # Display waybar only on HDMI (big screen)
        output = [
          "HDMI-A-1"
          "HDMI-A-2"
        ];

        modules-left = [
          "temperature"
          "memory"
          "cpu"
          "custom/nvidia"
          "custom/aiotemp"
          "custom/pumpspeed"
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "custom/spotify"
          "custom/mic"
          "wireplumber"
          "clock"
          "tray"
        ];

        tray = {
          icon-size = 21;
          spacing = 10;
        };

        cpu = {
          format = "   {usage}%";
          interval = 1;
          on-click = "kitty -e btop";
        };

        "custom/nvidia" = {
          format = "󰹑   {}%";
          escape = true;
          interval = 1;
          tooltip = false;
          exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          on-click = "kitty -e nvtop";
          max-length = 50;
        };

        "custom/aiotemp" = {
          format = "  {} °C";
          escape = true;
          interval = 1;
          tooltip = false;
          exec = "sudo liquidctl status | grep 'Liquid temperature' | awk '{print $(NF-1)}'";
          max-length = 50;
        };

        "custom/pumpspeed" = {
          format = "󰈐  {}%";
          escape = true;
          interval = 1;
          tooltip = false;
          exec = "sudo liquidctl status | grep 'Pump duty' | awk '{print $(NF-1)}'";
          max-length = 50;
        };

        # network = {
        #   interval = 1;
        #   format = "{ifname}";
        #   # format-wifi = "{icon} {bandwidthDownBytes}  {bandwidthUpBytes} ";
        #   format-ethernet = "{icon} 󰮏  {bandwidthDownBytes}  󰸇  {bandwidthUpBytes} ";
        #   format-disconnected = "";
        #   # tooltip-format = "{ipaddr}";
        #   # format-linked = "󰈁 {ifname} (No IP)";
        #   # tooltip-format-wifi = "{essid} {icon} {signalStrength}%";
        #   tooltip-format-ethernet = "󰌘 {ifname}";
        #   tooltip-format-disconnected = "󰌙 Disconnected";
        #   max-length = 50;
        # };

        temperature = {
          format = "  {temperatureC} °C";
          hwmon-path = [ "/sys/class/hwmon/hwmon2/temp1_input" ];
          interval = 1;
          on-click = "kitty -e btop";
        };

        memory = {
          format = "   {}%";
          interval = 1;
          on-click = "kitty -e btop";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-number = true;
        };

        # cpu = {
        #   format = "   {usage}%";
        #   interval = 1;
        #   on-click = "kitty -e btop";
        # };

        "custom/mic" = {
          format = "{}";
          escape = true;
          interval = 1;
          tooltip = false;
          exec = ''
            wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print ($NF == "[MUTED]") ? " " : "  " int($2*100)"%"}'
          '';
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          max-length = 50;
        };

        "custom/spotify" = {
          format = "  {}";
          escape = true;
          interval = 1;
          tooltip = false;
          exec = "spotifycli --status";
          on-click = "spotifycli --playpause";
          on-scroll-up = "spotifycli --next";
          on-scroll-down = "spotifycli --prev";
          max-length = 50;
        };

        wireplumber = {
          format = "{icon}   {volume}%";
          format-muted = " ";
          format-icons = {
            default = [
              ""
              ""
              " "
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };

        clock = {
          timezone = "Europe/Berlin";
          format = "{:%d.%m.%Y %H:%M}";

          tooltip-format = "<tt><small>{calendar}</small></tt>";

          # https://github.com/Alexays/Waybar/wiki/Module:-Clock
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#d6d2d4'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#b33e5f'><b>{}</b></span>";
            };
          };
        };
      };
    };
  };
}
