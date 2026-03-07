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
        ];

      # Notes and app-specific guidance left in original module
    };
}
