{ ... }:
{
  # Git integration (gitsigns)
  flake.modules.homeManager.neovim-git = {
    programs.nixvim = {
      plugins.gitsigns = {
        enable = true;
        settings = {
          signs = {
            add.text = "│";
            change.text = "│";
            delete.text = "_";
            topdelete.text = "‾";
            changedelete.text = "~";
          };
          current_line_blame = true;
          current_line_blame_opts.delay = 500;
        };
      };
    };
  };
}
