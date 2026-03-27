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
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }: {

    # macOS
    # Apply: darwin-rebuild switch --flake .#soranagano
    # Hostname comes from: scutil --get LocalHostName
    darwinConfigurations."soranagano" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./darwin/configuration.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.soranagano = import ./home/darwin.nix;
        }
      ];
    };

    # Linux (remote server)
    # Apply: home-manager switch --flake .#linux
    homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      modules = [ ./home/linux.nix ];
    };

  };
}
