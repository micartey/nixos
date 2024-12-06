{
  pkgs,
  pkgs-unstable,
  inputs,
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

    profiles.default = {
      isDefault = true;
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

    pkgs.mullvad-vpn
    pkgs.spotify
    pkgs.openscad-unstable
    pkgs.orca-slicer

    pkgs.obs-studio

    # tex-related
    pkgs.texliveFull
    pkgs.graphviz
    pkgs.inkscape
  ];
}
