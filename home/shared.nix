{ config, pkgs, ... }: {

  home.packages = with pkgs; [
    # Core
    git
    ripgrep   # rg  — fast grep
    fd        # fd  — fast find
    fzf
    jq
    zoxide    # z   — smart cd
    # Modern replacements
    eza       # ls/ll/tree
    bat       # cat
    delta     # git diff pager
    dust      # du
    btop      # top
    glow      # markdown preview
    tldr      # quick man pages
    # Dev
    gh           # GitHub CLI
    claude-code
    nodejs       # required for Mason to install npm-based LSP servers
    nixfmt  # Nix formatter (used by conform.nvim, not available via Mason)
    nixd    # Nix LSP (used by nvim; not available via Mason on all platforms)
    # Secrets
    age          # modern encryption (encrypt files, secrets)
    sops         # secrets manager (wraps age/gpg, works with Nix)
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
    autosuggestion.enable = true;       # fish-like inline suggestions from history
    syntaxHighlighting.enable = true;   # highlight commands as you type
    historySubstringSearch = {
      enable = true;
      searchUpKey   = [ "^[[A" ];       # up arrow
      searchDownKey = [ "^[[B" ];       # down arrow
    };
    plugins = [
      {
        name = "fzf-tab";               # replace completion menu with fzf
        src  = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
    ];
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
      # eza
      ls    = "eza --group-directories-first";
      ll    = "eza -la --git --group-directories-first";
      lt    = "eza --tree --git-ignore -I '.git|node_modules|.cache|__pycache__|.DS_Store|*.pyc|dist|.next' --group-directories-first";
      # bat
      cat   = "bat --style=plain";
      # fd / dust / zoxide
      find  = "fd";
      du    = "dust";
      cd    = "z";
      # nav
      ".."  = "cd ..";
      "..." = "cd ../..";
      cdi   = "zi";   # interactive zoxide
    };
    initContent = ''
      eval "$(zoxide init zsh)"
      # Remove zsh default aliases not needed
      unalias run-help 2>/dev/null || true
      unalias which-command 2>/dev/null || true
    '';
  };

  # ===========================================================================
  # Git — delta as pager
  # ===========================================================================
  programs.git = {
    enable = true;
    settings = {
      user.name           = "s0r4d3v";
      user.email          = "s0r4d3v@gmail.com";
      merge.conflictstyle = "diff3";
      diff.colorMoved     = "default";
    };
  };

  programs.delta = {
    enable                = true;
    enableGitIntegration  = true;
    options.navigate      = true;
  };

  # ===========================================================================
  # Starship
  # ===========================================================================
  programs.starship.enable = true;  # HM auto-adds `eval "$(starship init zsh)"`

  home.sessionVariables = {
    LANG              = "en_US.UTF-8";
    LC_ALL            = "en_US.UTF-8";
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
    age.keyFile     = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../secrets/secrets.yaml;
    secrets = {
      "ssh/id_ed25519"       = { path = "${config.home.homeDirectory}/.ssh/id_ed25519";       mode = "0600"; };
      "ssh/id_ed25519_pub"   = { path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";   mode = "0644"; };
      "ssh/id_rsa"           = { path = "${config.home.homeDirectory}/.ssh/id_rsa";           mode = "0600"; };
      "ssh/id_rsa_pub"       = { path = "${config.home.homeDirectory}/.ssh/id_rsa.pub";       mode = "0644"; };
      "ssh/tanaka-site"      = { path = "${config.home.homeDirectory}/.ssh/tanaka-site";      mode = "0600"; };
      "ssh/tanaka-site_pub"  = { path = "${config.home.homeDirectory}/.ssh/tanaka-site.pub";  mode = "0644"; };
      "ssh/m02uku_pem"       = { path = "${config.home.homeDirectory}/.ssh/m02uku.pem";       mode = "0600"; };
      "ssh/tanaka_ppk"       = { path = "${config.home.homeDirectory}/.ssh/tanaka.ppk";       mode = "0600"; };
      "ssh/config"           = { path = "${config.home.homeDirectory}/.ssh/config";           mode = "0600"; };
    };
  };

  # ===========================================================================
  # Claude Code — MCP servers
  # ===========================================================================
  home.file.".claude/settings.json".text = builtins.toJSON {
    mcpServers = {
      # Nix knowledge: nixpkgs, nix-darwin, home-manager, and any other library
      context7 = {
        command = "npx";
        args    = [ "-y" "@upstash/context7-mcp" ];
      };
      # HTTP fetch — retrieve doc pages, APIs, or any URL
      fetch = {
        command = "npx";
        args    = [ "-y" "@modelcontextprotocol/server-fetch" ];
      };
      # Filesystem access rooted at home directory
      filesystem = {
        command = "npx";
        args    = [ "-y" "@modelcontextprotocol/server-filesystem" config.home.homeDirectory ];
      };
      # Structured multi-step reasoning
      sequential-thinking = {
        command = "npx";
        args    = [ "-y" "@modelcontextprotocol/server-sequential-thinking" ];
      };
      # GitHub API — requires GITHUB_TOKEN in environment
      github = {
        command = "npx";
        args    = [ "-y" "@modelcontextprotocol/server-github" ];
        env     = { GITHUB_TOKEN = "\${GITHUB_TOKEN}"; };
      };
    };
  };

  home.stateVersion = "25.11";
}
