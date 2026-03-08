{
  config,
  lib,
  meta,
  ...
}:

let
  secrets = import ../lib/secrets.nix { inherit config lib; };
  user = meta.user.username;
in

{
  sops = lib.mkMerge [
    (secrets.mkValue "ssh" {
      owner = user;
      path = "/home/${user}/.ssh/id_ed25519";
    })
    (secrets.mkValue "matrikel-nummer" {
      owner = user;
      path = "/home/${user}/.fernuni-hagen/matrikelnummer.txt";
    })
  ];
}
