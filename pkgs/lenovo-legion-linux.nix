{
  lib,
  fetchFromGitHub,
  kernel,
  stdenv,
}:

let
  src = fetchFromGitHub {
    owner = "johnfanv2";
    repo = "LenovoLegionLinux";
    rev = "7c19579d13ce686cf1e237699b9a78e80d03c977";
    hash = "sha256-gTlUrbNKCUQ+g70StlqspDn90wKW2scssKPZqaegzTY=";
  };
in
stdenv.mkDerivation {
  pname = "lenovo-legion-linux";
  version = "2026-05-12";

  inherit src;

  sourceRoot = "${src.name}/kernel_module";
  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = [
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNELVERSION=${kernel.modDirVersion}"
  ];

  installPhase = ''
    install -D legion-laptop.ko \
      "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86/legion-laptop.ko"
  '';

  meta = {
    description = "Lenovo laptop fan curve and power mode kernel module";
    homepage = "https://github.com/johnfanv2/LenovoLegionLinux";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
