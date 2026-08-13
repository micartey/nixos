{ inputs, pkgs, ... }:

{
  profiles = [ "default" ];
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;

    viAlias = true;
    vimAlias = true;

    withRuby = false;
    withPython3 = false;
  };
}
