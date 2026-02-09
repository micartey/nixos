{ pkgs, ... }:

{
  programs.java = {
    enable = true;
    package = (pkgs.jdk17.override { enableJavaFX = true; });
  };

  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style

    erlang
    elixir
    gleam

    go_1_24
    tinygo
    libcap
    gcc
    gox

    gradle_7

    lefthook

    glab
    gdb

    d2
  ];
}
