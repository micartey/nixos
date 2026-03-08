{
  config,
  lib,
  meta,
  ...
}:

let
  secrets = import ../../lib/secrets.nix { inherit config lib; };
in

{
  services.tailscale = {
    enable = true;
    extraUpFlags = [
      "--ssh"
    ];
    authKeyFile = secrets.path "tailscale/auth_key";
  };

  sops = secrets.mkValue "tailscale/auth_key" {
    owner = meta.user.username;
  };
}
