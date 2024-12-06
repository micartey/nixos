{ inputs, pkgs, pkgs-unstable, ... }:

{
  imports = [ 
    ../default.nix
    
    ../../modules
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit inputs pkgs-unstable;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users = {
    daniel = import ../../home/desktop {
      inherit inputs pkgs pkgs-unstable;
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
