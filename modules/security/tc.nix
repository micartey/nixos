{ meta, ... }:

{
  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = [ meta.user.username ];
      runAs = "root";
      commands = [
        {
          command = "/etc/profiles/per-user/${meta.user.username}/bin/just";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
