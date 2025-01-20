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
        firefox = [ "firefox.desktop" ];

        vscode = [ "vscode.desktop" ];
      in
      {
        enable = true;

        defaultApplications = {
          "application/x-extension-htm" = firefox;
          "application/x-extension-html" = firefox;
          "application/x-extension-shtml" = firefox;
          "application/x-extension-xht" = firefox;
          "application/x-extension-xhtml" = firefox;
          "application/xhtml+xml" = firefox;
          "application/json" = firefox;
          "application/pdf" = firefox;
          "text/html" = firefox;
          "x-scheme-handler/about" = firefox;
          "x-scheme-handler/chrome" = firefox;
          "x-scheme-handler/ftp" = firefox;
          "x-scheme-handler/http" = firefox;
          "x-scheme-handler/https" = firefox;
          "x-scheme-handler/unknown" = firefox;
          "image/svg+xml" = firefox;

          "text/markdown" = vscode;
        };
      };
  };
}
