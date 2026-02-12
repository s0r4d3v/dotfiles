{ ... }:
{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        settings = {
          theme = "onedark";
          editor.cursor-shape = {
            insert = "bar";
          };
        };
      };
    };
}
