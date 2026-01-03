{
  config,
  meta,
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [ wakatime-cli ];

  sops = {
    secrets = {
      "wakatime/api_key" = {
        owner = meta.user.username;
      };
    };
    templates."wakatime/cfg" = {
      path = "/home/${meta.user.username}/.wakatime.cfg";
      owner = meta.user.username;
      content =
        let
          inherit (config.sops) placeholder;
        in
        # toml
        ''
          [settings]
          api_url = https://waka.micartey.dev/api
          api_key = ${placeholder."wakatime/api_key"}
        '';
    };
  };
}
