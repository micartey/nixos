{
  inputs,
  pkgs,
  stateVersion,
  meta,
  lib,
  ...
}:

{
  imports = [ inputs.nix-ld.nixosModules.nix-ld ];

  system.stateVersion = stateVersion;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      meta.user.username
    ];

    # binary cache
    substituters = [
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nix-ld = {
    enable = true;
    dev.enable = false;
  };

  environment.systemPackages = with pkgs; [
    # nix language server
    nixd
    nixfmt-rfc-style

    # nix-alien
    inputs.nix-alien.packages.${system}.nix-alien
  ];
}
