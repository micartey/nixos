{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  home.packages = [
    pkgs-unstable.liquidctl
    pkgs.usbutils
  ];
}
