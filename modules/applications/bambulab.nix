{ pkgs-unstable, ... }:

# let
# bambulab = pkgs.appimageTools.wrapType2 rec {
#     name = "BambuStudio";
#     pname = "bambustudio";
#     version = "01.10.01.50";

#     src = pkgs.fetchurl {
#         url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_linux_ubuntu_20.04_v${version}.AppImage ";
#         sha256 = "sha256-i3WRPosApSm4bGezOcCgw+aqB4i5adhOfPShdDSPaXo=";
#     };

#     profile = ''
#     export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
#     export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
#     '';

#     extraPkgs = pkgs: with pkgs; [
#         cacert
#         curl
#         glib
#         glib-networking
#         gst_all_1.gst-plugins-bad
#         gst_all_1.gst-plugins-base
#         gst_all_1.gst-plugins-good
#         webkitgtk_4_1
#     ];
# };
# in

{
  environment.systemPackages = with pkgs-unstable; [
    bambu-studio
  ];
}
