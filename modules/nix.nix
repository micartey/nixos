{ inputs, pkgs, ... }:

{
  imports = [ inputs.nix-ld.nixosModules.nix-ld ];

  system.stateVersion = "24.11";

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

  programs.nix-ld.dev.enable = true;

  environment.systemPackages = with pkgs; [
    # nix language server
    nixd
    nixfmt-rfc-style

    # nix-alien
    inputs.nix-alien.packages.${system}.nix-alien
  ];
}
