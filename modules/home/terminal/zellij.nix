{ ... }:
{
  flake.modules.homeManager.zellij = { pkgs, ... }: {
    home.packages = [ pkgs.zellij ];
    home.file.".config/zellij/layouts/dev.kdl".text = ''
      layout {
        pane split_direction="vertical" {
          pane split_direction="horizontal" size="60%" {
            pane size="60%" focus=true name="nvim" {
              command "nvim"
            }
            pane size="40%" name="cmd"
          }
          pane split_direction="horizontal" size="40%" {
            pane size="60%" name="git" {
              command "lazygit"
            }
            pane size="40%" name="stats" {
              command "btop"
            }
          }
        }
      }
    '';
    home.file.".config/zellij/config.kdl".text = ''
      default_mode "locked"
      default_shell "zsh"
      keybinds {
        locked {
          bind "Ctrl g" { SwitchToMode "Normal"; }
        }
        normal {
          bind "Ctrl g" { SwitchToMode "Locked"; }
        }
      }
    '';
  };
}
