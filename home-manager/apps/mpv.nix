{ pkgs, ... }:

{
  catppuccin.mpv.enable = false; # This needs to be disabled for mpvconf to be written
  programs.mpv.enable = true;

  home.file = {
    shaders = {
      source =
        pkgs.runCommand "mpv-shaders"
          {
            buildInputs = [ pkgs.unzip ];
            shadersZip = ../../dots/mpv/shaders.zip;
          }
          ''
            unzip -j "$shadersZip" -d "$out"
          '';
      target = ".config/mpv/shaders";
    };

    inputconf = {
      source = ../../dots/mpv/input.conf;
      target = ".config/mpv/input.conf";
    };

    mpvconf = {
      source = ../../dots/mpv/mpv.conf;
      target = ".config/mpv/mpv.conf";
    };
  };
}
