{ meta, ... }:

{
  sops.secrets = {
    "ssh" = {
      owner = meta.user.username;
      path = "/home/${meta.user.username}/.ssh/id_ed25519";
    };

    "matrikel-nummer" = {
      owner = meta.user.username;
      path = "/home/${meta.user.username}/.fernuni-hagen/matrikelnummer.txt";
    };
  };
}
