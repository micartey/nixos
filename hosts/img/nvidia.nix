{
  config,
  lib,
  meta,
  pkgs,
  ...
}:
let
  looking-glass-host = pkgs.looking-glass-client.overrideAttrs (old: {
    pname = "looking-glass-host";
    sourceRoot = "source";
    patches = [ ];
    postUnpack = (old.postUnpack or "") + ''
      export sourceRoot=source
    '';
    postPatch = ''
      substituteInPlace host/CMakeLists.txt --replace '"-Werror"' '""'
    '';
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.glib.dev ];
    configurePhase = ''
      runHook preConfigure
      cmake -S host -B build \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$out \
        -DOPTIMIZE_FOR_NATIVE=OFF \
        -DUSE_XCB=OFF \
        -DUSE_PIPEWIRE=ON
      runHook postConfigure
    '';
    buildPhase = ''
      runHook preBuild
      cmake --build build --parallel $NIX_BUILD_CORES
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      cmake --install build
      runHook postInstall
    '';
  });
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = lib.mkForce {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    # GTX 1060 (Pascal) needs a GBM-capable driver for Hyprland.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  hardware.graphics.enable = true;

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
  boot.kernelModules = [ "kvmfr" ];
  boot.extraModprobeConfig = "options kvmfr static_size_mb=32";

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="${meta.user.username}", MODE="0660"
  '';

  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    looking-glass-host
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    AQ_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";

    # AQ_DRM_DEVICES uses ':' as separator, so PCI by-path names cannot be used.
    # simpledrm is card0; NVIDIA and virtio-vga load as card1 and card2.
    AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card2";
  };
}
