{ ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        prefix = "C-a";
        keyMode = "vi";
        escapeTime = 10;
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
              set -g status-right "#{prefix_highlight}#{E:@catppuccin_status_application}#{E:@catppuccin_status_session}"
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
            plugin = prefix-highlight;
            extraConfig = ''
              set -g @prefix_highlight_show_copy_mode 'on'
              set -g @prefix_highlight_copy_mode_attr 'fg=black,bg=yellow,bold'
            '';
          }
          {
            plugin = tmux-sessionx;
            extraConfig = ''
              set -g @sessionx-bind 'o'
            '';
          }
          extrakto
          tmux-thumbs
          {
            plugin = fuzzback;
            extraConfig = ''
              set -g @fuzzback-bind '/'
            '';
          }
        ];

        extraConfig = ''
          bind C-a send-prefix

          bind \\ split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          bind v copy-mode

          bind-key -T copy-mode-vi v send-keys -X begin-selection
          bind-key -T copy-mode-vi V send-keys -X select-line

          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

          setw -g pane-base-index 1
          set -g display-panes-time 10000
          set -g focus-events on
          set -g pane-border-lines heavy
          set -g pane-border-style 'fg=colour240'
          set -g pane-active-border-style 'fg=#8aadf4,bold'

        '';
      };
    };
}
