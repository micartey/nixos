{ config, lib }:

let
  inherit (config.sops) placeholder;
in

{
  path = name: config.sops.secrets.${name}.path;

  mkValue =
    name:
    {
      owner,
      path ? null,
    }:
    {
      secrets.${name} = {
        inherit owner;
      }
      // lib.optionalAttrs (path != null) { inherit path; };
    };

  mkTemplate =
    name:
    {
      owner,
      path,
      secrets,
      content,
    }:
    {
      secrets = lib.genAttrs secrets (_: {
        inherit owner;
      });
      templates.${name} = {
        inherit path owner;
        content = content placeholder;
      };
    };
}
