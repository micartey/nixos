{
  inputs,
  pkgs,
  ...
}:

pkgs.buildNpmPackage {
  pname = "pi-fff";
  version = "0.6.0";
  src = inputs.fff-nvim.outPath;
  npmDepsHash = "sha256-BbGGN7Y7x9Yf5xXMjoGqJFLj7Hw1p19DcJRiG5lkkRw=";
  npmInstallFlags = [ "--include=optional" ];
  npmRebuildFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    npm run build --workspace packages/fff-node

    mkdir -p packages/fff-node/bin
    cp ${
      inputs.fff-nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
    }/lib/libfff_c.so packages/fff-node/bin/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p \
      $out/packages \
      $out/target/release \
      $out/node_modules \
      $out/node_modules/@ff-labs \
      $out/node_modules/@yuuang

    cp -r packages/pi-fff $out/packages/
    cp -r packages/fff-node $out/packages/
    cp -r node_modules/ffi-rs $out/node_modules/
    cp -r node_modules/@yuuang/* $out/node_modules/@yuuang/
    ln -s ../../packages/fff-node $out/node_modules/@ff-labs/fff-node

    cp packages/fff-node/bin/libfff_c.so $out/target/release/
    touch $out/Cargo.toml

    runHook postInstall
  '';
}
