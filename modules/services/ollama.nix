{ ... }:

{
  services.ollama = {
    enable = true;

    # package = pkgs-unstable.ollama;
    acceleration = "cuda";
  };
}
