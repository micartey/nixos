{ ... }:

{
  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "daniel" ];
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
