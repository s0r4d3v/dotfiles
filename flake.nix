{
  description = "s0r4d3v dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      sops-nix,
      ...
    }:
    let
      # To add a new user, add entries for each platform they use.
      # Apply with: ./switch  (auto-detects platform)
      mkDarwin =
        { username, system }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit username; };
          modules = [
            ./darwin/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit username; };
              home-manager.sharedModules = [ sops-nix.homeManagerModules.sops ];
              home-manager.users.${username} = import ./home/darwin.nix;
              # Ensure unfree packages (e.g. claude-code) are allowed in HM context
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };

      mkLinux =
        { username, system }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = { inherit username; };
          modules = [
            ./home/linux.nix
            sops-nix.homeManagerModules.sops
          ];
        };
    in
    {
      darwinConfigurations = {
        "soranagano-aarch64" = mkDarwin {
          username = "soranagano";
          system = "aarch64-darwin";
        };
        "soranagano-x86_64" = mkDarwin {
          username = "soranagano";
          system = "x86_64-darwin";
        };
        "m-x86_64" = mkDarwin {
          username = "m";
          system = "x86_64-darwin";
        };
        "snagano-aarch64" = mkDarwin {
          username = "snagano";
          system = "aarch64-darwin";
        };
      };

      homeConfigurations = {
        "soranagano-x86_64" = mkLinux {
          username = "soranagano";
          system = "x86_64-linux";
        };
        "soranagano-aarch64" = mkLinux {
          username = "soranagano";
          system = "aarch64-linux";
        };
        "s0r4d3v-x86_64" = mkLinux {
          username = "s0r4d3v";
          system = "x86_64-linux";
        };
        "s0r4d3v-aarch64" = mkLinux {
          username = "s0r4d3v";
          system = "aarch64-linux";
        };
      };
    };
}
