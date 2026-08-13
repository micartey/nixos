{ pkgs, ... }:

{
  profiles = [ "lenovo" ];
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    nvtopPackages.full
  ];
}
