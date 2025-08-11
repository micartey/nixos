{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kiwix
    kiwix-tools
    libkiwix
  ];
}
