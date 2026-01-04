{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.quarto = pkgs.mkShell {
      packages = with pkgs; [
        quarto
        python313Packages.jupyter
        python313Packages.matplotlib
        python313Packages.pandas
      ];
      shellHook = ''echo "📊 Quarto $(quarto --version)"'';
    };
  };
}