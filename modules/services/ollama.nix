{ pkgs, ... }:

{
  services.ollama = {
    enable = true;

    package = pkgs.ollama-vulkan;
    acceleration = "vulkan";

    environmentVariables = {
      OLLAMA_DEBUG = "1";
      CUDA_VISIBLE_DEVICES = "1";
      __NV_PRIME_RENDER_OFFLOAD = "1";
      __NV_PRIME_RENDER_OFFLOAD_SET_GUIDE = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };
}
