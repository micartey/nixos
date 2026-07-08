{ pkgs, inputs, ... }:

{
  home.packages = [
    inputs.handy.packages.${pkgs.system}.default
  ];
}
