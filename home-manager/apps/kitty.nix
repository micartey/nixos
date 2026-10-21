{ ... }:

{
  profiles = [ "default" ];

  programs.kitty = {
    enable = true;
    font.name = "SpaceMono";
    font.size = 12;
    extraConfig = ''
      window_padding_width 8
      confirm_os_window_close 0
      remember_window_size no

      copy_on_select yes
      map shift+insert paste_from_clipboard
    '';
  };
}
