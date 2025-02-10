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
          "networkmanager"
          "wheel"
          "docker"
          meta.user.username
          "wireshark"
        ];
        openssh.authorizedKeys.keys = [ (builtins.readFile ../../../dots/ssh/id_ed25519.pub) ];
      };
    };
  };
}
