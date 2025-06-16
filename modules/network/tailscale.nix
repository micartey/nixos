{ ... }:

{

  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];
    authKeyFile = "/var/.tailscale/auth";
  };

  sops.secrets = {
    "tailscale/auth_key" = {
      path = "/var/.tailscale/auth";
    };
  };
}
