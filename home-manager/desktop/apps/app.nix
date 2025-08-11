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
    pkgs-unstable.discordo

    pkgs.spotify

    pkgs.openscad-unstable
    pkgs.bambu-studio
    #pkgs.kicad

    # password
    pkgs.bitwarden-desktop

    pkgs.openconnect

    # tex-related
    pkgs.texliveFull
    pkgs.graphviz
    pkgs.inkscape

    # Rest Client
    pkgs.insomnia

    (pkgs.callPackage ../../../pkgs/easyeda.nix { })
  ];
}
