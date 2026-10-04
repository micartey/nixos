{ lib, pkgs, ... }:

let
  mkLua = lib.generators.mkLuaInline;
in
{
  imports = [ ../../home-manager ];

  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce [
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

    config = {
      scrolling.column_width = lib.mkForce 0.85;
      general.layout = lib.mkForce "scrolling";
      input.touchpad.natural_scroll = lib.mkForce true;
    };

    on._args = lib.mkForce [
      "hyprland.start"
      (mkLua ''
        function()
          hl.exec_cmd("wl-paste --type text --watch cliphist store")
          hl.exec_cmd("brightnessctl set 55%")
        end
      '')
    ];

    workspace_rule = lib.mkForce [ ];

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
    ];
  };

  home.packages = with pkgs; [
    brightnessctl
    davinci-resolve
    lunar-client
    wineWow64Packages.waylandFull
  ];

  xdg.desktopEntries.davinci-custom = {
    name = "Davinci Resolve (Fix)";
    genericName = "Video Editor";
    comment = "Davinci Resolve with AMD launch fixes";
    exec = "env ROC_ENABLE_PRE_VEGA=1 RUSTICL_ENABLE=amdgpu,amdgpu-pro,radv,radeon DRI_PRIME=1 QT_QPA_PLATFORM=xcb davinci-resolve";
    icon = "davinci-resolve";
  };
}
