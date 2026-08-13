{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  profiles = [ "home" ];
  home.packages = [
    pkgs-unstable.liquidctl
    pkgs.usbutils
  ];
}
