{ pkgs, ... }:

{
  profiles = [ "lenovo" ];

  environment.systemPackages = [ pkgs.onlyoffice-desktopeditors ];
  fonts.packages = [ pkgs.corefonts ];
}
