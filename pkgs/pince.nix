{
  appimageTools,
  fetchurl,
  lib,
  makeDesktopItem,
  gobject-introspection,
}:

let
  pname = "pince";
  version = "0.4.2";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = pname;
    genericName = "Reverse Engineering for Games";
    categories = [ "Application" ];
  };

in
appimageTools.wrapType2 rec {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/korcankaraokcu/PINCE/releases/download/v${version}/PINCE-x86_64.AppImage";
    hash = "sha256-f3H7u2W1qOjlQ99Rol37VyBi17ypDy1wdk026jTEaxE=";
  };

  buildInputs = [ gobject-introspection ];

  extraInstallCommands = ''
    mkdir "$out/share"
    ln -s "${desktopItem}/share/applications" "$out/share/"
  '';

  meta = with lib; {
    description = "Reverse engineering tool for linux games";
    homepage = "https://github.com/korcankaraokcu/PINCE";
    license = licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
