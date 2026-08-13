{ currentProfile, lib, ... }:

{
  options.profiles = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [ "default" "home" "lenovo" ]);
    default = [ ];
    internal = true;
    description = "Profiles selecting this module.";
  };

  imports = import ../lib/profile-loader.nix {
    inherit lib;
    profile = currentProfile;
    root = ./.;
  };
}
