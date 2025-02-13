{ pkgs-unstable, ... }:

{
  services.open-webui = {
    enable = true;
    port = 6969;

    package = pkgs-unstable.open-webui;

    environment = {
      WEBUI_AUTH = "False";
    };
  };
}
