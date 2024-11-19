{ inputs, pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    # jetbrains
    pkgs-unstable.jetbrains.idea-ultimate
    pkgs.vscode
  ]

  
}
