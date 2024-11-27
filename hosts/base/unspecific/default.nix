{ pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./i18n.nix
    ./users.nix
    ./shell.nix

    ../../../modules/services/docker.nix
  ];

  system.stateVersion = "24.05";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "daniel"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    # nix language server
    nixd
    nixfmt-rfc-style
  ];
}
