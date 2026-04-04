{ config, pkgs, ... }:
{

  home.packages = with pkgs; [
    # Core
    git
    ripgrep # rg           — fast grep
    fd # fd           — fast find
    fzf
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
      doCheck = false; # tests require a writable home dir, unavailable in nix sandbox
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

  # ===========================================================================
  # Neovim — installed via Nix, config managed via xdg.configFile
  # ===========================================================================
  programs.neovim = {
    enable = true;
    defaultEditor = true; # sets $EDITOR and $VISUAL
    withPython3 = true; # Python3 provider for molten-nvim (Jupyter notebook runner)
    extraPython3Packages =
      ps: with ps; [
        pynvim # Neovim ← Python bridge
        jupyter-client # kernel protocol (molten-nvim)
        ipykernel # register/run Python kernels
        nbformat # import/export notebook outputs
        cairosvg # render SVG plot output
      ];
    extraPackages = [ pkgs.imagemagick ]; # image processing for image.nvim
  };

  xdg.configFile."nvim" = {
    source = ../config/.config/nvim;
    recursive = true;
  };

  # ===========================================================================
  # Broot — interactive directory navigator
  # Opens files with $EDITOR (nvim) instead of macOS `open`
  # ===========================================================================
  programs.broot = {
    enable = true;
    enableZshIntegration = true; # adds `br` shell function for cd-on-exit
    settings.verbs = [
      {
        key = "enter";
        execution = "$EDITOR {file}";
        apply_to = "file";
      }
    ];
  };

  # ===========================================================================
  # Direnv — auto-load .envrc / nix flake env per directory
  # ===========================================================================
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # fast persistent nix flake evaluation
  };

  # ===========================================================================
  # Yazi — TUI file manager
  # ===========================================================================
  xdg.configFile."yazi/yazi.toml".source = ../config/.config/yazi/yazi.toml;

  # ===========================================================================
  # Tool configs — all managed declaratively
  # ===========================================================================
  xdg.configFile."gwq/config.toml".text = ''
    [worktree]
    basedir = "${config.home.homeDirectory}/ghq"

    [naming]
    template = "{{.Host}}/{{.Owner}}/{{.Repository}}={{.Branch}}"
  '';

  # gh/config.yml is managed by programs.gh.settings below
  xdg.configFile."gh/hosts.yml".source = ../config/.config/gh/hosts.yml;
  xdg.configFile."opencode/opencode.json".text =
    builtins.replaceStrings [ "/Users/snagano" ] [ config.home.homeDirectory ]
      (builtins.readFile ../config/.config/opencode/opencode.json);
  xdg.configFile."opencode/skills" = {
    source = ../config/.config/opencode/skills;
    recursive = true;
  };

  home.file.".claude/settings.json".text =
    builtins.replaceStrings [ "@HOME@" ] [ config.home.homeDirectory ]
      (builtins.readFile ../config/.claude/settings.json);
  home.file.".claude/hooks/block-rm.sh" = {
    source = ../config/.claude/hooks/block-rm.sh;
    executable = true;
  };
  home.file.".claude/hooks/block-force-push.sh" = {
    source = ../config/.claude/hooks/block-force-push.sh;
    executable = true;
  };
  home.file.".claude/hooks/statusline.sh" = {
    source = ../config/.claude/hooks/statusline.sh;
    executable = true;
  };

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
      # modern replacements
      find = "fd";
      du = "dust";
      df = "duf";
      ps = "procs";
      cd = "z";
      cdi = "zi"; # interactive zoxide
      # nav
      ".." = "cd ..";
      "..." = "cd ../..";
    };
    initContent = ''
      eval "$(zoxide init zsh)"
      eval "$(mise activate zsh)"
      export GH_TOKEN=$(cat ${config.sops.secrets."gh/token".path})
      # Re-bind fzf keys after zsh-vi-mode initialises (zvm overwrites Ctrl+R/T, Alt+C)
      zvm_after_init_commands+=("source ${pkgs.fzf}/share/fzf/key-bindings.zsh")

      # Jump to a ghq repo or gwq worktree with fzf; renames tmux window on select
      repo() {
        local dir
        dir=$(
          {
            ghq list --full-path
            gwq list -g --json 2>/dev/null | jq -r '.[].path' 2>/dev/null
          } \
            | sort -u \
            | fzf --height 60% --reverse --prompt='repo/worktree > ' \
                  --preview='git -C {} log --oneline -10 2>/dev/null; echo; eza -1 --group-directories-first --color=always {} 2>/dev/null | head -20'
        )
        [[ -z "$dir" ]] && return
        z "$dir"
        [[ -n $TMUX ]] && tmux rename-window "$(basename "$dir")"
      }

      # Checkout a PR into a dedicated worktree
      # Usage: wpr <pr-number>
      wpr() {
        [[ -z "$1" ]] && echo "Usage: wpr <pr-number>" && return 1
        local branch
        branch=$(gh pr view "$1" --json headRefName -q .headRefName)
        gwq add -b "$branch"
        local wtdir
        wtdir=$(gwq list -g --json 2>/dev/null | jq -r --arg b "$branch" '.[] | select(.branch == $b) | .path')
        [[ -n "$wtdir" ]] && z "$wtdir"
        [[ -n $TMUX ]] && tmux rename-window "$branch"
      }

      # Create a new Jupyter notebook and open in nvim
      nb() {
        local name lang display kernel

        printf "Notebook name: "
        read -r name
        [[ -z "$name" ]] && echo "Aborted." && return 1
        name="''${name%.ipynb}"

        if [[ -f "''${name}.ipynb" ]]; then
          echo "''${name}.ipynb already exists, opening..."
          nvim "''${name}.ipynb"
          return
        fi

        printf "Kernel language (python): "
        read -r lang
        lang="''${lang:-python}"

        case "$lang" in
          python)  display="Python 3"; kernel="python3" ;;
          r)       display="R";        kernel="ir" ;;
          julia)   display="Julia";    kernel="julia-1" ;;
          *)       display="$lang";    kernel="$lang" ;;
        esac

        cat > "''${name}.ipynb" << NBEOF
      {
       "cells": [
        {
         "cell_type": "code",
         "execution_count": null,
         "metadata": {},
         "outputs": [],
         "source": []
        }
       ],
       "metadata": {
        "kernelspec": {
         "display_name": "$display",
         "language": "$lang",
         "name": "$kernel"
        },
        "language_info": {
         "name": "$lang"
        }
       },
       "nbformat": 4,
       "nbformat_minor": 5
      }
      NBEOF
        echo "Created ''${name}.ipynb ($display kernel)"
        nvim "''${name}.ipynb"
      }
    '';
  };

  # ===========================================================================
  # Git — delta as pager
  # ===========================================================================
  programs.git = {
    enable = true;
    settings = {
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
    includes = [ { path = config.sops.secrets."git/identity".path; } ];
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

  programs.starship.enable = true; # config: config/.config/starship.toml
  xdg.configFile."starship.toml".source = ../config/.config/starship.toml;

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
    extraConfig = builtins.readFile ../config/.config/tmux/tmux.conf;
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
      "gh/token" = { };
      "git/identity" = {
        path = "${config.home.homeDirectory}/.config/git/identity";
        mode = "0600";
      };
    };
  };

  home.file.".hushlogin".text = "";

  home.sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-notify ];
  };

  home.stateVersion = "25.11";
}
