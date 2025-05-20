{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style

    erlang
    elixir
    gleam

    go_1_24
    libcap
    gcc
    gox

    zulu21
    gradle_7

    gdb

    d2
  ];
}
