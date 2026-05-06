{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.onlyoffice-desktopeditors ];

  fonts.packages = with pkgs; [
    corefonts
  ];
}
