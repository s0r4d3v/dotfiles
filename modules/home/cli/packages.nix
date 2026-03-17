{ ... }:
{
  flake.modules.homeManager.packages =
    { pkgs, lib, ... }:
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
        procs # Modern ps with tree view and colors
        bottom # Alternative to btop (Rust-based)

        # Productivity
        tealdeer # Faster tldr implementation (Rust)
        trash-cli # Safe rm
        entr # Run command on file change
        sshfs # Mount remote directories over SSH
        autossh
        yarn # Package manager for Node.js

        # Search
        ripgrep
        ripgrep-all # ripgrep for PDFs, DOCX, ZIPs
        fd

        # Process
        pik

        # Pdf
        ghostscript

        # image
        imagemagick

        # Nix tools
        comma # Run uninstalled commands: , cowsay hello
        nix-output-monitor # Better nix build output (nom)
        devenv # Fast, declarative dev environments

        # Clipboard
        lemonade # Remote clipboard over SSH

        # Data processing
        yq-go # YAML/JSON/XML/CSV processor (like jq for YAML)
        jless # Interactive JSON viewer
        gron # Make JSON greppable
        fx # Interactive JSON viewer and processor

        # Benchmarking
        hyperfine # Command-line benchmarking tool

        # Network tools
        bandwhich # Network bandwidth monitor
        dog # DNS client (dig alternative)
        gping # Graphical ping
        trippy # Modern traceroute

        # Text processing
        sd # Modern sed alternative

        # File management
        broot # Directory navigation

        # Git tools
        git-cliff # Changelog generator
        onefetch # Git repository info display

        # Development tools
        just # Modern task runner (make alternative)
        tokei # Code statistics
        uv # Fast Python package installer (required for MCP servers)

        # Container/Cloud tools
        lazydocker # Docker TUI
        kubectl # Kubernetes CLI
        k9s # Kubernetes TUI
        kubectx # Kubernetes context switcher
        kubernetes-helm # Kubernetes package manager
        helmfile # Declarative helm chart management
        kustomize # Kubernetes config overlays
        stern # Multi-pod log tailing
        awscli2 # AWS CLI
        google-cloud-sdk # GCP CLI
        terraform # Infrastructure as Code
        terragrunt # Terraform wrapper

        # Diff
        difftastic # Structural/language-aware diffs

        # HTTP/API
        posting # TUI HTTP client

        # Terminal utilities
        glow # Markdown viewer in terminal
        viddy # Modern watch replacement
        navi # Interactive cheatsheet tool (fzf-based)
        mprocs # Run multiple processes in a TUI

        # Security/Crypto
        age # Modern simple encryption

        # Recording
        asciinema # Terminal session recording
        vhs # Record terminal to GIF

        # Runtime management
        mise # Polyglot runtime version manager

        # Misc
        pokemon-colorscripts

        # PDF viewer
        zathura
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
