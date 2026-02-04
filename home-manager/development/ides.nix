{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    # jetbrains
    pkgs-unstable.jetbrains.idea

    # Java debugger
    pkgs.async-profiler
    pkgs.bytecode-viewer

    # text-editors
    pkgs.zed-editor

    inputs.nix-vim.packages.${pkgs.system}.vim
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
