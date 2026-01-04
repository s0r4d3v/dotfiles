{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.hask = pkgs.mkShell {
      packages = with pkgs; [
        ghc
        haskellPackages.cabal-install
      ];
      shellHook = ''echo "λ Haskell development environment"'';
    };
  };
}