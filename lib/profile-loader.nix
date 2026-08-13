{
  lib,
  profile,
  root,
}:

let
  validProfiles = [
    "default"
    "home"
    "lenovo"
  ];

  moduleFormat = lib.evalModules {
    modules = [
      {
        options = {
          profiles = lib.mkOption {
            type = lib.types.listOf (lib.types.enum validProfiles);
            description = "Profiles loading this module.";
          };

        };
      }
    ];
  };

  getDir =
    dir:
    lib.mapAttrs (file: type: if type == "directory" then getDir "${dir}/${file}" else type) (
      builtins.readDir dir
    );

  files =
    dir:
    lib.collect lib.isString (
      lib.mapAttrsRecursive (path: _: lib.concatStringsSep "/" path) (getDir dir)
    );

  nixFiles = lib.filter (file: lib.hasSuffix ".nix" file && file != "default.nix") (files root);

  readProfiles =
    file:
    let
      module = import (root + "/${file}");
      moduleConfig =
        if builtins.isFunction module then
          # Profiles must be static metadata. Null values let us read them without
          # evaluating NixOS or Home Manager configuration below this field.
          module (lib.mapAttrs (name: _: null) (builtins.functionArgs module))
        else
          module;
      profiles =
        if moduleConfig ? profiles then
          moduleConfig.profiles
        else if moduleConfig ? config && moduleConfig.config ? profiles then
          moduleConfig.config.profiles
        else
          throw "${toString (root + "/${file}")}: expected a 'profiles' field";
    in
    (moduleFormat.extendModules {
      modules = [ { inherit profiles; } ];
    }).config.profiles;

  selected = lib.filter (
    file:
    let
      fileProfiles = readProfiles file;
    in
    builtins.elem "default" fileProfiles || builtins.elem profile fileProfiles
  ) nixFiles;
in
assert lib.assertMsg (builtins.elem profile validProfiles) "Unknown profile '${profile}'";
map (file: root + "/${file}") selected
