{ ... }:
{
  flake.modules.homeManager.shell =
    { lib, ... }:
    {

      # Zsh
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        loginExtra = ''
          # Source Nix environment for login shells (mainly for Linux)
          if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
            source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          fi
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
          help = "tealdeer";
          tldr = "tealdeer";
          cd = "z";
          cdi = "zi";
          ps = "procs";

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

          # Devenv setup (preferred)
          initdevenv = "devenv init && git add devenv.nix devenv.lock .envrc && direnv allow";

          # Nix update
          pullenv = "cd $(ghq root)/github.com/s0r4d3v/dotfiles && git pull && cd -";
          updateenv = "cd $(ghq root)/github.com/s0r4d3v/dotfiles && nom build \".#homeConfigurations.$(whoami).activationPackage\" && ./result/activate && cd -";
        };

        initContent = ''
          # Zellij development session
          function dev() {
            local session_name
            if [[ $# -eq 0 ]]; then
              session_name=$(basename $PWD)
            else
              session_name=$1
            fi
            if zellij list-sessions 2>/dev/null | grep -q "^$session_name"; then
              zellij attach "$session_name"
            else
              zellij --session "$session_name" -- nvim
            fi
          }

          # Make directory and cd into it
          function mkcd() {
            mkdir -p "$1" && cd "$1"
          }

          # Extract various archive formats
          function extract() {
            if [[ $# -ne 1 ]]; then
              echo "Usage: extract <archive>"
              return 1
            fi
            if [[ ! -f "$1" ]]; then
              echo "Error: '$1' is not a valid file"
              return 1
            fi
            case "$1" in
              *.tar.bz2) tar xjf "$1" ;;
              *.tar.gz)  tar xzf "$1" ;;
              *.tar.xz)  tar xJf "$1" ;;
              *.bz2)     bunzip2 "$1" ;;
              *.rar)     unrar x "$1" ;;
              *.gz)      gunzip "$1" ;;
              *.tar)     tar xf "$1" ;;
              *.tbz2)    tar xjf "$1" ;;
              *.tgz)     tar xzf "$1" ;;
              *.zip)     unzip "$1" ;;
              *.Z)       uncompress "$1" ;;
              *.7z)      7z x "$1" ;;
              *) echo "Error: '$1' cannot be extracted via extract()" ; return 1 ;;
            esac
          }

          # Quick backup of a file
          function backup() {
            if [[ $# -ne 1 ]]; then
              echo "Usage: backup <file>"
              return 1
            fi
            cp "$1" "$1.bak.$(date +%Y%m%d_%H%M%S)"
          }

          # Find processes using a port
          function port() {
            if [[ $# -ne 1 ]]; then
              echo "Usage: port <port_number>"
              return 1
            fi
            lsof -i :"$1"
          }
        '';
      };

      # Zoxide (smart cd)
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };
}
