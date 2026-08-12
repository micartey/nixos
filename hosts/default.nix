{ ... }:

{
  imports = [
    ./fonts.nix
    ./i18n.nix
    ./users.nix
    ./secret.nix

    ./boot-speedup.nix

    ./dnscontrol.nix

    ../modules/services/docker.nix
    ../modules/nix.nix
  ];
}
