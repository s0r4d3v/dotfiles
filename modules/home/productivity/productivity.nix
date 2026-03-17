{ ... }:
{
  flake.modules.homeManager.productivity =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          zoom-us
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          raycast
        ];

      # Notes and app-specific guidance left in original module
    };
}
