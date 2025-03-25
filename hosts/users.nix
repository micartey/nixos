{ pkgs, meta, ... }:

{
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_ed25519.pub) ];
      };

      ${meta.user.username} = {
        isNormalUser = true;
        description = meta.user.description;
        initialPassword = meta.user.username;
        extraGroups = [
          meta.user.username
          "networkmanager"
          "wheel"
          "docker"
          "wireshark"
          "ydotool" # For typ
          "dialout" # For COM-Ports (Arduino)
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_ed25519.pub) ];
      };
    };
  };
}
