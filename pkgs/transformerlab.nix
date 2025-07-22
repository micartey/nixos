{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  gobject-introspection,
}:

let
  pname = "transformerlab";
  version = "0.20.2";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = pname;
    genericName = "Finetune LLMs";
    categories = [ "Application" ];
  };

in
appimageTools.wrapType2 rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/transformerlab/transformerlab-app/releases/download/v${version}/Transformer-Lab-${version}.AppImage";
    hash = "sha256-rQsVhQM8qjYMJCCbnOeiQdnHDtmBGyUbfj8dGq6Sr5Q=";
  };

  buildInputs = [ gobject-introspection ];

  extraInstallCommands = ''
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  meta = with lib; {
    description = "Finetune LLMs";
    homepage = "https://transformerlab.ai/";
    license = licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
