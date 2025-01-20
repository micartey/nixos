{ pkgs, ... }:

let
  etcher = pkgs.appimageTools.wrapType2 rec {
    name = "Etcher";
    pname = "etcher";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "https://github.com/balena-io/etcher/releases/download/v1.7.9/balenaEtcher-1.7.9-ia32.AppImage";
      sha256 = "sha256-4SymyWnKDPnBPb3FtzdHJjgRoMMjxsM6WBeSQPJbmMM=";
    };
  };
in

{
  environment.systemPackages = with pkgs; [
    etcher
  ];
}
