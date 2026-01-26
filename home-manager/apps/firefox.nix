{ pkgs, ... }:

let
  firefox-wrapper = pkgs.writeShellScriptBin "firefox-firejail" ''
    exec firejail --ignore=private-bin \
      --env=XDG_DATA_DIRS="$XDG_DATA_DIRS" \
      --env=GTK_THEME=Adwaita:dark \
      --env=XCURSOR_PATH="$XCURSOR_PATH" \
      --env=NIXOS_OZONE_WL=1 \
      --noblacklist=/nix/store \
      --read-only=/nix/store \
      "$(readlink -f $(which firefox))" \
      --no-remote "$@"
  '';
in
{
  home.packages = [ firefox-wrapper ];

  # Override Firefox desktop entry to use firejail
  xdg.desktopEntries.firefox = {
    name = "Firefox";
    genericName = "Web Browser";
    exec = "firefox-firejail %U";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "application/rss+xml"
      "application/rdf+xml"
      "image/svg+xml"
      "image/png"
      "image/ico"
      "image/gif"
      "text/plain"
    ];
    icon = "firefox";
  };

  programs.firefox = {
    enable = true;

    policies = {

      # go to: about:support and search for the ID of the extension
      ExtensionSettings = {
        # "*".installation_mode = "blocked";

        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # AdGuard AdBlocker
        "adguardadblocker@adguard.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/adguard-adblocker/latest.xpi";
          installation_mode = "force_installed";
        };

        # LanguageTool
        "languagetool-webextension@languagetool.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
          installation_mode = "force_installed";
        };

        # Return YouTube Dislike
        "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/return-youtube-dislike/latest.xpi";
          installation_mode = "force_installed";
        };

        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };

        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.default = {
      isDefault = true;

      extensions.force = true;

      userChrome = builtins.readFile ../../dots/firefox/userChrome.css;
      userContent = builtins.readFile ../../dots/firefox/userContent.css;

      # about:config
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;

        # Spoof Windows Firefox (NOT Chrome) to match TLS handshake
        "general.useragent.override" =
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:133.0) Gecko/20100101 Firefox/133.0";

        # Override Javascript platform detection to match User Agent
        "general.platform.override" = "Win32";
        "general.oscpu.override" = "Windows NT 10.0; Win64; x64";

        # Disable some password stuff of firefox
        "browser.contextual-password-manager.enabled" = false;
        "services.sync.engine.passwords" = false;
        "privacy.cpd.passwords" = false;
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
      };
    };
  };
}
