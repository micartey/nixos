{
  lib,
  pkgs,
  fetchurl,
  buildFHSEnv,
}:
let
  version = "4.0.0-alpha";
  jar = fetchurl {
    url = "https://github.com/Col-E/Recaf/releases/download/${version}/recaf-4x-alpha-linux-86x64.jar";
    hash = "sha256-XJcPOr0lnCc+cDk88ipcr6toCdrSuC6rO1mLMdJOxmo=";
  };

  javaWithFx = pkgs.zulu25.override { enableJavaFX = true; };
in
buildFHSEnv {
  pname = "recaf";
  inherit version;

  targetPkgs =
    p: with p; [
      jar
      javaWithFx

      xorg.libX11
      at-spi2-atk
      cairo
      gdk-pixbuf
      glib
      gtk3
      pango
      xorg.libXtst
      xorg.libX11
      xorg_sys_opengl
    ];

  runScript = "${javaWithFx}/bin/java -jar ${jar}";

  meta = {
    description = "Recaf 4.X - a modern Java bytecode editor";
    homepage = "https://recaf.coley.software";
    changelog = "https://github.com/Col-E/Recaf-Launcher/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tudbut ];
    mainProgram = "recaf";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
