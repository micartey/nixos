{ pkgs, ... }:

{
  # quick access
  catppuccin.rofi.enable = false;
  programs.rofi = {
    enable = true;
    theme = "custom";
  };

  home.file = {
    theme = {
      source = ../../dots/rofi/config.rasi;
      target = ".config/rofi/custom.rasi";
    };
  };
}
