{ pkgs, ... }:

{
  profiles = [ "default" ];

  environment.systemPackages = [
    pkgs.tcpdump
    pkgs.traceroute
  ];
}
