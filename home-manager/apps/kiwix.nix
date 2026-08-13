{ pkgs, ... }:

{
  profiles = [ "lenovo" ];
  home.packages = with pkgs; [
    kiwix
    kiwix-tools
    libkiwix
  ];
}
