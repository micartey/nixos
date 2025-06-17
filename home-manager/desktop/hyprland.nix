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
  # Copy wallpapers to local directory
  home.file = {
    wallpapers = {
      source = ../../dots/wallpapers;
      target = ".local/nix-wallpapers";
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland.enable = true;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      # # In case of multiple monitors
      # monitor = [
      # ];

      monitor = [
        "eDP-1, 3072x1920@60.00000, 0x0, 2"
        "Unknown-1,disable"
      ];

      env = [
        # "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        # "QT_QPA_PLATFORM,wayland"

        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"

        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"

        "ELECTRON_OZONE_PLATFORM_HINT,auto"

        # hyprcursor
        "HYPRCURSOR_SIZE,26"
        "HYPRCURSOR_THEME,Catppuccin-Mocha-Light-Cursors"
      ];

      exec-once = [
        "wl-paste --type text --watch cliphist store"

        # This is a fix for the case I fuck up and end up setting to 0%
        "brightnessctl s 55%"

        "waybar"
      ];

      debug = {
        disable_logs = false;
      };

      cursor = {
        no_hardware_cursors = true;
      };

      bind = [
        # Application Launcher
        "${mainMod}, SPACE, exec, rofi -show drun -show-icons"
        # Emoji
        "${mainMod}, M, exec, bemoji"
        # Clipboard History
        "CTRL SHIFT, v, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"

        # "${mainMod}, p, exec, swaync-client -t"

        ", F7, exec, hyprshot -m region --clipboard-only"

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

        "${ctrlMod} SHIFT, 1, movetoworkspace, 1"
        "${ctrlMod} SHIFT, 2, movetoworkspace, 2"
        "${ctrlMod} SHIFT, 3, movetoworkspace, 3"
        "${ctrlMod} SHIFT, 4, movetoworkspace, 4"
        "${ctrlMod} SHIFT, 5, movetoworkspace, 5"
        "${ctrlMod} SHIFT, 6, movetoworkspace, 6"

        # Window dragging
        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"
      ];

      # Window drag
      bindm = [
        "${mainMod}, mouse:272, movewindow"
        "${mainMod} SHIFT, mouse:272, resizewindow"
      ];

      windowrule = [ ];

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

        # Vesktop (Discord)"
        "center, initialClass:(vesktop)"
        "workspace 2,initialClass:(vesktop)"

        # IntelliJ
        "float,title:(Welcome to IntelliJ IDEA)"
        "size 1358 682,title:(Welcome to IntelliJ IDEA)"
        "center,title:(Welcome to IntelliJ IDEA)"
      ];

      layerrule = [
        "blur, rofi"
      ];

      input = {
        kb_layout = "de";
        kb_variant = ",qwertz";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = "yes";
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

      gestures = {
        workspace_swipe = "off";
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
        "wlr"
        "gtk"
        "hyprland"
      ];
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
  };

  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [ "~/.local/nix-wallpapers/default.jpg" ];
      wallpaper = [ ",~/.local/nix-wallpapers/default.jpg" ];
    };
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
    pkgs.kdePackages.xwaylandvideobridge
    pkgs.xdg-utils
  ];
}
