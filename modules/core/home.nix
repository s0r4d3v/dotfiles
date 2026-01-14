{ inputs, config, ... }:
let
  hmModules = builtins.attrValues config.flake.modules.homeManager;
  users = [ "soranagano" ];
in
{
  perSystem =
    { system, ... }:
    {
      legacyPackages.homeConfigurations = builtins.listToAttrs (
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
              };
              modules = [ inputs.nixvim.homeModules.nixvim ] ++ hmModules;
            };
          }
        ) users
      );
    };
}
