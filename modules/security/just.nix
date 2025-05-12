{ meta, ... }:

{
  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      users = [ meta.user.username ];
      runAs = "root";
      commands = [
        {
          command = "/home/daniel/.nix-profile/bin/just";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
