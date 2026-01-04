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
        tab name="dev" {
          pane command="nvim"
          pane split_direction="vertical"
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
