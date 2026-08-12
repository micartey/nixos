{
  description = "daniel";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-legacy.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-edge.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    viro.url = "github:micartey/viro";

    # nix flake update opencode --override-input opencode "github:anomalyco/opencode?ref=v1.18.15"
    opencode.url = "github:anomalyco/opencode";
    rime.url = "github:lukasl-dev/rime";

    sops-nix.url = "github:Mic92/sops-nix";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # pinned — do not update (staying on old version)
    diutalia = {
      url = "github:micartey/diutalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";
    catppuccin.url = "github:catppuccin/nix/release-26.05";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    nix-vim = {
      url = "github:micartey/nix-vim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    handy = {
      url = "github:cjpais/Handy";
    };

    fff-nvim = {
      url = "github:dmtrKovalenko/fff.nvim";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-legacy,
      nixpkgs-edge,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.permittedInsecurePackages = [
          "gradle-7.6.6"
          "electron-39.8.10"
        ];
      };

      pkgs-edge = import nixpkgs-edge {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-legacy = import nixpkgs-legacy {
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

      specialArgs = {
        inherit
          inputs
          pkgs-unstable
          pkgs-legacy
          pkgs-edge
          system
          meta
          ;
      };

      mkHost =
        currentProfile: module:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // {
            inherit currentProfile;
          };
          modules = [ module ];
        };
    in
    {
      nixosConfigurations = {
        home = mkHost "home" ./hosts/home;

        lenovo-yoga-7x-pro = mkHost "lenovo" ./hosts/lenovo-yoga-7x-pro;

        homeImg = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = specialArgs // {
            currentProfile = "home";
          };
          modules = [ ./hosts/img/configuration.nix ];
        };
      };
    };
}
