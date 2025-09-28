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

    pkgs-unstable.element-desktop

    pkgs.spotify

    # Hardware design
    pkgs.openscad-unstable
    # pkgs.kicad
    (pkgs.callPackage ../../pkgs/easyeda.nix { })

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
    (pkgs.callPackage ../../pkgs/transformerlab.nix { })
  ];
}
