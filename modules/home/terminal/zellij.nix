{ ... }:
{
  flake.modules.homeManager.zellij =
    { pkgs, ... }:
    {
      programs.zellij = {
        enable = true;
        settings = {
          # Theme (unified with Ghostty/Neovim Dracula)
          theme = "catppuccin-macchiato";

          # Pane frames with rounded corners
          pane_frames = false;

          # Default layout ("default" shows key hints in status bar)
          default_layout = "default";

          default_mode = "locked";

          # Mouse mode
          mouse_mode = false;

          # Use pbcopy on macOS
          copy_command = "pbcopy";

          # Session persistence
          session_serialization = true;
          pane_viewport_serialization = true;
          scrollback_lines_to_serialize = 10000;

          scroll_buffer_size = 10000;

          # Hide startup tips and release notes
          show_startup_tips = false;
          show_release_notes = false;

          # Default shell
          default_shell = "zsh";
        };

        layouts = {
          # ファイル名が layouts/dev.kdl になる
          dev = {
            layout = {
              _children = [
                {
                  default_tab_template = {
                    _children = [
                      {
                        pane = {
                          size = 1;
                          borderless = true;
                          plugin = {
                            location = "zellij:tab-bar";
                          };
                        };
                      }
                      { "children" = { }; }
                      {
                        pane = {
                          size = 2;
                          borderless = true;
                          plugin = {
                            location = "zellij:status-bar";
                          };
                        };
                      }
                    ];
                  };
                }
                {
                  tab = {
                    _props = {
                      name = "Editor";
                      focus = true;
                    };
                    _children = [
                      {
                        pane = {
                          command = "nvim";
                        };
                      }
                    ];
                  };
                }
                {
                  tab = {
                    _props = {
                      name = "Git";
                    };
                    _children = [
                      {
                        pane = {
                          command = "lazygit";
                        };
                      }
                    ];
                  };
                }
                {
                  tab = {
                    _props = {
                      name = "Shell";
                    };
                    _children = [
                      {
                        pane = {
                          command = "zsh";
                        };
                      }
                    ];
                  };
                }
              ];
            };
          };
        };
      };
    };
}
