{ pkgs, ... }:

# @profile lenovo
{
  environment.systemPackages = [ pkgs.onlyoffice-desktopeditors ];
  fonts.packages = [ pkgs.corefonts ];
}
