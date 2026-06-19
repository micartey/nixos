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
  # Copy wallpapers to local directory
  home.file = {
    wallpapers = {
      source = ../../dots/wallpapers;
      target = ".local/nix-wallpapers";
    };
  };

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
          output = "eDP-1";
          mode = "3072x1920@60.00000";
          position = "0x0";
          scale = 2;
        }
        {
          output = "Unknown-1";
          disabled = true;
        }
      ];

      env = [
        {
          _args = [
            "LIBVA_DRIVER_NAME"
            "nvidia"
          ];
        }
        {
          _args = [
            "__GLX_VENDOR_LIBRARY_NAME"
            "nvidia"
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
              hl.exec_cmd("brightnessctl s 55%")
              hl.exec_cmd("waybar")
            end
          '')
        ];
      };

      config = {
        debug = {
          disable_logs = false;
        };

        scrolling = {
          column_width = 0.85;
        };

        cursor = {
          no_hardware_cursors = true;
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

          layout = "scrolling";
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
          #pseudotile = true;
          preserve_split = true;
        };

        misc = {
          force_default_wallpaper = 0;
          mouse_move_enables_dpms = false;
          disable_watchdog_warning = true;
          vrr = 1;
        };

        input = {
          kb_layout = "de";
          kb_variant = ",qwertz";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
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
            "${mainMod} + SHIFT + mouse:272"
            (mkLua "hl.dsp.window.resize()")
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
            (mkLua ''hl.dsp.exec_cmd("rofi -show drun -show-icons")'')
          ];
        }

        # Emoji
        {
          _args = [
            "${mainMod} + M"
            (mkLua ''hl.dsp.exec_cmd("bemoji")'')
          ];
        }

        # Clipboard History
        {
          _args = [
            "CTRL + SHIFT + v"
            (mkLua ''hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy")'')
          ];
        }

        # Screenshot
        {
          _args = [
            "F7"
            (mkLua ''hl.dsp.exec_cmd("hyprshot -m region --clipboard-only")'')
          ];
        }

        # Terminal
        {
          _args = [
            "${mainMod} + T"
            (mkLua ''hl.dsp.exec_cmd("kitty")'')
          ];
        }

        # Overlay workspace
        {
          _args = [
            "${ctrlMod} + 0"
            (mkLua ''hl.dsp.workspace.toggle_special("special")'')
          ];
        }
        {
          _args = [
            "${ctrlMod} + SHIFT + 0"
            (mkLua ''hl.dsp.window.move({ workspace = "special" })'')
          ];
        }

        # Float window
        {
          _args = [
            "${mainMod} + V"
            (mkLua ''hl.dsp.window.float({ action = "toggle" })'')
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
            (mkLua "hl.dsp.window.fullscreen(true)")
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
            (mkLua ''hl.dsp.focus({ direction = "up" })'')
          ];
        }
        {
          _args = [
            "${subMod} + left"
            (mkLua ''hl.dsp.focus({ direction = "left" })'')
          ];
        }
        {
          _args = [
            "${subMod} + down"
            (mkLua ''hl.dsp.focus({ direction = "down" })'')
          ];
        }
        {
          _args = [
            "${subMod} + right"
            (mkLua ''hl.dsp.focus({ direction = "right" })'')
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

        # Window dragging (scroll)
        {
          _args = [
            "${mainMod} + mouse_down"
            (mkLua ''hl.dsp.focus({ workspace = "e+1" })'')
          ];
        }
        {
          _args = [
            "${mainMod} + mouse_up"
            (mkLua ''hl.dsp.focus({ workspace = "e-1" })'')
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
      splash_offset = 2;

      preload = [ "~/.local/nix-wallpapers/default.jpg" ];
      wallpaper = [
        {
          monitor = "";
          path = "~/.local/nix-wallpapers/default.jpg";
        }
      ];
    };
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

    pkgs.grim
    pkgs.hyprshot

    pkgs.wl-clipboard
    pkgs.cliphist

    pkgs.hyprcursor
    pkgs.catppuccin-cursors.mochaMauve

    pkgs.xdg-utils
  ];
}
