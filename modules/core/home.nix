{ inputs, config, ... }:
let
  hmModules = builtins.attrValues config.flake.modules.homeManager;
  users = [
    "soranagano"
    "s0r4d3v"
    "m"
    "root"
  ]; # Add more users here for multi-machine support
in
{
  perSystem =
    { system, ... }:
    let
      pkgsUnstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      homeConfigurations = builtins.listToAttrs (
        map (userName: {
          name = userName;
          value = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.nur.overlays.default
                inputs.brew-nix.overlays.default
                # claude-code from nixpkgs-unstable only (statusLine bug fix)
                (_final: _prev: {
                  claude-code = pkgsUnstable.claude-code;
                })
              ];
            };
            extraSpecialArgs = {
              user = userName;
              homeDir =
                if (import inputs.nixpkgs { inherit system; }).stdenv.isDarwin then
                  "/Users/${userName}"
                else if userName == "root" then
                  "/root"
                else
                  "/home/${userName}";
            };
            modules = [
              inputs.nixvim.homeModules.nixvim
              inputs.catppuccin.homeModules.catppuccin
              inputs.sops-nix.homeModules.sops
            ] ++ hmModules;
          };
        }) users
      );
    in
    {
      legacyPackages.homeConfigurations = homeConfigurations;
      packages = builtins.mapAttrs (_: config: config.activationPackage) homeConfigurations;
    };
}
