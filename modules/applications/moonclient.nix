{ config, pkgs, ... }:

# TODO:
# This is not yet working due to an issue on tauri that has been resolved since a year
# But the AppImage is older and does not include the fix...

let
moonclient = pkgs.appimageTools.wrapType2 rec {
    name = "Moon";
    pname = "Moon";
    version = "1.0";

    src = pkgs.fetchurl {
        url = "https://cdn.moonclient.xyz/Moon%20Launcher.AppImage";
        sha256 = "sha256-4xRNWlQ3CIejonmotqmABP0EXn+9n9fLvbfesVMjoi0=";
    };
};
in

{
    environment.systemPackages = with pkgs; [
        moonclient
    ];
}