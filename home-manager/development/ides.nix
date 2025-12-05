{ pkgs, pkgs-unstable, ... }:

{
  home.packages = [
    # jetbrains
    pkgs-unstable.jetbrains.idea-ultimate

    # Java debugger
    pkgs.async-profiler
    pkgs.bytecode-viewer

    # Arduino
    pkgs.arduino

    # vscode
    # pkgs.vscode

    pkgs-unstable.gemini-cli
    pkgs-unstable.codex

    # text-editors
    pkgs.vim
    pkgs-unstable.zed-editor
  ];
}
