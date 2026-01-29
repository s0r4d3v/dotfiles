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

          # Tmux
          tm = "tmux";
          dev = "tmux new-session \\; split-window -h -p 70 \\; split-window -h -p 43 \\; select-pane -t 0 \\; split-window -v -p 50 \\; select-pane -t 2 \\; split-window -v -p 25 \\; select-pane -t 4 \\; split-window -v -p 50 \\; select-pane -t 0 \\; send-keys 'yazi' C-m \\; select-pane -t 1 \\; send-keys 'opencode' C-m \\; select-pane -t 2 \\; send-keys 'nvim' C-m \\; select-pane -t 4 \\; send-keys 'lazygit' C-m \\; select-pane -t 5 \\; send-keys 'jj log' C-m \\; select-pane -t 2";

          # HTTP
          http = "xh";
          https = "xh --https";

          # Opencode
          oc = "opencode";

          # Direnv setup
          initdirenv = "nix flake init -t $DOTFILES_PATH#direnv && echo \"use flake\" > .envrc && git add flake.nix .envrc && direnv allow";

          # Nix update
          updateenv = "nix build \".#homeConfigurations.$(whoami).activationPackage\" && ./result/activate && source ~/.zshrc";
        };
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
