{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.tcpdump
    pkgs.traceroute
  ];
}
