{ pkgs, ... }:

{
  services.ollama = {
    package = pkgs.callPackage ../../pkgs/ollama.nix { };

    enable = true;
    acceleration = "cuda";
  };
}
