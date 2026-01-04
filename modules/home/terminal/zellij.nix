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
          pane split_direction="horizontal" size="25%" {
            pane size="50%" {
              command "nix"
              args ["develop", "/placeholder/dotfiles/path#python"]
            }
            pane size="50%"
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
