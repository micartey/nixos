{ inputs, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) system;
  viro = inputs.viro.packages.${system}.default;
in
{
  profiles = [ "default" ];

  environment.systemPackages = [ viro ];
}
