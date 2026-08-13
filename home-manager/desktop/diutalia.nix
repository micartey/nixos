{
  inputs,
  lib,
  ...
}:

{
  profiles = [ "default" ];
  imports = [ inputs.diutalia.homeModules.default ];

  programs.diutalia-shell = {
    systemd.enable = true;
    enable = true;

    settings = builtins.fromJSON (builtins.readFile ../../dots/noctalia/settings.json);
  };

  systemd.user.services.diutalia-shell.warnings = lib.mkForce { };

  # xdg.configFile."noctalia/colors.json".force = true;
}
