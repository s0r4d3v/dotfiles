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
          help = "tealdeer";
          tldr = "tealdeer";
          cd = "z";
          cdi = "zi";
          ps = "procs";

          # Tmux (disabled but aliased for reference)
          # tm = "tmux";

          # Zellij
          zj = "zellij";

          # HTTP
          http = "xh";
          https = "xh --https";

          # Opencode
          oc = "opencode";

          # Nix build with nom (nix-output-monitor)
          nb = "nom build";
          ns = "nom shell";
          nd = "nom develop";

          # Docker
          lzd = "lazydocker";

          # Kubernetes
          k = "kubectl";

          # Direnv setup
          initdirenv = "nix flake init -t $DOTFILES_PATH#direnv && echo \"use flake\" > .envrc && git add flake.nix .envrc && direnv allow";

          # Devenv setup
          initdevenv = "devenv init && git add devenv.nix devenv.lock .envrc && direnv allow";

          # Nix update
          pullenv = "cd (ghq root)/github.com/s0r4d3v/dotfiles && git pull && cd -";
          updateenv = "cd (ghq root)/github.com/s0r4d3v/dotfiles && nom build \".#homeConfigurations.\"(whoami)\".activationPackage\" && ./result/activate && cd -";
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
          # Zellij development session (replacing tmux)
          dev = ''
            set -l session_name
            if test (count $argv) -eq 0
              set session_name (basename $PWD)
            else
              set session_name $argv[1]
            end

            # Use zellij instead of tmux
            if zellij list-sessions 2>/dev/null | grep -q "^$session_name"
              zellij attach "$session_name"
            else
              zellij --session "$session_name" -- nvim
            end
          '';

          # Make directory and cd into it
          mkcd = ''
            mkdir -p $argv[1]
            and cd $argv[1]
          '';

          # Extract various archive formats
          extract = ''
            if test (count $argv) -ne 1
              echo "Usage: extract <archive>"
              return 1
            end

            if not test -f $argv[1]
              echo "Error: '$argv[1]' is not a valid file"
              return 1
            end

            switch $argv[1]
              case '*.tar.bz2'
                tar xjf $argv[1]
              case '*.tar.gz'
                tar xzf $argv[1]
              case '*.tar.xz'
                tar xJf $argv[1]
              case '*.bz2'
                bunzip2 $argv[1]
              case '*.rar'
                unrar x $argv[1]
              case '*.gz'
                gunzip $argv[1]
              case '*.tar'
                tar xf $argv[1]
              case '*.tbz2'
                tar xjf $argv[1]
              case '*.tgz'
                tar xzf $argv[1]
              case '*.zip'
                unzip $argv[1]
              case '*.Z'
                uncompress $argv[1]
              case '*.7z'
                7z x $argv[1]
              case '*'
                echo "Error: '$argv[1]' cannot be extracted via extract()"
                return 1
            end
          '';

          # Quick backup of a file
          backup = ''
            if test (count $argv) -ne 1
              echo "Usage: backup <file>"
              return 1
            end
            cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
          '';

          # Find processes using a port
          port = ''
            if test (count $argv) -ne 1
              echo "Usage: port <port_number>"
              return 1
            end
            lsof -i :$argv[1]
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
