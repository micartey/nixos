{
  description = "daniel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-edge.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
    catppuccin.url = "github:catppuccin/nix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-edge,
      ...
    }@inputs:
    let
      stateVersion = "25.05";
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "libsoup-2.74.3"
        ];
      };

      pkgs-edge = import nixpkgs-edge {
        inherit system;
        config.allowUnfree = true;
      };

      meta = {
        user = {
          description = "default non-root user";
          username = "daniel"; # Initial password is the same as the username
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
              pkgs-edge
              stateVersion
              meta
              ;
          };

          modules = [ ./hosts/desktop/home ];
        };

        homeImg = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              pkgs-unstable
              pkgs-edge
              system
              stateVersion
              meta
              ;
          };
          modules = [ ./hosts/img/configuration.nix ];
        };
      };
    };
}
