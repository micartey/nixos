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
    pkgs.vscode-extensions.astro-build.astro-vscode
    pkgs.vscode-extensions.elixir-lsp.vscode-elixir-ls
    pkgs.vscode-extensions.yzhang.markdown-all-in-one
    pkgs.vscode-extensions.redhat.vscode-yaml
  ];
}
