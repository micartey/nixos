{
  meta,
  config,
  pkgs-unstable,
  ...
}:

let
  user = meta.user.username;
  homeDir = config.home-manager.users.${user}.home.homeDirectory;
in
{
  environment.systemPackages = [ pkgs-unstable.dnscontrol ];

  sops.secrets = {
    "cloudflare/email" = { };
    "cloudflare/account_id" = { };
    "cloudflare/global_api_key" = { };
  };

  sops.templates."dnscontrol/creds.json" = {
    path = "${homeDir}/nixos/dots/dns/creds.json";
    owner = "${user}";
    content = ''
      {
        "cloudflare": {
          "TYPE": "CLOUDFLAREAPI",
          "accountid": "${config.sops.placeholder."cloudflare/account_id"}",
          "apikey": "${config.sops.placeholder."cloudflare/global_api_key"}",
          "apiuser": "${config.sops.placeholder."cloudflare/email"}"
        }
      }
    '';
  };
}
