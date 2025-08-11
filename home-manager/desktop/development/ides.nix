{ pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    # jetbrains
    pkgs-unstable.jetbrains.idea-ultimate

    # Java debugger
    pkgs.async-profiler
    pkgs.bytecode-viewer

    # Arduino
    pkgs.arduino

    # text-editors
    pkgs.vim
    pkgs.zed-editor
  ];

  xdg.desktopEntries = {
    "idea-custom" = {
      name = "IntelliJ IDEA (Wayland)";
      genericName = "Code Editor";
      comment = "IntelliJ IDEA with wayland toolkit";
      exec = "idea-ultimate -Dawt.toolkit.name=WLToolkit";
      icon = "idea-ultimate";
    };
  };
}
