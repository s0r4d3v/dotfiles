{ ... }:
{
  flake.modules.homeManager.zellij = { pkgs, ... }: {
    home.packages = [ pkgs.zellij ] ++ (if pkgs.stdenv.isLinux then [ pkgs.xclip ] else []);
    home.file.".config/zellij/layouts/dev.kdl".text = ''
      layout {
        pane split_direction="vertical" {
          pane size="75%" focus=true {
            command "nvim"
          }
          pane split_direction="horizontal" size="25%" {
            pane size="50%"
            pane size="50%"
          }
        }
      }
    '';
    home.file.".config/zellij/config.kdl".text = ''
      default_mode "locked"
      default_shell "zsh"
      ${if pkgs.stdenv.isDarwin then ''
      copy_command "pbcopy"
      paste_command "pbpaste"
      '' else ''
      copy_command "xclip -selection clipboard"
      paste_command "xclip -selection clipboard -o"
      ''}
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
