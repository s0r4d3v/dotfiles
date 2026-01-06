{ ... }:
{
  flake.modules.homeManager.tmux = { pkgs, ... }: {
    programs.tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      shortcut = "a";
      mouse = true;

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
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
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }
      ];

      extraConfig = ''
        # Modern terminal support
        set -g default-terminal "tmux-256color"
        set -ga terminal-overrides ",*256col*:Tc"
        set -ga terminal-overrides ",*256col*:RGB"
        set -ga terminal-overrides ",xterm-256color:Tc"
        set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

        # Focus events for better editor integration
        set -g focus-events on

        # Vi mode for copy mode
        setw -g mode-keys vi

        # Vi mode copy settings
        bind-key -T copy-mode-vi 'v' send -X begin-selection
        bind-key -T copy-mode-vi 'y' send -X copy-selection
        bind-key -T copy-mode-vi 'r' send -X rectangle-toggle

        # Reload config
        bind r source-file ~/.tmux.conf \; display "Reloaded!"

        # Smart split commands
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Vim-style pane navigation
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Window navigation (with prefix for consistency)
        bind p previous-window
        bind n next-window

        # Pane resizing
        bind -r H resize-pane -L 5
        bind -r J resize-pane -D 5
        bind -r K resize-pane -U 5
        bind -r L resize-pane -R 5

        # Automatic window renumbering
        set -g renumber-windows on

        # Activity monitoring
        setw -g monitor-activity on
        set -g visual-activity on

        # Modern status bar
        set -g status-position bottom
        set -g status-bg colour237
        set -g status-fg colour223
        set -g status-left '#[bg=colour241,fg=colour248] #[bg=colour237,fg=colour241,nobold]#[bg=colour237,fg=colour248] #S #[bg=colour237,fg=colour241,nobold]'
        set -g status-right '#[bg=colour237,fg=colour241]#[bg=colour241,fg=colour248] %H:%M %d-%b-%y #[bg=colour241,fg=colour237]#[bg=colour237,fg=colour248] #h '
        set -g status-left-length 100
        set -g status-right-length 100

        # Window status styling
        setw -g window-status-current-format '#[bg=colour214,fg=colour237,nobold]#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold]#[bg=colour214,fg=colour239] #W #[bg=colour237,fg=colour214,nobold]'
        setw -g window-status-format '#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour223] #I #[bg=colour239,fg=colour223]#[bg=colour239,fg=colour223] #W #[bg=colour237,fg=colour239,noitalics]'
        setw -g window-status-current-style 'bg=colour214,fg=colour237'
        setw -g window-status-style 'bg=colour239,fg=colour223'
        setw -g window-status-separator ''

        # Pane borders
        set -g pane-border-style 'fg=colour238,bg=colour237'
        set -g pane-active-border-style 'fg=colour214,bg=colour237'

        # Message styling
        set -g message-style 'bg=colour239,fg=colour223'
        set -g message-command-style 'bg=colour239,fg=colour223'

        # Mode styling
        set -g mode-style 'bg=colour214,fg=colour239'
      '';
    };
  };
}
