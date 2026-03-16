{ ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        prefix = "C-a";
        keyMode = "vi";
        escapeTime = 0;
        historyLimit = 10000;
        terminal = "tmux-256color";
        mouse = false;
        baseIndex = 1;
        customPaneNavigationAndResize = false; # handled by vim-tmux-navigator

        plugins = with pkgs.tmuxPlugins; [
          {
            plugin = catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavor 'macchiato'
              set -g @catppuccin_window_status_style "rounded"
              set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}"
              set -g status-left ""
            '';
          }
          {
            plugin = tmux-floax;
            extraConfig = ''
              set -g @floax-bind 't'
              set -g @floax-bind-menu 'T'
              set -g @floax-width '80%'
              set -g @floax-height '80%'
              set -g @floax-border-color 'magenta'
              set -g @floax-change-path 'true'
            '';
          }
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'on'
              set -g @continuum-save-interval '15'
            '';
          }
          yank
          vim-tmux-navigator
          {
            plugin = tmux-sessionx;
            extraConfig = ''
              set -g @sessionx-bind 'o'
            '';
          }
          extrakto
          tmux-thumbs
        ];

        extraConfig = ''
          bind C-a send-prefix

          bind \\ split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          bind v copy-mode

          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

          setw -g pane-base-index 1
          set -g display-panes-time 10000
        '';
      };
    };
}
