{
  inputs,
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

  home-manager.users = {
    ${meta.user.username} = import ../../home-manager/desktop {
      inherit
        inputs
        pkgs
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
