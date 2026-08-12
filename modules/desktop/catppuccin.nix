{ inputs, ... }:

# @profile default
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;

    flavor = "mocha";
  };
}
