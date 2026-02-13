{ ... }:
{
  flake.modules.homeManager.shell =
    { pkgs, ... }:
    {

      # Zsh
      programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

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

          # Ghq
          repo = "cd $(ghq list --full-path | fzf)";

          # Mount
          mnt = "cd ~/mnt/$(ls ~/mnt | fzf)";

          # Editor
          v = "nvim";
          vi = "nvim";
          vim = "nvim";

          # Navigation
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";

          # Safety
          rm = "trash-put";
          cp = "cp -i";
          mv = "mv -i";

          # System
          top = "btop";
          du = "dust";
          df = "duf";
          help = "tldr";
          cd = "z";
          cdi = "zi";

          # HTTP
          http = "xh";
          https = "xh --https";

          # Opencode
          oc = "opencode";

          # Direnv setup
          initdirenv = "nix flake init -t $DOTFILES_PATH#direnv && echo \"use flake\" > .envrc && git add flake.nix .envrc && direnv allow";

          # Nix update
          pullenv = "cd $(ghq root)/github.com/s0r4d3v/dotfiles && git pull && cd -";
          updateenv = "cd $(ghq root)/github.com/s0r4d3v/dotfiles && nix build \".#homeConfigurations.$(whoami).activationPackage\" && ./result/activate && source ~/.zshrc && cd -";
        };
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
