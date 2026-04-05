{ pkgs, ... }:
{
  imports = [
    ./programs/neovim.nix
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/tmux.nix
    ./programs/starship.nix
    ./programs/tools.nix
    ./programs/secrets.nix
  ];

  home.packages = with pkgs; [
    # Core
    # git is managed via programs.git below
    ripgrep # rg           — fast grep
    fd # fd           — fast find
    # fzf is managed via programs.fzf below
    jq # JSON queries
    zoxide # z / zi       — smart cd

    # Modern CLI replacements
    eza # ls/ll/tree   ← ls
    bat # cat          ← cat
    delta # diff pager   ← diff (git)
    dust # du           ← du
    duf # df           ← df
    btop # htop         ← top
    procs # ps           ← ps
    sd # find/replace ← sed

    # File & navigation
    yazi # TUI file manager with image preview
    # broot installed via programs.broot below

    # Data processing
    yq-go # YAML/TOML/XML queries (mikefarah/yq) ← complements jq
    fx # interactive JSON explorer

    # Dev workflow
    just # task runner  ← make
    devenv # declarative dev environments (nix-based, works with direnv)
    mise # polyglot version manager (node/python/ruby/go/rust per project)
    lazygit # git TUI (used by tmux popup + nvim plugin)
    lazydocker # docker TUI   ← docker CLI
    ghq # remote repository manager
    (pkgs.buildGoModule {
      pname = "gwq";
      version = "0.0.17";
      src = pkgs.fetchFromGitHub {
        owner = "d-kuro";
        repo = "gwq";
        rev = "v0.0.17";
        hash = "sha256-A7CUzLhhjKRhiL88l8j3xCmKrRDk+KOhdbaow8FAlCo=";
      };
      vendorHash = "sha256-4K01Xf1EXl/NVX1loQ76l1bW8QglBAQdvlZSo7J4NPI=";
      doCheck = false;
    }) # git worktree manager (mirrors ghq conventions)
    difftastic # structure-aware diff (complements delta)
    hyperfine # statistical CLI benchmarking
    tokei # code line counter by language
    gitleaks # scan git history for accidentally committed secrets
    vhs # reproducible terminal recordings (.tape → GIF/video)

    # Network & HTTP
    xh # HTTP client  ← curl / httpie
    bandwhich # real-time network usage per process

    # Docs
    glow # markdown preview
    tldr # quick man pages

    # Dev tools
    claude-code
    opencode
    uv # Python package manager (provides uvx for MCP servers)
    nodejs # runtime for node-based LSP servers and tools
    tree-sitter # parser generator CLI (used by :TSInstall in nvim-treesitter)

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

    # Jupyter / notebook
    python3Packages.jupytext # ipynb ↔ plaintext conversion (used by jupytext.nvim)
    (pkgs.python3.withPackages (
      ps: with ps; [
        ipykernel # Jupyter kernel registration + runtime (includes jupyter-client)
      ]
    )) # provides python3 + jupyter on PATH for kernel management
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    SOPS_AGE_KEY_FILE = "$HOME/.config/sops/age/keys.txt";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.file.".hushlogin".text = "";

  home.stateVersion = "25.11";
}
