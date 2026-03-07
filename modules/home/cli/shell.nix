{ ... }:
{
  flake.modules.homeManager.shell =
    { lib, ... }:
    {

      # Fish
      programs.fish = {
        enable = true;

        loginShellInit = ''
          # Source Nix environment for login shells
          if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          end
        '';

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
          repo = "cd (ghq list --full-path | fzf)";

          # Mount
          mnt = "cd ~/mnt/(ls ~/mnt | fzf)";

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
          zj = "zellij";

          # HTTP
          http = "xh";
          https = "xh --https";

          # Opencode
          oc = "opencode";

          # Direnv setup
          initdirenv = "nix flake init -t $DOTFILES_PATH#direnv && echo \"use flake\" > .envrc && git add flake.nix .envrc && direnv allow";

          # Nix update
          pullenv = "cd (ghq root)/github.com/s0r4d3v/dotfiles && git pull && cd -";
          updateenv = "cd (ghq root)/github.com/s0r4d3v/dotfiles && nix build \".#homeConfigurations.\"(whoami)\".activationPackage\" && ./result/activate && cd -";
        };

        interactiveShellInit = ''
          # Override TERM_PROGRAM when inside tmux to enable Ghostty detection
          # tmux hardcodes TERM_PROGRAM=tmux in its source code (environ.c)
          # This override is required for image.nvim to detect Ghostty's Kitty graphics protocol support
          if set -q TMUX; and test "$TERM_PROGRAM" = "tmux"
            set -gx TERM_PROGRAM ghostty
          end

          # Disable fish greeting
          set -g fish_greeting
        '';

        functions = {
          dev = ''
            set -l session_name
            if test (count $argv) -eq 0
              set session_name (basename $PWD)
            else
              set session_name $argv[1]
            end

            if tmux has-session -t "$session_name" 2>/dev/null
              tmux attach-session -t "$session_name"
            else
              tmux new-session -s "$session_name" nvim
            end
          '';
        };
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };
    };
}
