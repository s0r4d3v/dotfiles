{ ... }:
{
  flake.modules.homeManager.zellij = {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "default";
        default_shell = "zsh";
        pane_frames = false;
        simplified_ui = true;
        copy_command = "pbcopy";  # macOS, Linux will use wl-copy/xclip
      };
    };
    home.file.".config/zellij/layouts/dev.kdl".text = ''
      layout {
        pane split_direction="vertical" {
          pane size="60%" focus=true {
            command "nvim"
          }
          pane split_direction="horizontal" size="40%" {
            pane size="50%"
            pane size="50%"
          }
        }
      }
    '';
    programs.zsh.initContent = ''
      if [[ -z "$ZELLIJ" ]]; then
        zellij --layout dev
      fi
    '';
  };
}
