{ ... }:
{
  flake.modules.homeManager.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        shell = "${pkgs.zsh}/bin/zsh";
        shortcut = "a";
        mouse = false;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          prefix-highlight
          {
            plugin = resurrect;
            extraConfig = ''
              set -g @resurrect-strategy-nvim 'session'
              set -g @resurrect-capture-pane-contents 'on'
            '';
          }
          {
            plugin = continuum;
            extraConfig = ''
              set -g @continuum-restore 'off'
              set -g @continuum-save-interval '60'
            '';
          }
        ];

        extraConfig = ''
          # ============================================================================
          # Clipboard / Copy mode (single tmux only)
          # ============================================================================

          # Vi mode
          setw -g mode-keys vi

          # tmux manages system clipboard directly
          set -g set-clipboard on

          # Ghostty / xterm compatible clipboard
          set -as terminal-features ',xterm-256color:clipboard'

          # Enter copy mode
          bind v copy-mode

          # copy-mode-vi bindings
          bind-key -T copy-mode-vi v send -X begin-selection
          bind-key -T copy-mode-vi r send -X rectangle-toggle
          bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

          # ============================================================================
          # General settings
          # ============================================================================

          set -g display-panes-time 10000

          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

          bind '\' split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          set -g renumber-windows on

          setw -g monitor-activity on
          set -g visual-activity on

          # ============================================================================
          # Status bar / theme
          # ============================================================================

          set -g status-position bottom
          set -g status-bg colour235
          set -g status-fg colour248

          set -g status-left '#[bg=colour237,fg=colour248] #[bg=colour235,fg=colour237,nobold]#[bg=colour235,fg=colour248] #S #[bg=colour235,fg=colour237,nobold]'
          set -g status-right '#[bg=colour235,fg=colour237]#[bg=colour237,fg=colour248] %H:%M %d-%b-%y #[bg=colour237,fg=colour235]#[bg=colour235,fg=colour248] #h '

          set -g status-left-length 100
          set -g status-right-length 100

          setw -g window-status-current-format '#[bg=colour141,fg=colour235,nobold]#[bg=colour141,fg=colour235] #I #[bg=colour141,fg=colour235,bold]#[bg=colour141,fg=colour235] #W #[bg=colour235,fg=colour141,nobold]'
          setw -g window-status-format '#[bg=colour239,fg=colour235,noitalics]#[bg=colour239,fg=colour248] #I #[bg=colour239,fg=colour248]#[bg=colour239,fg=colour248] #W #[bg=colour235,fg=colour239,noitalics]'

          set -g pane-border-style 'fg=colour238,bg=colour235'
          set -g pane-active-border-style 'fg=colour141,bg=colour235'

          set -g message-style 'bg=colour239,fg=colour248'
          set -g message-command-style 'bg=colour239,fg=colour248'

          set -g mode-style 'bg=colour141,fg=colour235'

          # ============================================================================
          # smart-splits.nvim（vim-tmux-navigatorの設定と置き換え）
          # ============================================================================

          bind-key -n C-h if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
          bind-key -n C-j if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
          bind-key -n C-k if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
          bind-key -n C-l if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'

          bind-key -n M-h if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
          bind-key -n M-j if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
          bind-key -n M-k if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
          bind-key -n M-l if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

          tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
          if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\'  'select-pane -l'"
          if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
              "bind-key -n 'C-\\' if -F \"#{@pane-is-vim}\" 'send-keys C-\\\\'  'select-pane -l'"

          bind-key -T copy-mode-vi 'C-h' select-pane -L
          bind-key -T copy-mode-vi 'C-j' select-pane -D
          bind-key -T copy-mode-vi 'C-k' select-pane -U
          bind-key -T copy-mode-vi 'C-l' select-pane -R
          bind-key -T copy-mode-vi 'C-\' select-pane -l
        '';
      };
    };
}
