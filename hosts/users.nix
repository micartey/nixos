{ pkgs, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_ed25519.pub) ];
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
          "wireshark"
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_ed25519.pub) ];
      };
    };
  };
}
