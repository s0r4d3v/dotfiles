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
      };
    };
}
