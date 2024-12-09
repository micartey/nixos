{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "SpaceMono";
    font.size = 12;
    extraConfig = ''
      window_padding_width 8
      confirm_os_window_close 0
    '';
  };
}
