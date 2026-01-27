{ ... }:
{
  flake.modules.homeManager.google-chrome =
    { pkgs, ... }:
    {
      programs.google-chrome = {
        enable = true;
      };
    };
}
