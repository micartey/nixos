{ ... }:

{
  imports = [
    ./fonts.nix
    ./i18n.nix
    ./users.nix
    ./shell.nix
    ./secret.nix

    ./boot-speedup.nix

    ../modules/services/docker.nix
    ../modules/nix.nix
  ];
}
