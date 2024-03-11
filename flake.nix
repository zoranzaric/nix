{
  description = "my config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # https://nix-community.github.io/home-manager/options.html
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://daiderd.com/nix-darwin/manual/index.html
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , darwin
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      devShells =
        forAllSystems
          (system:
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            {
              default = pkgs.mkShell {
                buildInputs = with pkgs; [
                  rnix-lsp
                  nixpkgs-fmt
                  direnv

                  colmena
                ];
              };
            }
          );

      darwinConfigurations = {
        "mbp04" = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./darwin-common.nix
            ./hosts/mbp04
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.zoranzaric = {
                imports = [
                  ./home-common.nix
                  ./home/zoranzaric
                ];
              };
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };

      homeConfigurations = {
        "zoranzaric" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./home-common.nix
            ./home/zoranzaric
          ];
        };
      };

      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
          };

          nodeNixpkgs = {
            node02 = import nixpkgs
              {
                system = "aarch64-linux";
              };
          };
        };

        node02 = {
          deployment = {
            targetHost = "node02.zaric.eu";
            targetPort = 22;
            targetUser = "root";
            buildOnTarget = true;
          };

          imports = [
            ./hosts/node02.zaric.eu
          ];
        };
      };
    };
}
