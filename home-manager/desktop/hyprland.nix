{
  lib,
  pkgs,
  ...
}:

let
  mainMod = "SUPER";
  subMod = "ALT + SHIFT";
  ctrlMod = "CTRL";
  mkLua = lib.generators.mkLuaInline;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    xwayland.enable = true;

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    settings = {
      monitor = [
        {
          output = "HDMI-A-2";
          mode = "3440x1440@99.98200";
          position = "0x0";
          scale = 1;
        }
        {
          output = "DP-4";
          mode = "400x1280@59.98900";
          position = "3440x0";
          scale = 1;
          transform = 3;
        }
        {
          output = "Unknown-1";
          disabled = true;
        }
      ];

      env = [
        {
          _args = [
            "QT_WAYLAND_DISABLE_WINDOWDECORATION"
            "1"
          ];
        }
        {
          _args = [
            "QT_QPA_PLATFORM"
            "wayland"
          ];
        }
        {
          _args = [
            "NVD_BACKEND"
            "direct"
          ];
        }
        {
          _args = [
            "XDG_CURRENT_DESKTOP"
            "Hyprland"
          ];
        }
        {
          _args = [
            "XDG_SESSION_TYPE"
            "wayland"
          ];
        }
        {
          _args = [
            "ELECTRON_OZONE_PLATFORM_HINT"
            "auto"
          ];
        }
        {
          _args = [
            "HYPRCURSOR_SIZE"
            "26"
          ];
        }
        {
          _args = [
            "HYPRCURSOR_THEME"
            "Catppuccin-Mocha-Light-Cursors"
          ];
        }
      ];

      on = {
        _args = [
          "hyprland.start"
          (mkLua ''
            function()
              hl.exec_cmd("wl-paste --type text --watch cliphist store")
            end
          '')
        ];
      };

      config = {
        debug = {
          disable_logs = false;
        };

        cursor = {
          no_hardware_cursors = true;
        };

        scrolling = {
          column_width = 0.75;
        };

        general = {
          gaps_in = 5;
          gaps_out = 30;
          border_size = 2;

          col = {
            active_border = {
              colors = [
                (mkLua "require('themes.catppuccin').mauve")
                (mkLua "require('themes.catppuccin').lavender")
              ];
              angle = 45;
            };
            inactive_border = "rgba(7c4ec5aa)";
          };

          layout = "dwindle";
        };

        decoration = {
          rounding = 10;

          blur = {
            enabled = true;
            size = 2;
            passes = 3;
          };
        };

        dwindle = {
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = 0;
          initial_workspace_tracking = 0;
          mouse_move_enables_dpms = false;
          vrr = 1;
        };

        input = {
          kb_layout = "de";
          kb_variant = ",qwertz";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0;
        };

        animations = {
          enabled = true;
        };
      };

      curve = {
        _args = [
          "myBezier"
          {
            type = "bezier";
            points = [
              [
                0.05
                0.9
              ]
              [
                0.1
                1.05
              ]
            ];
          }
        ];
      };

      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 7;
          bezier = "myBezier";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 7;
          bezier = "default";
          style = "popin 80%";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "borderangle";
          enabled = true;
          speed = 8;
          bezier = "default";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 7;
          bezier = "default";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 6;
          bezier = "default";
        }
      ];

      bind = [
        # Window drag (mouse binds)
        {
          _args = [
            "${mainMod} + mouse:272"
            (mkLua "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }
        {
          _args = [
            "${mainMod} + mouse:273"
            (mkLua "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }

        # Application Launcher
        {
          _args = [
            "${mainMod} + SPACE"
            (mkLua "hl.dsp.exec_cmd(\"rofi -show drun -show-icons\")")
          ];
        }

        # Emoji
        {
          _args = [
            "${mainMod} + M"
            (mkLua "hl.dsp.exec_cmd(\"bemoji\")")
          ];
        }

        # Clipboard History
        {
          _args = [
            "CTRL + SHIFT + v"
            (mkLua "hl.dsp.exec_cmd(\"cliphist list | rofi -dmenu | cliphist decode | wl-copy\")")
          ];
        }

        # Screenshot / Viro
        {
          _args = [
            "F7"
            (mkLua "hl.dsp.exec_cmd(\"hyprshot -m region --clipboard-only\")")
          ];
        }
        {
          _args = [
            "F8"
            (mkLua "hl.dsp.exec_cmd(\"viro\")")
          ];
        }

        # Terminal
        {
          _args = [
            "${mainMod} + T"
            (mkLua "hl.dsp.exec_cmd(\"kitty\")")
          ];
        }

        # Overlay workspace
        {
          _args = [
            "${ctrlMod} + 0"
            (mkLua "hl.dsp.workspace.toggle_special(\"special\")")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 0"
            (mkLua "hl.dsp.window.move({ workspace = \"special\" })")
          ];
        }

        # Float window
        {
          _args = [
            "${mainMod} + V"
            (mkLua "hl.dsp.window.float({ action = \"toggle\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + V"
            (mkLua "hl.dsp.window.center()")
          ];
        }

        # Kill window
        {
          _args = [
            "${ctrlMod} + SHIFT + Q"
            (mkLua "hl.dsp.window.close()")
          ];
        }

        # Fullscreen
        {
          _args = [
            "${mainMod} + up"
            (mkLua "hl.dsp.window.fullscreen({ mode = \"maximized\" })")
          ];
        }
        {
          _args = [
            "F11"
            (mkLua "hl.dsp.window.fullscreen()")
          ];
        }

        # Window controls (left right up down)
        {
          _args = [
            "${subMod} + up"
            (mkLua "hl.dsp.focus({ direction = \"up\" })")
          ];
        }
        {
          _args = [
            "${subMod} + left"
            (mkLua "hl.dsp.focus({ direction = \"left\" })")
          ];
        }
        {
          _args = [
            "${subMod} + down"
            (mkLua "hl.dsp.focus({ direction = \"down\" })")
          ];
        }
        {
          _args = [
            "${subMod} + right"
            (mkLua "hl.dsp.focus({ direction = \"right\" })")
          ];
        }

        # Scroll
        {
          _args = [
            "${mainMod} + SHIFT + mouse_down"
            (mkLua "hl.dsp.layout(\"move +col\")")
          ];
        }
        {
          _args = [
            "${mainMod} + SHIFT + mouse_up"
            (mkLua "hl.dsp.layout(\"move -col\")")
          ];
        }

        # Jump to workspace
        {
          _args = [
            "${ctrlMod} + 1"
            (mkLua "hl.dsp.focus({ workspace = 1 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + 2"
            (mkLua "hl.dsp.focus({ workspace = 2 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + 3"
            (mkLua "hl.dsp.focus({ workspace = 3 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + 4"
            (mkLua "hl.dsp.focus({ workspace = 4 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + 5"
            (mkLua "hl.dsp.focus({ workspace = 5 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + 6"
            (mkLua "hl.dsp.focus({ workspace = 6 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + 8"
            (mkLua "hl.dsp.focus({ workspace = 8 })")
          ];
        }

        # Move window to workspace
        {
          _args = [
            "${ctrlMod} + SHIFT + 1"
            (mkLua "hl.dsp.window.move({ workspace = 1 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 2"
            (mkLua "hl.dsp.window.move({ workspace = 2 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 3"
            (mkLua "hl.dsp.window.move({ workspace = 3 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 4"
            (mkLua "hl.dsp.window.move({ workspace = 4 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 5"
            (mkLua "hl.dsp.window.move({ workspace = 5 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 6"
            (mkLua "hl.dsp.window.move({ workspace = 6 })")
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 8"
            (mkLua "hl.dsp.window.move({ workspace = 8 })")
          ];
        }

        # Window dragging (scroll)
        {
          _args = [
            "${mainMod} + mouse_down"
            (mkLua "hl.dsp.focus({ workspace = \"+1\" })")
          ];
        }
        {
          _args = [
            "${mainMod} + mouse_up"
            (mkLua "hl.dsp.focus({ workspace = \"-1\" })")
          ];
        }

        # Toggle Network delay
        {
          _args = [
            "${mainMod} + 1"
            (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc add dev enp14s0 root netem delay 120ms\")")
          ];
        }
        {
          _args = [
            "${mainMod} + 2"
            (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc add dev enp14s0 root netem delay 10ms 50ms distribution normal loss 20%\")")
          ];
        }
        {
          _args = [
            "${mainMod} + 3"
            (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc add dev enp14s0 root netem loss 100%\")")
          ];
        }
        {
          _args = [
            "${mainMod} + 0"
            (mkLua "hl.dsp.exec_cmd(\"sudo tc qdisc del dev enp14s0 root\")")
          ];
        }
      ];

      window_rule = [
        {
          match.title = "Picture-in-picture";
          float = true;
        }
        {
          match.title = "Picture-in-Picture";
          float = true;
        }
        {
          match.class = "Rofi";
          float = true;
        }
        {
          match.title = "Save File";
          float = true;
        }
        {
          match.title = "Open File";
          float = true;
        }
        {
          match.initial_title = "discord popout";
          float = true;
        }

        {
          match.initial_title = "YouTube Music";
          workspace = "1";
        }
        {
          match.initial_class = "^(Minecraft\\*\\s1\\.20\\.6)$";
          no_anim = true;
        }
        {
          match.initial_class = "^(Minecraft\\*\\s1\\.20\\.6)$";
          no_blur = true;
        }

        {
          match.title = "(.*)is sharing your screen(.*)";
          pin = true;
        }
        {
          match.title = "(.*)is sharing your screen(.*)";
          move = "100%-w-35% 0%";
        }
        {
          match.title = "(.*)is sharing your screen(.*)";
          border_size = 0;
        }

        # Vesktop (Discord)
        {
          match.initial_class = "vesktop";
          float = true;
        }
        {
          match.initial_class = "vesktop";
          size = [
            2549
            1123
          ];
        }
        {
          match.initial_class = "vesktop";
          center = true;
        }
        {
          match.initial_class = "vesktop";
          workspace = "2";
        }

        # IntelliJ
        {
          match.title = "Welcome to IntelliJ IDEA";
          float = true;
        }
        {
          match.title = "Welcome to IntelliJ IDEA";
          size = [
            1358
            682
          ];
        }
        {
          match.title = "Welcome to IntelliJ IDEA";
          center = true;
        }

        # Viro
        {
          match.class = "(.*)viro(.*)$";
          float = true;
        }
        {
          match.class = "(.*)viro(.*)$";
          border_size = 0;
        }
        {
          match.title = "^(Radial-Menu)$";
          no_blur = true;
        }
        {
          match.title = "^(Radial-Menu)$";
          no_shadow = true;
        }
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "2";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "3";
          monitor = "HDMI-A-2";
          # layout = "scrolling";
        }
        {
          workspace = "4";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "5";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "6";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "7";
          monitor = "HDMI-A-2";
        }
        {
          workspace = "8";
          monitor = "DP-4";
        }
      ];

      layer_rule = [
        {
          match.namespace = "rofi";
          blur = true;
        }
      ];
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

  # hyprcursor icons directory
  home.file.".icons" = {
    enable = true;
    source = "${pkgs.catppuccin-cursors.mochaLight}/share/icons/";
    target = ".icons";
  };

  home.packages = [
    pkgs.bemoji
    pkgs.waybar
    pkgs.libnotify
    pkgs.grim
    pkgs.hyprshot
    pkgs.wl-clipboard
    pkgs.cliphist
    pkgs.hyprcursor
    pkgs.catppuccin-cursors.mochaMauve
    pkgs.xdg-utils
    pkgs.tzdata
  ];
}
