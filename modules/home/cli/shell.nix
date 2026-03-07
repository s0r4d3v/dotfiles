{ ... }:
{
  flake.modules.homeManager.shell =
    { lib, ... }:
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

          # Tmux
          tm = "tmux";

          # Zellij
          # zj = "zellij";

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

        initContent = lib.mkMerge [
          # Pre-compinit: Clean up fpath before completion initialization
          # This removes non-existent paths from fpath using zsh glob qualifiers
          # (N) = NULL_GLOB, returns empty if no match instead of error
          (lib.mkOrder 550 ''
            fpath=(''${^fpath}(N-/))
          '')

          # Post-compinit: General configuration
          ''
            # Override TERM_PROGRAM when inside tmux to enable Ghostty detection
            # tmux hardcodes TERM_PROGRAM=tmux in its source code (environ.c)
            # This override is required for image.nvim to detect Ghostty's Kitty graphics protocol support
            if [[ -n "$TMUX" ]] && [[ "$TERM_PROGRAM" == "tmux" ]]; then
              export TERM_PROGRAM=ghostty
            fi

            # Dev function with optional session name
            dev() {
              local session_name
              if [ $# -eq 0 ]; then
                session_name="$(basename "$PWD")"
              else
                session_name="$1"
              fi

              if tmux has-session -t "$session_name" 2>/dev/null; then
                tmux attach-session -t "$session_name"
              else
                tmux new-session -s "$session_name" nvim
              fi
            }
          ''
        ];
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
