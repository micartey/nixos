{
  inputs,
  lib,
  pkgs,
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
        pkgs-unstable
        stateVersion
        meta
        ;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  home-manager.users = lib.genAttrs [ meta.user.username "root" ] (
    _:
    import ../../home-manager {
      inherit
        inputs
        lib
        pkgs
        pkgs-unstable
        stateVersion
        meta
        ;
    }
  );

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
