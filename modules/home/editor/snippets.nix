{ ... }:
{
  flake.modules.homeManager.neovim-snippets =
    { pkgs, ... }:
    {
      programs.nixvim = {
        plugins = {
          friendly-snippets = {
            enable = true;
          };

          luasnip = {
            enable = true;
          };
        };
      };
    };
}
