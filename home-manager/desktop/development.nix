{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style

    erlang
    elixir
    gleam

    zulu21
    gradle_7

    gdb

    d2
  ];
}
