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

  profilesFor =
    file:
    let
      path = root + "/${file}";
      lines = lib.splitString "\n" (builtins.readFile path);
      markerLines = lib.filter (lib.hasPrefix "# @profile ") lines;
      markerMatches = map (builtins.match "# @profile (default|home|lenovo)") markerLines;
    in
    if markerLines == [ ] then
      throw "${toString path}: expected at least one '# @profile default', '# @profile home', or '# @profile lenovo' marker"
    else if lib.any (match: match == null) markerMatches then
      throw "${toString path}: invalid profile marker"
    else
      map builtins.head markerMatches;

  selected = lib.filter (
    file:
    let
      fileProfiles = profilesFor file;
    in
    builtins.elem "default" fileProfiles || builtins.elem profile fileProfiles
  ) nixFiles;
in
assert lib.assertMsg (builtins.elem profile validProfiles) "Unknown profile '${profile}'";
map (file: root + "/${file}") selected
