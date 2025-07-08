{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.space-mono
      helvetica-neue-lt-std
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Jetbrains Mono" ];
        sansSerif = [ "Jetbrains Mono" ];
        serif = [  "Jetbrains Mono" ];
      };
    };
  };
}
