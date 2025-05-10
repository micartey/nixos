{
  pkgs,
  lib,
  config,
  ...
}:

{
  # services.xserver.videoDrivers = [ "nvidia" ];

  # hardware.nvidia = {
  #   modesetting.enable = true;

  #   powerManagement = {
  #     enable = false;
  #     finegrained = false;
  #   };

  #   open = false;
  #   nvidiaSettings = true;

  #   package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #     version = "570.133.07";
  #     sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
  #     openSha256 = lib.fakeSha256;
  #     settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
  #     sha256_aarch64 = lib.fakeSha256;
  #     persistencedSha256 = lib.fakeSha256;
  #   };
  # };

  environment.sessionVariables = {
    # "LIBVA_DRIVER_NAME" = "nvidia";
    # "GBM_BACKEND" = "nvidia-drm";
    # "WLR_NO_HARDWARE_CURSORS" = "1";
    # "__GL_GSYNC_ALLOWED" = "1";
    # "__GL_VRR_ALLOWED" = "1";
    # "__NV_PRIME_RENDER_OFFLOAD" = "1";
    # "__NV_PRIME_RENDER_OFFLOAD_PROVIDER" = "NVIDIA-G0";
    # "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    # "__VK_LAYER_NV_optimus" = "NVIDIA_only";
  };

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    vulkan-headers
    dxvk

    nvtopPackages.full
  ];
}
