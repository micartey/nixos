{
  description = "daniel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    opencode.url = "github:sst/opencode";
    rime.url = "github:lukasl-dev/rime";

    sops-nix.url = "github:Mic92/sops-nix";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    catppuccin.url = "github:catppuccin/nix";

    nix-vim = {
      url = "github:micartey/nix-vim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      ...
    }@inputs:
    let
      stateVersion = "25.05"; # DO NOT UPDATE
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      meta = {
        user = {
          username = "daniel"; # Initial password is the same as the username
          description = "daniel";
          homeDir = "/home/daniel";
        };

        git = {
          username = "micartey";
          email = "me@micartey.dev";
        };

        timeZone = "Europe/Berlin";
        locale = "de_DE.UTF-8";
      };
    in
    {
      nixosConfigurations = {
        home = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              stateVersion
              meta
              ;
          };

          modules = [
            ./hosts/desktop/home
          ];
        };
      };
    };
}
