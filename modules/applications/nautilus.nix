{ pkgs, ... }:

# @profile default
{
  environment.systemPackages = with pkgs; [ nautilus ];
}
