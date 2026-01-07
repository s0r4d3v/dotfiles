{ ... }:
{
  flake.modules.homeManager.opencode =
    { pkgs, ... }:
    {
      programs.opencode = {
        enable = true;
        settings = {
          theme = "dracula";
        };
      };
    };
}
