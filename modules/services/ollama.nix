{ pkgs, ... }:

{
  services.ollama = {
    enable = true;

    package = pkgs.ollama-vulkan;
    acceleration = "vulcan";
  };
}
