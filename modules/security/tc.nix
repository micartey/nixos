{ ... }:

{
  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = [ "daniel" ];
      runAs = "root";
      commands = [
        {
          command = "/etc/profiles/per-user/daniel/bin/just";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
