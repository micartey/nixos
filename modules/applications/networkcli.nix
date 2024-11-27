{ pkgs, pkgs-unstable, ... }:

{
  environment.systemPackages = [ 
    pkgs.tcpdump
    pkgs.traceroute
  ];
}
