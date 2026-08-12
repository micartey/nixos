{ ... }:

{
  imports = [
    ./fonts.nix
    ./i18n.nix
    ./users.nix
    ./secret.nix

    ./boot-speedup.nix

    ./dnscontrol.nix

  ];
}
