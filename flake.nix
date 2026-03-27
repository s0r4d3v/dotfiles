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

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
  let
    # Add a new Mac:   darwinConfigurations."<name>" = mkDarwin { username = "<name>"; system = "aarch64-darwin"; };
    # Add a new Linux: homeConfigurations."<name>"   = mkLinux  { username = "<name>"; };
    mkDarwin = { username, system ? "x86_64-darwin" }:
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
            home-manager.users.${username} = import ./home/darwin.nix;
          }
        ];
      };

    mkLinux = { username, system ? "x86_64-linux" }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit username; };
        modules = [ ./home/linux.nix ];
      };
  in
  {
    # macOS — apply: sudo darwin-rebuild switch --flake .#<username>
    darwinConfigurations."soranagano" = mkDarwin { username = "soranagano"; };

    # Linux — apply: home-manager switch --flake .#<username>
    homeConfigurations."soranagano" = mkLinux { username = "soranagano"; };

  };
}
