{ ... }:
{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        settings = {
          theme = "catppuccin_macchiato";
          editor.cursor-shape = {
            insert = "bar";
          };
        };
      };
    };
}
