{ inputs, config, ... }:
let
  hmModules = builtins.attrValues config.flake.modules.homeManager;
  users = [ "soranagano" ]; # Add more users here for multi-machine support
in
{
  perSystem =
    { system, ... }:
    let
      homeConfigurations = builtins.listToAttrs (
        map (userName: {
          name = userName;
          value = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs { inherit system; };
            extraSpecialArgs = {
              user = userName;
              homeDir =
                if (import inputs.nixpkgs { inherit system; }).stdenv.isDarwin then
                  "/Users/${userName}"
                else
                  "/home/${userName}";
              nurPkgs = import inputs.nixpkgs {
                inherit system;
                overlays = [ inputs.nur.overlays.default ];
              };
            };
            modules = [ inputs.nixvim.homeModules.nixvim ] ++ hmModules;
          };
        }) users
      );
    in
    {
      legacyPackages.homeConfigurations = homeConfigurations;
      packages = builtins.mapAttrs (_: config: config.activationPackage) homeConfigurations;
    };
}
