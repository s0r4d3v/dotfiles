{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.markdown = pkgs.mkShell {
      packages = with pkgs; [
      ];
      shellHook = ''echo "📝 Markdown development environment"'';
    };
  };
}