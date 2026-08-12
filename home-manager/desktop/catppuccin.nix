{ inputs, ... }:

# @profile default
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };
}
