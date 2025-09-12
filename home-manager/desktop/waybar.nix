{ pkgs, ... }:

{
  home.packages = [
    # waybar
    pkgs.waybar

    # notifications
    pkgs.libnotify

    pkgs.brightnessctl
  ];

  programs.waybar = {
    enable = true;

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
        ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "custom/mic"
          "wireplumber"
          "backlight"
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
            warning = 20;
            critical = 15;
          };
          format = "󰁹 {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-number = true;
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
          format = "{:%d/%m/%Y %H:%M}";
        };

        backlight = {
          format = "   {percent}%";
          min-brightness = 2;
        };
      };
    };
  };
}
