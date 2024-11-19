{ inputs, pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    # jetbrains
    pkgs-unstable.jetbrains.idea-ultimate

    # vscode
    pkgs.vscode
    pkgs.vscode-extensions.antyos.openscad
    pkgs.vscode-extensions.bbenoist.nix
    pkgs.vscode-extensions.bierner.github-markdown-preview
    pkgs.vscode-extensions.continue.continue
    pkgs.vscode-extension.astro-build.astro-vscode
    pkgs.vscode-extension.JakeBecker.elixir-ls
    pkgs.vscode-extension.yzhang.markdown-all-in-on
    pkgs.vscode-extension.redhat.vscode-yaml
  ];
}
