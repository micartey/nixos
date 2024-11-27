{ pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_rsa.pub) ];
      };

      daniel = {
        isNormalUser = true;
        description = "Daniel";
        initialPassword = "daniel";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "daniel"
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_rsa.pub) ];
      };
    };
  };
}
