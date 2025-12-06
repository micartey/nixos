{
  stdenv,
  fetchurl,
  unzip,
  autoPatchelfHook,
  pkgs,
  makeWrapper,
  lib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  name = "easyeda";
  version = "6.5.46";

  src = fetchurl {
    url = "https://image.easyeda.com/files/easyeda-linux-x64-${version}.zip";
    sha256 = "sha256-7zFnlAmGbbDJXFPZODDoQxiXwXvFkQTE7Kb4S0oXhUg=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    glib
    nss
    libdrm
    mesa
    alsa-lib
    libGL
    udev
  ];

  unpackPhase = ''
    unzip $src -d .
  '';

  installPhase = ''
    mkdir -p $out/opt/easyeda $out/share/applications/ $out/bin
    cp -rf easyeda-linux-x64/* $out/opt/easyeda
    chmod -R 777 $out/opt/easyeda

    ln -s $out/opt/easyeda/easyeda $out/bin/easyeda

    cp $out/opt/easyeda/EASYEDA.dkt $out/share/applications/EASYEDA.desktop
    substituteInPlace $out/share/applications/EASYEDA.desktop \
        --replace 'Exec=/opt/easyeda/easyeda %f' "Exec=easyeda %f" \
        --replace "Icon=" "Icon=$out"
  '';

  postFixup = ''
    makeWrapper $out/opt/easyeda/easyeda $out/bin/easyeda \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}:$out/opt/easyeda
  '';

  meta = with lib; {
    description = "EasyEDA Std Edition";
    homepage = "https://easyeda.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
