{ ... }:
{
  flake.modules.homeManager.zellij = { pkgs, ... }: {
    home.packages = [ pkgs.zellij ];
    home.file.".config/zellij/layouts/dev.kdl".text = ''
      layout {
        pane split_direction="vertical" {
          pane size="75%" focus=true {
            command "nvim"
          }
          pane split_direction="horizontal" size="40%" {
            pane size="50%"
            pane size="50%"
          }
        }
      }
    '';
    # キーバインディング設定
    home.file.".config/zellij/config.kdl".text = ''
      default_mode "locked"
      default_shell "zsh"
      keybinds {
        locked {
          bind "Ctrl \\" { SwitchToMode "Normal"; }
        }
        normal {
          bind "Ctrl \\" { SwitchToMode "Locked"; }
        }
      }
    '';
  };
}
