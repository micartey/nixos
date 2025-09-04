{ pkgs, ... }:

{
  home.packages = [
    pkgs.bambu-studio
  ];

  xdg.desktopEntries = {
    "bambu-studio-fix" = {
      name = "BambuStudio (Fix)";
      genericName = "3D Printing Software";
      comment = "BambuStudio with a launch fixes";
      exec = "env GBM_BACKEND=dri bambu-studio";
      icon = "BambuStudio";
    };
  };
}
