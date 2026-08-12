{ pkgs, ... }:

# @profile lenovo
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };
}
