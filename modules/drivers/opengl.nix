{ pkgs, inputs, ... }:

# 24.2.7-1

let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  hardware.graphics = {
    package = pkgs.mesa.overrideAttrs (previousAttrs: {
      version = "24.2.7";
      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "mesa";
        repo = "mesa";
        rev = "mesa-24.2.7";
        hash = "sha256-AM9npUnf/Cl/kPahqeK4Vt6piHv8gKOqrTkE36RIMlg=";
      };
    });

    # enable32Bit = true;
    # package32 = pkgs.pkgsi686Linux.mesa;
  };
}
