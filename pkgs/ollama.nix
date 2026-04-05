{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildEnv,
  makeBinaryWrapper,
  addDriverRunpath,
  cmake,
  gitMinimal,
  cudaPackages,
  cudaArches ? cudaPackages.flags.realArches or [ ],
  autoAddDriverRunpath,
}:

let
  cudaLibs = [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.cuda_cccl
  ];

  cudaMajorVersion = lib.versions.major cudaPackages.cuda_cudart.version;

  cudaToolkit = buildEnv {
    name = "cuda-merged-${cudaMajorVersion}";
    paths = map lib.getLib cudaLibs ++ [
      (lib.getOutput "static" cudaPackages.cuda_cudart)
      (lib.getBin (cudaPackages.cuda_nvcc.__spliced.buildHost or cudaPackages.cuda_nvcc))
    ];
    ignoreCollisions = true;
  };

  cudaPath = lib.removeSuffix "-${cudaMajorVersion}" cudaToolkit;

  wrapperArgs = builtins.concatStringsSep " " [
    "--suffix LD_LIBRARY_PATH : '${addDriverRunpath.driverLink}/lib'"
    "--suffix LD_LIBRARY_PATH : '${lib.makeLibraryPath (map lib.getLib cudaLibs)}'"
  ];

  goBuild = buildGoModule.override { stdenv = cudaPackages.backendStdenv; };
in
goBuild (finalAttrs: {
  pname = "ollama";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QQKPXdXlsT+uMGGIyqkVZqk6OTa7VHrwDVmgDdgdKOY=";
  };

  vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
  proxyVendor = true;

  env.CUDA_PATH = cudaPath;

  nativeBuildInputs = [
    cmake
    gitMinimal
    cudaPackages.cuda_nvcc
    makeBinaryWrapper
    autoAddDriverRunpath
  ];

  buildInputs = cudaLibs;

  postPatch = ''
    substituteInPlace version/version.go \
      --replace-fail 0.0.0 '${finalAttrs.version}'
    rm -r app
  '';

  overrideModAttrs = (
    _finalAttrs: _prevAttrs: {
      preBuild = "";
    }
  );

  preBuild =
    let
      removeSMPrefix =
        str:
        let
          matched = builtins.match "sm_(.*)" str;
        in
        if matched == null then str else builtins.head matched;

      cudaArchitectures = builtins.concatStringsSep ";" (map removeSMPrefix cudaArches);
    in
    ''
      cmake -B build \
        -DCMAKE_SKIP_BUILD_RPATH=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DCMAKE_CUDA_ARCHITECTURES='${cudaArchitectures}' \

      cmake --build build -j $NIX_BUILD_CORES
    '';

  postInstall = ''
    mkdir -p $out/lib
    cp -r build/lib/ollama $out/lib/
  '';

  postFixup = ''
    wrapProgram "$out/bin/ollama" ${wrapperArgs}
  '';

  ldflags = [
    "-X=github.com/ollama/ollama/version.Version=${finalAttrs.version}"
    "-X=github.com/ollama/ollama/server.mode=release"
  ];

  checkFlags =
    let
      skippedTests = [
        "TestPushHandler/unauthorized_push"
        "TestPiRun_InstallAndWebSearchLifecycle"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Get up and running with large language models locally, using CUDA for NVIDIA GPU acceleration";
    homepage = "https://github.com/ollama/ollama";
    changelog = "https://github.com/ollama/ollama/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ollama";
  };
})
