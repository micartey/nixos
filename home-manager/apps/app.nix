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

  xdg.desktopEntries = {
    "steam" = {
      name = "Steam (Mullvad)";
      genericName = "Game Library";
      comment = "Steam with mullvad exclude";
      exec = "mullvad-exclude steam %U";
      icon = "steam";
    };

    "vesktop" = {
      name = "Vesktop (Mullvad)";
      genericName = "Discord";
      comment = "Vesktop with mullvad exclude";
      exec = "mullvad-exclude vesktop %U";
      icon = "vesktop";
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

    pkgs.element-desktop

    pkgs.spotify
    pkgs.spotify-cli-linux

    # Hardware design
    pkgs.openscad-unstable

    pkgs.kicad
    (pkgs.callPackage ../../pkgs/easyeda.nix { })

    # password
    pkgs.bitwarden-desktop

    pkgs.openconnect

    # Rest Client
    pkgs.insomnia

    # Needs to be called with --disable-gpu
    pkgs-unstable.lmstudio

    (pkgs.callPackage ../../pkgs/pince.nix { })
    (pkgs.callPackage ../../pkgs/transformerlab.nix { })
  ];
}
