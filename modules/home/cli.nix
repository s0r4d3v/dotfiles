{ ... }:
{
  flake.modules.homeManager.programs =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # Modern ls/cat
        eza
        bat

        # JSON/HTTP
        jq
        curl
        wget
        xh # Modern curl for APIs

        # System monitoring
        btop # Modern htop
        dust # Modern du
        duf # Modern df

        # Productivity
        tldr # Simplified man pages
        trash-cli # Safe rm
        entr # Run command on file change
        sshfs # Mount remote directories over SSH

        # Git
        gh
        ghq
        lazygit

        # Containers
        colima # Docker on macOS/Linux without Docker Desktop
        docker # Docker CLI (colima provides the daemon)

        # Search
        ripgrep
        fd

        # Nix tools
        comma # Run uninstalled commands: , cowsay hello
      ];

      programs = {

        git = {
          enable = true;
          settings = {
            user = {
              name = "s0r4d3v";
              email = "s0r4d3v@gmail.com";
            };
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            pull.rebase = true;
          };
        };

        jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "s0r4d3v";
              email = "s0r4d3v@gmail.com";
            };
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
        };

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        fzf = {
          enable = true;
          enableZshIntegration = true;
        };

        # nix-index: provides nix-locate command
        nix-index = {
          enable = true;
          enableZshIntegration = true;
        };

        opencode = {
          enable = true;
          settings = {
            theme = "dracula";
          };
        };
      };
    };

  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ nix-your-shell ];

      # Zsh
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = ''
          # Fix Homebrew completions
          if command -v brew >/dev/null 2>&1; then
            FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
          fi

          nd() {
            nix develop "$DOTFILES_PATH#$1"
          }
          if command -v nix-your-shell > /dev/null; then
            nix-your-shell zsh | source /dev/stdin
          fi
        '';

        history = {
          size = 10000;
          save = 10000;
          ignoreDups = true;
          ignoreSpace = true;
          share = true;
        };

        shellAliases = {
          # File listing (eza)
          ls = "eza";
          ll = "eza -la";
          la = "eza -a";
          lt = "eza --tree";
          l = "eza -l";

          # File viewing
          cat = "bat";
          less = "bat --paging=always";

          # Git
          g = "git";
          gs = "git status";
          gd = "git diff";
          gl = "git log --oneline -20";
          gp = "git push";
          ga = "git add";
          gc = "git commit";
          gco = "git checkout";
          gb = "git branch";
          lg = "lazygit";

          # Editor
          v = "nvim";
          vi = "nvim";
          vim = "nvim";

          # Navigation
          "." = "cd ..";
          ".." = "cd ../..";
          "..." = "cd ../../..";

          # Safety
          rm = "trash-put";
          cp = "cp -i";
          mv = "mv -i";

          # System
          top = "btop";
          du = "dust";
          df = "duf";
          help = "tldr";

          # Tmux
          tm = "tmux";

          # HTTP
          http = "xh";
          https = "xh --https";

          # Opencode
          oc = "opencode";
        };
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

  flake.modules.homeManager.starship =
    { pkgs, ... }:
    {
      # Starship prompt
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = ''
            [🚀](bold #50fa7b)$directory$git_branch$git_commit$git_state$git_status$git_metrics$nix_shell$python$nodejs$rust$golang$cmd_duration$time$memory$battery
            $character
          '';
          character = {
            success_symbol = "[❯](bold #50fa7b)"; # Dracula green
            error_symbol = "[❯](bold #ff5555)"; # Dracula red
            vimcmd_symbol = "[❮](bold #bd93f9)"; # vim mode
          };
          directory = {
            style = "bold #8be9fd"; # Dracula cyan
            truncation_length = 3;
            truncate_to_repo = true;
            format = "[📁 $path]($style) ";
          };
          git_branch = {
            symbol = "🌱";
            style = "bold #bd93f9"; # Dracula purple
            format = "[$symbol$branch]($style) ";
          };
          git_status = {
            style = "bold #f1fa8c"; # Dracula yellow
            format = "[$all_status$ahead_behind]($style) ";
          };
          git_commit = {
            commit_hash_length = 7;
            style = "bold #6272a4"; # Dracula comment
            format = "[\\($hash\\)]($style) ";
          };
          git_state = {
            style = "bold #ffb86c"; # Dracula orange
            format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
          };
          git_metrics = {
            disabled = false;
            format = "[+$added]($added_style)/[-$deleted]($deleted_style) ";
            added_style = "bold #50fa7b";
            deleted_style = "bold #ff5555";
          };
          python = {
            symbol = "🐍";
            style = "bold #50fa7b";
            format = "[$symbol$version]($style) ";
            detect_files = [
              "requirements.txt"
              "pyproject.toml"
              "Pipfile"
            ];
          };
          nodejs = {
            symbol = "📗";
            style = "bold #50fa7b";
            format = "[$symbol$version]($style) ";
            detect_files = [
              "package.json"
              "yarn.lock"
              "pnpm-lock.yaml"
            ];
          };
          nix_shell = {
            symbol = "❄️";
            style = "bold #8be9fd";
            format = "[$symbol$state]($style) ";
          };
          rust = {
            symbol = "🦀";
            style = "bold #ff5555";
            format = "[$symbol$version]($style) ";
            detect_files = [ "Cargo.toml" ];
          };
          golang = {
            symbol = "🐹";
            style = "bold #8be9fd";
            format = "[$symbol$version]($style) ";
            detect_files = [ "go.mod" ];
          };
          cmd_duration = {
            min_time = 1000;
            style = "bold #ffb86c"; # Dracula orange
            format = "[⏱️ $duration]($style) ";
          };
          time = {
            disabled = false;
            format = "[$time]($style) ";
            style = "bold #6272a4"; # Dracula comment
          };
          memory_usage = {
            disabled = false;
            format = "[$ram]($style) ";
            style = "bold #ffb86c"; # Dracula orange
          };
          battery = {
            full_symbol = "🔋";
            charging_symbol = "⚡";
            discharging_symbol = "💀";
            format = "[$symbol$percentage](bold #50fa7b) ";
          };
        };
      };
    };
}
