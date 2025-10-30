{
  inputs,
  lib,
  pkgs,
  pkgs-edge,
  pkgs-unstable,
  stateVersion,
  meta,
  ...
}:

{
  imports = [
    ../default.nix

    ../../modules
  ];

  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        pkgs-edge
        pkgs-unstable
        stateVersion
        meta
        ;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users = {
    ${meta.user.username} = import ../../home-manager {
      inherit
        inputs
        lib
        pkgs
        pkgs-edge
        pkgs-unstable
        stateVersion
        meta
        ;
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
