{ ... }:

{
  imports = [
    ./fonts.nix
    ./i18n.nix
    ./users.nix
    ./shell.nix
    ./secret.nix

    ./boot-speedup.nix

    ../modules/nix.nix
  ];
}
