{ meta, ... }:

{
  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = [ meta.user.username ];
      runAs = "root";
      commands = [
        {
          command = "/run/current-system/sw/bin/tc";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
