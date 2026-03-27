{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    git
    ripgrep
    fd
    fzf
    eza
    bat
    jq
    zoxide
    starship
    # formatters / linters (used by neovim conform + nvim-lint)
    stylua
    ruff
    nodePackages.prettier
    shfmt
    shellcheck
  ];

  # ===========================================================================
  # Neovim — installed via Nix, config managed via xdg.configFile
  # ===========================================================================
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # sets $EDITOR and $VISUAL
  };

  xdg.configFile."nvim" = {
    source = ../config/nvim;
    recursive = true;
  };

  # ===========================================================================
  # Zsh
  # ===========================================================================
  programs.zsh = {
    enable = true;
    history = {
      path     = "${config.home.homeDirectory}/.zsh_history";
      size     = 10000;
      save     = 10000;
      ignoreDups  = true;
      ignoreSpace = true;
      share    = true;
    };
    shellAliases = {
      vim   = "nvim";
      ll    = "ls -lah";
      ".."  = "cd ..";
      "..." = "cd ../..";
    };
    initContent = ''
      eval "$(zoxide init zsh)"

      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats ' (%b)'
      setopt PROMPT_SUBST
      PROMPT='%F{cyan}%~%f%F{yellow}''${vcs_info_msg_0_}%f %# '
    '';
  };

  home.sessionVariables = {
    LANG   = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # ===========================================================================
  # Tmux
  # ===========================================================================
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",*:RGB"

      set -g set-clipboard on
      set -g allow-passthrough on

      set -sg escape-time 10
      set -g focus-events on

      set -g mouse on
      set -g history-limit 50000
      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix

      bind r source-file ~/.tmux.conf \; display "Reloaded"
      bind -  split-window -v -c "#{pane_current_path}"
      bind '\' split-window -h -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      setw -g mode-keys vi
      bind v copy-mode
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi V send -X select-line
      bind -T copy-mode-vi y send -X copy-selection-and-cancel
    '';
  };

  home.stateVersion = "25.11";
}
