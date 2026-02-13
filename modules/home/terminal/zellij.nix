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
          pane_frames = true;
          ui.pane_frames.rounded_corners = true;

          # Default layout ("default" shows key hints in status bar)
          default_layout = "default";

          # Mouse mode
          mouse_mode = false;

          # Use pbcopy on macOS
          copy_command = "pbcopy";
          copy_on_select = true;

          # Session persistence (equivalent to tmux resurrect)
          session_serialization = true;
          pane_viewport_serialization = true;
          scrollback_lines_to_serialize = 1000;

          # Hide startup tips and release notes
          show_startup_tips = false;
          show_release_notes = false;

          # Default shell
          default_shell = "zsh";
        };
      };
    };
}
