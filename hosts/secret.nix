{
  sops.secrets = {
    "ssh" = {
      owner = "daniel";
      path = "/home/daniel/.ssh/id_ed25519";
    };
    # "k8s/token" = { };
  };
}