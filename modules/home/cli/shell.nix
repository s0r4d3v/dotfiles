{ ... }:
{
  flake.modules.homeManager.shell = { pkgs, ... }: {
    home.packages = with pkgs; [ nix-your-shell ];

      # Zsh
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        initContent = ''
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

          # Zellij
          ze = "zellij";
          zel = "zellij --layout";
          zedev = "zellij --layout dev";

          # HTTP
          http = "xh";
          https = "xh --https";
        };
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      # Starship prompt
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = ''
            $directory$git_branch$git_status$python$nodejs$nix_shell$cmd_duration
            $character
          '';
          character = {
            success_symbol = "[❯](bold #50fa7b)";  # Dracula green
            error_symbol = "[❯](bold #ff5555)";    # Dracula red
          };
          directory = {
            style = "bold #8be9fd";  # Dracula cyan
            truncation_length = 3;
            truncate_to_repo = true;
          };
          git_branch = {
            symbol = " ";
            style = "bold #bd93f9";  # Dracula purple
          };
          git_status = {
            style = "bold #f1fa8c";  # Dracula yellow
            format = "[$all_status$ahead_behind]($style) ";
          };
          python = {
            symbol = " ";
            style = "bold yellow";
            format = "[$symbol$version]($style) ";
          };
          nodejs = {
            symbol = " ";
            style = "bold green";
            format = "[$symbol$version]($style) ";
          };
          nix_shell = {
            symbol = " ";
            style = "bold blue";
            format = "[$symbol$state]($style) ";
          };
          cmd_duration = {
            min_time = 2000;
            style = "bold dimmed white";
            format = "[$duration]($style) ";
          };
        };
      };
    };
}
