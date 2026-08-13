{ pkgs, ... }:

{
  profiles = [ "default" ];
  environment.systemPackages = with pkgs; [ nautilus ];
}
