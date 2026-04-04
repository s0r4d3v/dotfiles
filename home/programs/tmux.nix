{ ... }:
{
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../../config/.config/tmux/tmux.conf;
  };
}
