{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # tex-related
  home.packages = [
    pkgs.texliveFull
    pkgs.graphviz
    pkgs.inkscape
  ];
}
