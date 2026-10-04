{ pkgs, ... }:

{
  profiles = [ "home" ];

  services.ollama = {
    package = pkgs.callPackage ../../pkgs/ollama.nix { };
    enable = true;
  };
}
