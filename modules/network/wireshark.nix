{ pkgs-unstable, ... }:

{
  profiles = [ "default" ];

  programs.wireshark = {
    enable = true;
    package = pkgs-unstable.wireshark;
  };
}
