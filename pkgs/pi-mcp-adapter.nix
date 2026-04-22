{
  inputs,
  pkgs,
  ...
}:

pkgs.buildNpmPackage {
  pname = "pi-mcp-adapter";
  version = "2.4.1";
  src = inputs.pi-mcp-adapter.outPath;
  npmDepsHash = "sha256-p0UyUcK7S9BWQtuarEMUOfvE+UXwIj5IJWZFFg0FDWo=";
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r node_modules $out/node_modules
    cp *.ts $out/
    cp app-bridge.bundle.js $out/

    runHook postInstall
  '';
}