{
  config,
  lib,
  meta,
  pkgs,
  ...
}:

let
  secrets = import ../../lib/secrets.nix { inherit config lib; };
  user = meta.user.username;
in

{
  environment.systemPackages = with pkgs; [ wakatime-cli ];

  sops = secrets.mkTemplate "wakatime/cfg" {
    owner = user;
    path = "/home/${user}/.wakatime.cfg";
    secrets = [ "wakatime/api_key" ];
    content = placeholder: ''
      [settings]
      api_url = https://waka.micartey.dev/api
      api_key = ${placeholder."wakatime/api_key"}
    '';
  };
}
