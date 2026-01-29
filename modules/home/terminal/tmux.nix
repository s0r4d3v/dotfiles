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
          # yankプラグインは削除 - tmux組み込み機能を使用
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
          # ============================================================================
          # クリップボード連携設定（tmux組み込み機能）
          # ============================================================================
          
          # Vi mode for copy mode
          setw -g mode-keys vi

          # クリップボード設定（重要）
          # external: tmuxのみがクリップボードを設定（カスタムコードとの競合を回避）
          set -g set-clipboard external
          set -g allow-passthrough on
          
          # tmux 3.3以降の追加設定
          set -s set-clipboard external
          set -as terminal-features ',xterm-256color:clipboard'

          # ============================================================================
          # コピーモードのキーバインディング（シンプル版）
          # ============================================================================
          
          # 選択開始
          bind-key -T copy-mode-vi 'v' send -X begin-selection
          bind-key -T copy-mode-vi 'r' send -X rectangle-toggle
          
          # コピー（tmux組み込み機能を使用）
          # copy-selection-and-cancel は自動的に set-clipboard と連携する
          bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

          # ============================================================================
          # 一般設定
          # ============================================================================
          
          # Pane numbers display time
          set -g display-panes-time 3000

          # Reload config
          bind r source-file ~/.config/tmux/tmux.conf \; display "Reloaded!"

          # Enter copy mode
          bind v copy-mode

          # Smart split commands
          bind '\' split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          # Vim-style pane navigation
          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

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

          # ============================================================================
          # ステータスバー・テーマ設定
          # ============================================================================
          
          # Purple-themed status bar
          set -g status-position bottom
          set -g status-bg colour235
          set -g status-fg colour248
          set -g status-left '#[bg=colour237,fg=colour248] #[bg=colour235,fg=colour237,nobold]#[bg=colour235,fg=colour248] #S #[bg=colour235,fg=colour237,nobold]'
          set -g status-right '#[bg=colour235,fg=colour237]#[bg=colour237,fg=colour248] %H:%M %d-%b-%y #[bg=colour237,fg=colour235]#[bg=colour235,fg=colour248] #h '
          set -g status-left-length 100
          set -g status-right-length 100

          # Window status styling with purple accents
          setw -g window-status-current-format '#[bg=colour141,fg=colour235,nobold]#[bg=colour141,fg=colour235] #I #[bg=colour141,fg=colour235,bold]#[bg=colour141,fg=colour235] #W #[bg=colour235,fg=colour141,nobold]'
          setw -g window-status-format '#[bg=colour239,fg=colour235,noitalics]#[bg=colour239,fg=colour248] #I #[bg=colour239,fg=colour248]#[bg=colour239,fg=colour248] #W #[bg=colour235,fg=colour239,noitalics]'
          setw -g window-status-current-style 'bg=colour141,fg=colour235'
          setw -g window-status-style 'bg=colour239,fg=colour248'
          setw -g window-status-separator ""

          # Pane borders with purple theme
          set -g pane-border-style 'fg=colour238,bg=colour235'
          set -g pane-active-border-style 'fg=colour141,bg=colour235'

          # Message styling
          set -g message-style 'bg=colour239,fg=colour248'
          set -g message-command-style 'bg=colour239,fg=colour248'

          # Mode styling
          set -g mode-style 'bg=colour141,fg=colour235'
        '';
      };
    };
}
