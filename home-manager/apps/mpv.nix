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
            mkdir -p "$out"
            unzip -j "$shadersZip" -d "$out"
            cp ${../../dots/mpv/Acerola_ASCII.glsl} "$out/Acerola_ASCII.glsl"
            cp ${../../dots/mpv/Acerola_ASCII_Advanced.glsl} "$out/Acerola_ASCII_Advanced.glsl"
            cp ${../../dots/mpv/Acerola_ASCII_Black_White.glsl} "$out/Acerola_ASCII_Black_White.glsl"
            cp ${../../dots/mpv/Acerola_ASCII_Custom.glsl} "$out/Acerola_ASCII_Custom.glsl"
            cp ${../../dots/mpv/Acerola_Kuwahara.glsl} "$out/Acerola_Kuwahara.glsl"
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
