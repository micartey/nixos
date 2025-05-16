{
  pkgs,
  lib,
  config,
  ...
}:

{
  # services.xserver.videoDrivers = lib.mkForce [
  #   "nvidia"
  # ];

  # hardware.amdgpu.initrd.enable = true;

  # hardware.nvidia = {
  #   modesetting.enable = true;

  #   powerManagement = {
  #     enable = false;
  #     # finegrained = false;
  #   };

  #   open = false;
  #   nvidiaSettings = true;

  #   prime = {
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };

  #     amdgpuBusId = "PCI:4:0:0";
  #     nvidiaBusId = "PCI:1:0:0";
  #   };

  #   package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #     version = "570.133.07";
  #     sha256_64bit = "sha256-LUPmTFgb5e9VTemIixqpADfvbUX1QoTT2dztwI3E3CY=";
  #     openSha256 = lib.fakeSha256;
  #     settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
  #     sha256_aarch64 = lib.fakeSha256;
  #     persistencedSha256 = lib.fakeSha256;
  #   };
  # };

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [ nvidia-vaapi-driver ];

  environment.sessionVariables = {
    "GBM_BACKEND" = "nvidia-drm";
    "MOZ_DISABLE_RDD_SANDBOX" = "1";
    "LIBVA_DRIVER_NAME" = "nvidia";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    # vulkan-headers
    # dxvk

    nvtopPackages.full
  ];
}
