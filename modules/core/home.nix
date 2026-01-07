{ inputs, config, ... }:
let
  hmModules = builtins.attrValues config.flake.modules.homeManager;

  mkHomeConfig =
    { system, userName }:
    let
      # nixpkgs without global unfree
      pkgs = import inputs.nixpkgs {
        inherit system;
      };
      nurPkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.nur.overlays.default ];
      };
      # homeDirはシステムから自動計算
      homeDir = if pkgs.stdenv.isDarwin then "/Users/${userName}" else "/home/${userName}";
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        user = userName;
        inherit homeDir nurPkgs;
      };
      modules = [ inputs.nixvim.homeModules.nixvim ] ++ hmModules;
    };
in
{
  perSystem =
    { system, ... }:
    {
      # 任意のユーザー名でビルド可能
      # 使用例: nix build '.#homeConfigurations."your-username".activationPackage'
      legacyPackages.homeConfigurations = builtins.listToAttrs (
        map
          (userName: {
            name = userName;
            value = mkHomeConfig { inherit system userName; };
          })
          [
            # ここにユーザー名を追加（またはビルドコマンドで直接指定）
            "soranagano"
            # 他のマシン用に追加可能
            # "work-user"
          ]
      );
    };
}
