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
    pkgs-unstable.bambu-studio
    pkgs.kicad

    # password
    pkgs.bitwarden-desktop

    pkgs.openconnect

    # tex-related
    pkgs.texliveFull
    pkgs.graphviz
    pkgs.inkscape

    # Rest Client
    pkgs.insomnia

    # Needs to be called with --disable-gpu
    pkgs-unstable.lmstudio

    (pkgs.callPackage ../../pkgs/pince.nix { })
    (pkgs.callPackage ../../pkgs/easyeda.nix { })
    (pkgs.callPackage ../../pkgs/transformerlab.nix { })
  ];
}
