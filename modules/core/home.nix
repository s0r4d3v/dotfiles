{ inputs, config, ... }:
let
  hmModules = builtins.attrValues config.flake.modules.homeManager;
  users = [ "soranagano" ];
in
{
  perSystem =
    { system, ... }:
    let
      homeConfigs = builtins.listToAttrs (
        map (
          userName:
          let
            pkgs = import inputs.nixpkgs { inherit system; };
            nurPkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.nur.overlays.default ];
            };
            homeDir = if pkgs.stdenv.isDarwin then "/Users/${userName}" else "/home/${userName}";
          in
          {
            name = userName;
            value = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              extraSpecialArgs = {
                user = userName;
                inherit homeDir nurPkgs;
                agenix = inputs.agenix.packages.${system}.agenix;
              };
              modules = [
                inputs.nixvim.homeModules.nixvim
                inputs.agenix.homeManagerModules.default
              ]
              ++ hmModules;
            };
          }
        ) users
      );
    in
    {
      legacyPackages.homeConfigurations = homeConfigs;
      packages = builtins.mapAttrs (_: config: config.activationPackage) homeConfigs;
    };
}
