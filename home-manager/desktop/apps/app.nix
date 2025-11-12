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

    pkgs.element-desktop

    pkgs.spotify
    pkgs.spotify-cli-linux

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

    pkgs.gnome-disk-utility

    pkgs.kicad
    (pkgs.callPackage ../../../pkgs/easyeda.nix { })
  ];
}
