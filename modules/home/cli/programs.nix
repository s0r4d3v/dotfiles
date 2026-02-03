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
        autossh
        yarn # Package manager for Node.js

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

        codex = {
          enable = true;
        };

        yazi = {
          enable = true;
          settings = {
            manager = {
              show_hidden = false;
            };
          };
        };
      };
    };
}
