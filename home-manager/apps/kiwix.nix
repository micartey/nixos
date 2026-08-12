{ pkgs, ... }:

# @profile lenovo
{
  home.packages = with pkgs; [
    kiwix
    kiwix-tools
    libkiwix
  ];
}
