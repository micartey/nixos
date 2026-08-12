{
  pkgs,
  pkgs-unstable,
  ...
}:

# @profile home
{
  home.packages = [
    pkgs-unstable.liquidctl
    pkgs.usbutils
  ];
}
