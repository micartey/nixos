{ pkgs, ... }:

# @profile default
{
  environment.systemPackages = [
    pkgs.tcpdump
    pkgs.traceroute
  ];
}
