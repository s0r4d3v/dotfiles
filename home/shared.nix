{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    # Core
    git
    ripgrep # rg  — fast grep
    fd # fd  — fast find
    fzf
    jq
    zoxide # z   — smart cd
    # Modern replacements
    eza # ls/ll/tree
    bat # cat
    delta # git diff pager
    dust # du
    btop # top
    glow # markdown preview
    tldr # quick man pages
    # Dev
    gh # GitHub CLI
    lazygit # git TUI (used by tmux popup + nvim plugin)
    claude-code
    nodejs # runtime for node-based LSP servers and tools

    # ===========================================================================
    # Neovim LSP servers (all managed by Nix; enabled via vim.lsp.enable in nvim)
    # ===========================================================================
    lua-language-server # lua_ls
    pyright # python
    bash-language-server # bashls
    typescript-language-server # ts_ls  (JS / TS)
    vscode-langservers-extracted # html, cssls, jsonls
    yaml-language-server # yamlls
    vue-language-server # vue_ls (Vue / Slidev)
    nixd # nixd
    # spyglassmc_language_server: no nixpkgs package — launched via npx in nvim config

    # ===========================================================================
    # Neovim formatters & linters (managed by Nix; used by conform + nvim-lint)
    # ===========================================================================
    nixfmt # Nix
    stylua # Lua
    ruff # Python
    shfmt # Shell
    shellcheck # Shell
    prettier # JS/TS/HTML/CSS/Vue/JSON/YAML/Markdown
    eslint_d # JS/TS/Vue linter daemon
    nodePackages.stylelint # CSS linter
    # Secrets
    age # modern encryption (encrypt files, secrets)
    sops # secrets manager (wraps age/gpg, works with Nix)
  ];

  # ===========================================================================
  # Neovim — installed via Nix, config managed via xdg.configFile
  # ===========================================================================
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets $EDITOR and $VISUAL
  };

  xdg.configFile."nvim" = {
    source = ../config/nvim;
    recursive = true;
  };

  # ===========================================================================
  # Tool configs — all managed declaratively
  # ===========================================================================
  xdg.configFile."atuin/config.toml".source    = ../config/atuin/config.toml;
  xdg.configFile."direnv/direnvrc".source      = ../config/direnv/direnvrc;
  xdg.configFile."jj/config.toml".source       = ../config/jj/config.toml;
  xdg.configFile."yazi/yazi.toml".source       = ../config/yazi/yazi.toml;
  xdg.configFile."opencode/config.json".source = ../config/opencode/config.json;
  xdg.configFile."gh/config.yml".source        = ../config/gh/config.yml;
  xdg.configFile."gh/hosts.yml".source         = ../config/gh/hosts.yml;

  xdg.configFile."claude-code/settings.json".source                    = ../config/claude-code/settings.json;
  xdg.configFile."claude-code/hooks/block-rm.sh"          = { source = ../config/claude-code/hooks/block-rm.sh;          executable = true; };
  xdg.configFile."claude-code/hooks/block-force-push.sh"  = { source = ../config/claude-code/hooks/block-force-push.sh;  executable = true; };
  xdg.configFile."claude-code/hooks/statusline.sh"        = { source = ../config/claude-code/hooks/statusline.sh;        executable = true; };

  # ===========================================================================
  # Zsh
  # ===========================================================================
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true; # fish-like inline suggestions from history
    syntaxHighlighting.enable = true; # highlight commands as you type
    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" ]; # up arrow
      searchDownKey = [ "^[[B" ]; # down arrow
    };
    plugins = [
      {
        name = "fzf-tab"; # replace completion menu with fzf
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-vi-mode"; # vi mode (must be last — overwrites bindings)
        src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
      }
    ];
    history = {
      path = "${config.home.homeDirectory}/.zsh_history";
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };
    shellAliases = {
      vim = "nvim";
      # eza
      ls = "eza --group-directories-first";
      ll = "eza -la --git --group-directories-first";
      lt = "eza --tree --git-ignore -I '.git|node_modules|.cache|__pycache__|.DS_Store|*.pyc|dist|.next' --group-directories-first";
      # bat
      cat = "bat --style=plain";
      # fd / dust / zoxide
      find = "fd";
      du = "dust";
      cd = "z";
      cdi = "zi"; # interactive zoxide
      # nav
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    initContent = ''
      eval "$(zoxide init zsh)"
      # Remove zsh default aliases not needed
      # Re-bind fzf keys after zsh-vi-mode initialises (zvm overwrites Ctrl+R/T, Alt+C)
      zvm_after_init_commands+=("source ${pkgs.fzf}/share/fzf/key-bindings.zsh")
    '';
  };

  # ===========================================================================
  # Git — delta as pager
  # ===========================================================================
  programs.git = {
    enable = true;
    settings = {
      user.name = "s0r4d3v";
      user.email = "s0r4d3v@gmail.com";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.navigate = true;
  };

  # ===========================================================================
  # Starship
  # ===========================================================================
  programs.fzf = {
    enable = true;
    enableZshIntegration = true; # Ctrl+R history, Ctrl+T file, Alt+C cd
    # zsh-vi-mode overwrites these; zvm_after_init_commands in initContent re-binds them
  };

  programs.starship.enable = true; # HM auto-adds `eval "$(starship init zsh)"`

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };

  # ===========================================================================
  # Tmux
  # ===========================================================================
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
  };

  # ===========================================================================
  # Secrets — sops-nix decrypts on every activation
  # Key must exist at ~/.config/sops/age/keys.txt before first run.
  # To add a secret: edit secrets/secrets.yaml (it is sops-encrypted in the repo).
  # Access path at runtime: config.sops.secrets.<name>.path
  # ===========================================================================
  # ===========================================================================
  # SSH — config managed by HM, keys decrypted by sops-nix
  # ===========================================================================
  # SSH config — managed as a sops secret so it stays encrypted in the public repo

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    secrets = {
      "ssh/id_ed25519" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        mode = "0600";
      };
      "ssh/id_ed25519_pub" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        mode = "0644";
      };
      "ssh/id_rsa" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa";
        mode = "0600";
      };
      "ssh/id_rsa_pub" = {
        path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
        mode = "0644";
      };
      "ssh/tanaka-site" = {
        path = "${config.home.homeDirectory}/.ssh/tanaka-site";
        mode = "0600";
      };
      "ssh/tanaka-site_pub" = {
        path = "${config.home.homeDirectory}/.ssh/tanaka-site.pub";
        mode = "0644";
      };
      "ssh/m02uku_pem" = {
        path = "${config.home.homeDirectory}/.ssh/m02uku.pem";
        mode = "0600";
      };
      "ssh/tanaka_ppk" = {
        path = "${config.home.homeDirectory}/.ssh/tanaka.ppk";
        mode = "0600";
      };
      "ssh/config" = {
        path = "${config.home.homeDirectory}/.ssh/config";
        mode = "0600";
      };
    };
  };

  # ===========================================================================
  # Claude Code — MCP servers
  # ===========================================================================
  home.file.".claude/settings.json".text = builtins.toJSON {
    vim = true; # vi keybindings in Claude Code prompt (Esc for normal mode)
    mcpServers = {
      # Nix knowledge: nixpkgs, nix-darwin, home-manager, and any other library
      context7 = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp"
        ];
      };
      # HTTP fetch — retrieve doc pages, APIs, or any URL
      fetch = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-fetch"
        ];
      };
      # Filesystem access rooted at home directory
      filesystem = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-filesystem"
          config.home.homeDirectory
        ];
      };
      # Structured multi-step reasoning
      sequential-thinking = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking"
        ];
      };
      # GitHub API — requires GITHUB_TOKEN in environment
      github = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-github"
        ];
        env = {
          GITHUB_TOKEN = "\${GITHUB_TOKEN}";
        };
      };
    };
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  home.stateVersion = "25.11";
}
