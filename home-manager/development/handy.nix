{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  mkLua = lib.generators.mkLuaInline;
in
{
  home.packages = [
    inputs.handy.packages.${pkgs.system}.default

    pkgs.wtype
  ];

  wayland.windowManager.hyprland.settings.bind = [
    {
      _args = [
        "SUPER + C"
        (mkLua "hl.dsp.exec_cmd(\"sleep 0.3; pkill -USR2 -x handy || pkill -USR2 -x .handy-wrapped\")")
      ];
    }
  ];
}
