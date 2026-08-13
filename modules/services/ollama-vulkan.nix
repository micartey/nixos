{ pkgs, ... }:

{
  profiles = [ "lenovo" ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };
}
