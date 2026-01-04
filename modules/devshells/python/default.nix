{ inputs, ... }:
{
  perSystem = { system, ... }: let
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in {
    devShells.python = pkgs.mkShell {
      packages = with pkgs; [
        python313Packages.jupyter
        uv
      ];
      shell = "${pkgs.zsh}/bin/zsh";
      shellHook = ''
        if [ ! -d venv ]; then
          uv venv venv
        fi
        source venv/bin/activate
        uv pip install marimo
      '';
    };
  };
}