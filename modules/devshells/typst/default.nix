{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.typst = pkgs.mkShell {
      packages = with pkgs; [
        typst
      ];
      shellHook = ''echo "📝 Typst $(typst --version)"'';
    };
  };
}