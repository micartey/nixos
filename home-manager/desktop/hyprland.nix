{
  pkgs,
  ...
}:

let
  mainMod = "SUPER";
  subMod = "L_ALT SHIFT";
  ctrlMod = "CTRL";
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    sourceFirst = true;

    settings = {
      # # In case of multiple monitors
      # monitor = [
      # ];

      monitor = [
        "HDMI-A-2, 3440x1440@99.98200, 0x0, 1"
        # "HDMI-A-1, 1920x1080@99.98200, 0x0, 1"
        "DP-4, 400x1280@59.98900, 3440x0, 1, transform, 3"

        "Unknown-1, disable"
      ];

      env = [
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_QPA_PLATFORM,wayland"
        "NVD_BACKEND,direct"

        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"

        "ELECTRON_OZONE_PLATFORM_HINT,auto"

        # hyprcursor
        "HYPRCURSOR_SIZE,26"
        "HYPRCURSOR_THEME,Catppuccin-Mocha-Light-Cursors"
      ];

      exec-once = [
        "watch -n 0 wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 100%"
        "wl-paste --type text --watch cliphist store"

        # "vesktop"
        # "element-desktop"

        # "waybar"
      ];

      debug = {
        disable_logs = false;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      bind = [
        # Application Launcher
        # noctalia-shell ipc call launcher toggle
        "${mainMod}, SPACE, exec, rofi -show drun -show-icons"

        # Emoji
        # noctalia-shell ipc call launcher emoji
        "${mainMod}, M, exec, bemoji"

        # Clipboard History
        # noctalia-shell ipc call launcher clipboard
        "CTRL SHIFT, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # "${mainMod}, p, exec, swaync-client -t"

        ", F7, exec, hyprshot -m region --clipboard-only"
        ", F8, exec, nix run github:micartey/viro"

        "${mainMod}, T, exec, kitty"

        # "${mainMod}, I, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        # "${mainMod}, O, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

        # Overlay workspace
        "${ctrlMod}, 0, togglespecialworkspace,"
        "${ctrlMod} SHIFT, 0, movetoworkspace, special"

        # Float window
        "${mainMod}, V, togglefloating,"
        "${mainMod}, V, centerwindow,"

        # "${mainMod}, N, swapnext,"
        "${ctrlMod} SHIFT, Q, killactive,"

        # Fullscreen window
        "${mainMod}, up, fullscreen, 1"
        ", F11, fullscreen,"

        # Window controls (left ritgh up down)
        "${subMod}, up, movefocus, u"
        "${subMod}, left, movefocus, l"
        "${subMod}, down, movefocus, d"
        "${subMod}, right, movefocus, r"

        # Jump to workspace
        "${ctrlMod}, 1, workspace, 1"
        "${ctrlMod}, 2, workspace, 2"
        "${ctrlMod}, 3, workspace, 3"
        "${ctrlMod}, 4, workspace, 4"
        "${ctrlMod}, 5, workspace, 5"
        "${ctrlMod}, 6, workspace, 6"
        "${ctrlMod}, 8, workspace, 8"

        "${ctrlMod} SHIFT, 1, movetoworkspace, 1"
        "${ctrlMod} SHIFT, 2, movetoworkspace, 2"
        "${ctrlMod} SHIFT, 3, movetoworkspace, 3"
        "${ctrlMod} SHIFT, 4, movetoworkspace, 4"
        "${ctrlMod} SHIFT, 5, movetoworkspace, 5"
        "${ctrlMod} SHIFT, 6, movetoworkspace, 6"
        "${ctrlMod} SHIFT, 8, movetoworkspace, 8"

        # Window dragging
        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"

        # Toggle Network delay
        "${mainMod}, 1, exec, sudo tc qdisc add dev enp14s0 root netem delay 120ms"
        "${mainMod}, 2, exec, sudo tc qdisc add dev enp14s0 root netem delay 10ms 50ms distribution normal loss 20%"
        "${mainMod}, 3, exec, sudo tc qdisc add dev enp14s0 root netem loss 100%"
        "${mainMod}, 0, exec, sudo tc qdisc del dev enp14s0 root"
      ];

      # Window drag
      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "float,title:(Picture-in-picture)"
        "float,title:(Picture-in-Picture)"
        "float,class:(Rofi)"
        "float,title:(Save File)"
        "float,title:(Open File)"
        "float,initialTitle:(discord popout)"

        "workspace 1,initialTitle:(YouTube Music)"
        "noanim,initialClass:^(Minecraft\*\s1\.20\.6)$"
        "noblur,initialClass:^(Minecraft\*\s1\.20\.6)$"

        "pin,title:(.*)is sharing your screen(.*)"
        "move 100%-w-35% 0%,title:(.*)is sharing your screen(.*)"
        "bordersize 0,title:(.*)is sharing your screen(.*)"

        # Vesktop (Discord)
        "float,initialClass:(vesktop)"
        "size 2549 1123,initialClass:(vesktop)"
        "center, initialClass:(vesktop)"
        "workspace 2,initialClass:(vesktop)"

        # IntelliJ
        "float,title:(Welcome to IntelliJ IDEA)"
        "size 1358 682,title:(Welcome to IntelliJ IDEA)"
        "center,title:(Welcome to IntelliJ IDEA)"

        # Viro
        "float,class:(.*)viro(.*)$"
        "bordersize 0, class:(.*)viro(.*)$"
        "noblur, title:^(Radial-Menu)$"
        "noshadow, title:^(Radial-Menu)$"
      ];

      # Pin workspaces to display output
      workspace = [
        "1, monitor:HDMI-A-2"
        "2, monitor:HDMI-A-2"
        "3, monitor:HDMI-A-2"
        "4, monitor:HDMI-A-2"
        "5, monitor:HDMI-A-2"
        "6, monitor:HDMI-A-2"

        "8, monitor:DP-4"
      ];

      layerrule = [
        "blur, rofi"
      ];

      input = {
        kb_layout = "de";
        kb_variant = ",qwertz";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "no";
        };
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 30;
        border_size = 2;

        "col.active_border" = "$mauve $lavender 45deg";
        "col.inactive_border" = "rgba(7c4ec5aa)";

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 2;
          passes = 3;
        };

        #"drop_shadow" = "yes";
        #shadow_range = 4;
        #shadow_render_power = 3;
        #"col.shadow" = "$crust";
      };

      animations = {
        enabled = "yes";

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      misc = {
        force_default_wallpaper = 0;
        mouse_move_enables_dpms = false;
        vrr = 1;
      };
    };
  };

  # xdg
  xdg.portal = {
    enable = true;
    config = {
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };

  # auto mount removable drives
  services.udiskie.enable = true;
  # TODO: should this be enabled for non-hyprland?

  # hyprcursor icons directory
  home.file.".icons" = {
    enable = true;
    source = "${pkgs.catppuccin-cursors.mochaLight}/share/icons/";
    target = ".icons";
  };

  home.packages = [
    # emoji quick access
    pkgs.bemoji

    # waybar
    pkgs.waybar

    # notifications
    pkgs.libnotify

    # screenshot
    pkgs.grim
    pkgs.hyprshot

    # clipboard
    pkgs.wl-clipboard
    pkgs.cliphist

    # hyprcursor
    pkgs.hyprcursor
    pkgs.catppuccin-cursors.mochaMauve

    # miscellaneous
    pkgs.xdg-utils

    # For waybar clock
    pkgs.tzdata
  ];
}
