{ currentProfile, lib, ... }:

{
  imports = import ../lib/profile-loader.nix {
    inherit lib;
    profile = currentProfile;
    root = ./.;
  };
}
