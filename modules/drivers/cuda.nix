{
  pkgs,
  ...
}:

{
  # TODO: Remove this
  # nixpkgs.config.cudaSupport = true;
  # nixpkgs.config.rocmSupport = false;

  environment.systemPackages = with pkgs; [
    cudatoolkit
  ];

  # environment.variables = {
  #   CUDA_PATH = "${pkgs.cudatoolkit}";
  #   EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
  #   EXTRA_CCFLAGS="-I/usr/include";
  # };
}
