{ ... }:
{
  # UI: Colorscheme, Statusline, Snacks
  flake.modules.homeManager.neovim-plugins =
    { pkgs, ... }:
    {
      programs.nixvim = {
        colorschemes.dracula = {
          enable = true;
        };

        plugins.bufferline = {
          enable = true;
        };

        plugins.lualine = {
          enable = true;
          settings.options = {
            theme = "auto";
            globalstatus = true;
            component_separators = {
              left = "│";
              right = "│";
            };
            section_separators = {
              left = "";
              right = "";
            };
          };
        };

        plugins.nvim-autopairs = {
          enable = true;
        };

        plugins.mini = {
          enable = true;
          mockDevIcons = true;
          modules = {
            icons = { };
            starter = {
              header = ''
                 @@@@@@    @@@@@@@@   @@@@@@@        @@@   @@@@@@@   @@@@@@   @@@  @@@  
                @@@@@@@   @@@@@@@@@@  @@@@@@@@      @@@@   @@@@@@@@  @@@@@@@  @@@  @@@  
                !@@       @@!   @@@@  @@!  @@@     @@!@!   @@!  @@@      @@@  @@!  @@@  
                !@!       !@!  @!@!@  !@!  @!@    !@!!@!   !@!  @!@      @!@  !@!  @!@  
                !!@@!!    @!@ @! !@!  @!@!!@!    @!! @!!   @!@  !@!  @!@!!@   @!@  !@!  
                 !!@!!!   !@!!!  !!!  !!@!@!    !!!  !@!   !@!  !!!  !!@!@!   !@!  !!!  
                     !:!  !!:!   !!!  !!: :!!   :!!:!:!!:  !!:  !!!      !!:  :!:  !!:  
                    !:!   :!:    !:!  :!:  !:!  !:::!!:::  :!:  !:!      :!:   ::!!:!   
                :::: ::   ::::::: ::  ::   :::       :::    :::: ::  :: ::::    ::::    
                :: : :     : : :  :    :   : :       :::   :: :  :    : : :      :      
              '';
              evaluate_single = true;
            };
            surround = { };
            bufremove = { };
            splitjoin = { };
            move = { };
            ai = { };
          };
        };

        plugins.snacks = {
          enable = true;
          settings = {
            notifier.enabled = true;
            statuscolumn.enabled = true;
            indent.enabled = true;
            input.enabled = true;
            scroll.enabled = true;
            bigfile.enabled = true;
            quickfile.enabled = true;
            words.enabled = true;
            picker.enabled = true;
            lazygit.enabled = true;
            git.enabled = true;
          };
        };

        plugins.flash = {
          enable = true;
          # settings.modes.search.enabled = true;
        };

        plugins.yazi = {
          enable = true;
        };

        plugins.quarto = {
          enable = true;
        };

        plugins.otter = {
          enable = true;
        };

        plugins.which-key = {
          enable = true;
          settings.delay = 200;
        };

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

        plugins.bullets = {
          enable = true;
          settings = {
            enabled_file_types = [
              "markdown"
              "text"
              "gitcommit"
              "scratch"
              "quarto"
            ];
            outline_levels = [ "std-" ];
          };
        };

        plugins.ts-autotag = {
          enable = true;
          settings = {
            opts = {
              enable_close = true;
              enable_rename = true;
              enable_close_on_slash = true;
            };
          };
        };

        plugins.undotree = {
          enable = true;
        };

        plugins.treesj = {
          enable = true;
        };

        plugins.fidget = {
          enable = true;
        };

        plugins.todo-comments = {
          enable = true;
        };

        plugins.treesitter-context = {
          enable = true;
        };

        plugins.tiny-inline-diagnostic = {
          enable = true;
        };

        plugins.render-markdown = {
          enable = true;
        };

        # plugins.nvim-hlslens = {
        #   enable = true;
        # };

        # plugins.nvim-ufo = {
        #   enable = true;
        # };
      };
    };
}
