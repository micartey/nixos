{ pkgs, ... }:

{
  profiles = [ "lenovo" ];

  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

  environment.sessionVariables = {
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    nvtopPackages.full
  ];
}
