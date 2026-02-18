{ ... }:
{
  flake.modules.homeManager.productivity =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          discord
          slack
          zoom-us
          bitwarden-desktop
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          raycast
          brewCasks.notion
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          notion-app
        ];

      # Notes and app-specific guidance left in original module
    };
}
