{ pkgs-unstable, ... }:

# @profile default
{
  programs.wireshark = {
    enable = true;
    package = pkgs-unstable.wireshark;
  };
}
