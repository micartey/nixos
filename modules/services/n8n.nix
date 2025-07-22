{ ... }:

{
  services.n8n = {
    enable = true;
  };

  systemd.services.n8n.serviceConfig.User = "daniel";
}
