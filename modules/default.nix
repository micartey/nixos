{ lib, ... }:

with lib;
let
  # Recursively constructs an attrset of a given folder, recursing on directories, value of attrs is the filetype
  getDir =
    dir:
    mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else type) (
      builtins.readDir dir
    );

  # Collects all files of a directory as a list of strings of paths
  files = dir: collect isString (mapAttrsRecursive (path: _: concatStringsSep "/" path) (getDir dir));

  # Filters out directories that don't end with .nix or are this file, also makes the strings absolute
  validFiles =
    dir:
    map (file: ./. + "/${file}") (
      filter (file: hasSuffix ".nix" file && file != "default.nix") (files dir)
    );

in
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
