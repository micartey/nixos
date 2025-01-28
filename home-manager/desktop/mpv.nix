{ ... }:

{
  catppuccin.mpv.enable = false; # This needs to be disabled for mpvconf to be written
  programs.mpv.enable = true;

  home.file = {
    shaders = { source = ../../dots/mpv/shaders; target = ".config/mpv/shaders"; };
    inputconf = { source = ../../dots/mpv/input.conf; target = ".config/mpv/input.conf"; };
    mpvconf = { source = ../../dots/mpv/mpv.conf; target = ".config/mpv/mpv.conf"; };
  };
}
