{ ... }:
{
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
    };
}
