{ ... }:
{
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
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

          # Search
          ripgrep
          fd

          # Process
          pik

          # Pdf
          ghostscript

          # image
          imagemagick

          # Nix tools
          comma # Run uninstalled commands: , cowsay hello

          # Clipboard
          lemonade # Remote clipboard over SSH

          # Misc
          pokemon-colorscripts
        ]
        ++ (
          if pkgs.stdenv.isDarwin then
            [
              zathura
              skimpdf
            ]
          else
            [
              # Linux: Zathura + xdotool
              zathura
              # xdotool
            ]
        );

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
            theme = "catppuccin-macchiato";
          };
        };

        claude-code = {
          enable = true;
          settings = {
            permissions = {
              allow = [
                "Bash(mkdir:*)"
                "Bash(touch:*)"
                "Bash(ls:*)"
                "Bash(cat:*)"
                "Bash(nix:*)"
                "Edit"
              ];
              ask = [
                "Bash(sudo:*)"
                "Bash(rm -rf:*)"
                "Read(.env:*)"
                "Read(**/*token*)"
                "Read(**/*key*)"
              ];
            };
            statusLine = {
              command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
              padding = 0;
              type = "command";
            };
            theme = "dark";
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
