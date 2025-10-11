{ lib, ... }:

{
  networking.firewall.enable = lib.mkDefault true;

  networking.firewall.allowedUDPPorts = [ 1234 ];
}
