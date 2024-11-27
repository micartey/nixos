{ config, ... }:

{
  xdg = {
    enable = true;

    cacheHome = config.home.homeDirectory + "/.local/cache";
    configHome = config.home.homeDirectory + "/.config";

    userDirs = {
      enable = true;
      createDirectories = true;
    };

    portal = {
      enable = true;

      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
      };
    };

    mimeApps =
      let
        brave = [ "brave.desktop" ];
        firefox = [ "firefox.desktop" ];

        vscode = [ "vscode.desktop" ];
      in
      {
        enable = true;

        defaultApplications = {
          "application/x-extension-htm" = brave;
          "application/x-extension-html" = brave;
          "application/x-extension-shtml" = brave;
          "application/x-extension-xht" = brave;
          "application/x-extension-xhtml" = brave;
          "application/xhtml+xml" = brave;
          "application/json" = brave;
          "text/html" = brave;
          "x-scheme-handler/about" = brave;
          "x-scheme-handler/chrome" = brave;
          "x-scheme-handler/ftp" = brave;
          "x-scheme-handler/http" = brave;
          "x-scheme-handler/https" = brave;
          "x-scheme-handler/unknown" = brave;
          "image/svg+xml" = brave;

          "application/pdf" = firefox;

          "text/markdown" = vscode;
        };
      };
  };
}
