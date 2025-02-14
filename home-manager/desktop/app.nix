{
  pkgs,
  pkgs-unstable,
  ...
}:

{
  # gpg key manager
  programs.gpg.enable = true;

  # audio effects
  services.easyeffects.enable = true;

  # brave browser
  programs.chromium = {
    enable = true;
    package = pkgs-unstable.brave;
    extensions = [
      "gppongmhjkpfnbhagpmjfkannfbllamg" # Wappalyzer
      "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture
      "egnjhciaieeiiohknchakcodbpgjnchh" # Tab Wrangler
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
      "oldceeleldhonbafppcapldpdifcinji" # LanguageTool
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
    # commandLineArgs = [
    #   "--enable-features=UseOzonePlatform"
    #   "--ozone-platform=x11"
    # ];
  };

  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox;

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

        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
      };

    };

    profiles.default = {
      isDefault = true;

      userChrome = builtins.readFile ../../dots/firefox/userChrome.css;
      userContent = builtins.readFile ../../dots/firefox/userContent.css;

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
    };
  };

  home.packages = [
    # WhatApp
    # pkgs.zapzap

    # discord
    pkgs-unstable.vesktop
    pkgs-unstable.discord
    pkgs-unstable.legcord
    pkgs-unstable.discordo

    pkgs.spotify
    pkgs.openscad-unstable

    pkgs.obs-studio

    # tex-related
    pkgs.texliveFull
    pkgs.graphviz
    pkgs.inkscape

    # Rest Client
    pkgs.insomnia

    # 3D modeling
    pkgs.plasticity
  ];
}
