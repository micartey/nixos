{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  home.packages = [
    # jetbrains
    pkgs-unstable.jetbrains.idea

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
    inputs.nix-vim.packages.${pkgs.system}.default
    pkgs-unstable.zed-editor
  ];
}
