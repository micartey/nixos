{ pkgs, pkgs-unstable, ... }:

{
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-cli;
  };
}
