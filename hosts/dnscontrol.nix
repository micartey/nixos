{
  config,
  lib,
  meta,
  pkgs-unstable,
  ...
}:

let
  secrets = import ../lib/secrets.nix { inherit config lib; };
  user = meta.user.username;
  homeDir = config.home-manager.users.${user}.home.homeDirectory;
in
{
  environment.systemPackages = [ pkgs-unstable.dnscontrol ];

  sops = secrets.mkTemplate "dnscontrol/creds.json" {
    owner = user;
    path = "${homeDir}/nixos/dots/dns/creds.json";
    secrets = [
      "cloudflare/email"
      "cloudflare/account_id"
      "cloudflare/global_api_key"
    ];
    content = placeholder: ''
      {
        "cloudflare": {
          "TYPE": "CLOUDFLAREAPI",
          "accountid": "${placeholder."cloudflare/account_id"}",
          "apikey": "${placeholder."cloudflare/global_api_key"}",
          "apiuser": "${placeholder."cloudflare/email"}"
        }
      }
    '';
  };
}
