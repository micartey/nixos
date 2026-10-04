{ inputs, ... }:

{
  profiles = [ "default" ];

  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  catppuccin = {
    enable = true;

    flavor = "mocha";
  };
}
