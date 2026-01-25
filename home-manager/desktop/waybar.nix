{ pkgs, ... }:

{
  home.packages = [
    # waybar
    # pkgs.waybar

    # notifications
    # pkgs.libnotify

    pkgs.brightnessctl
  ];

  programs.waybar = {
    enable = false;

    style = builtins.readFile ../../dots/waybar/style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [
          "temperature"
          "memory"
          "cpu"
          "custom/nvidia"
          "battery"
          "backlight"
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

        battery = {
          states = {
            warning = 40;
            critical = 20;
          };
          format = "󰁹 {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
        };

        backlight = {
          format = "   {percent}%";
          min-brightness = 2;
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-number = true;
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
          max-length = 18;
        };

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
        };
      };
    };
  };
}
