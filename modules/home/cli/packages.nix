{ ... }:
{
  flake.modules.homeManager.packages =
    { pkgs, lib, config, ... }:
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

          # Container/Cloud tools
          lazydocker # Docker TUI
          kubectl # Kubernetes CLI
          k9s # Kubernetes TUI
          kubectx # Kubernetes context switcher
          awscli2 # AWS CLI
          google-cloud-sdk # GCP CLI
          terraform # Infrastructure as Code
          terragrunt # Terraform wrapper

          # Misc
          pokemon-colorscripts

          # PDF viewer
          zathura
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [ skimpdf ];

      programs = {
        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        # nix-index: provides nix-locate command
        nix-index = {
          enable = true;
          enableFishIntegration = true;
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
            # ═══════════════════════════════════════════════════════════════════════════
            # Permissions Configuration (Security Best Practices)
            # ═══════════════════════════════════════════════════════════════════════════
            #
            # Following Trail of Bits recommendations:
            # - Allow safe, read-only operations by default
            # - Ask for potentially destructive operations
            # - Deny access to sensitive credentials and system files
            #
            permissions = {
              # Safe operations - auto-allowed without prompts
              allow = [
                "Bash(mkdir:*)"
                "Bash(touch:*)"
                "Bash(ls:*)"
                "Bash(cat:*)"
                "Bash(nix:*)"
                "Bash(git status:*)"
                "Bash(git diff:*)"
                "Bash(git log:*)"
                "Edit"
                "Read"
                "Glob"
                "Grep"
              ];

              # Potentially destructive - require explicit approval
              ask = [
                "Bash(sudo:*)"
                "Bash(rm -rf:*)"
                "Bash(rm -r:*)"
                "Bash(git push:*)"
                "Bash(git push --force:*)"
                "Bash(npm publish:*)"
                "Write(**/*.nix)" # Nix files are critical
                "Read(.env:*)"
                "Read(**/*token*)"
                "Read(**/*key*)"
                "Read(**/*secret*)"
                "Read(**/*password*)"
              ];

              # Explicitly denied - security-critical paths (Trail of Bits best practice)
              deny = [
                # SSH and GPG keys
                "Read(${config.home.homeDirectory}/.ssh/**)"
                "Write(${config.home.homeDirectory}/.ssh/**)"
                "Read(${config.home.homeDirectory}/.gnupg/**)"
                "Write(${config.home.homeDirectory}/.gnupg/**)"

                # Cloud provider credentials
                "Read(${config.home.homeDirectory}/.aws/credentials)"
                "Read(${config.home.homeDirectory}/.azure/**)"
                "Read(${config.home.homeDirectory}/.kube/config)"
                "Read(${config.home.homeDirectory}/.config/gcloud/**)"

                # Package manager tokens
                "Read(${config.home.homeDirectory}/.npmrc)"
                "Read(${config.home.homeDirectory}/.pypirc)"
                "Read(${config.home.homeDirectory}/.gem/credentials)"

                # Shell configs (prevent backdoor injection)
                "Write(${config.home.homeDirectory}/.bashrc)"
                "Write(${config.home.homeDirectory}/.zshrc)"
                "Write(${config.home.homeDirectory}/.config/fish/config.fish)"

                # Git credentials
                "Read(${config.home.homeDirectory}/.git-credentials)"
                "Read(${config.home.homeDirectory}/.netrc)"
              ];
            };

            # ═══════════════════════════════════════════════════════════════════════════
            # Hooks - Automated Safety Guards
            # ═══════════════════════════════════════════════════════════════════════════
            #
            # Hooks run automatically at specific lifecycle points.
            # Unlike permissions (which prompt), hooks enforce rules deterministically.
            #
            hooks = {
              # Block dangerous rm commands, suggest trash-cli instead
              preToolUse = [
                {
                  name = "block-dangerous-rm";
                  command = toString (
                    pkgs.writeShellScript "block-rm" ''
                      if echo "$TOOL_USE" | grep -q '"name":"Bash"' && \
                         echo "$TOOL_USE" | grep -qE '"command":"rm -rf|rm -r"'; then
                        echo "❌ Blocked: Use 'trash' instead of 'rm -rf' for safety"
                        echo "💡 Install trash-cli: already in your packages.nix"
                        exit 2  # Exit code 2 blocks the tool use
                      fi
                    ''
                  );
                }
                {
                  name = "block-force-push-main";
                  command = toString (
                    pkgs.writeShellScript "block-force-push" ''
                      if echo "$TOOL_USE" | grep -q '"name":"Bash"' && \
                         echo "$TOOL_USE" | grep -qE 'git push.*(--force|-f).*main|git push.*(--force|-f).*master'; then
                        echo "❌ Blocked: Force push to main/master is prohibited"
                        echo "💡 Create a feature branch instead"
                        exit 2
                      fi
                    ''
                  );
                }
              ];

              # Run code quality checks after edits (optional)
              # postToolUse = [
              #   {
              #     name = "format-on-edit";
              #     command = toString (
              #       pkgs.writeShellScript "format-check" ''
              #         if echo "$TOOL_USE" | grep -q '"name":"Edit"'; then
              #           echo "🔍 Running formatter..."
              #           treefmt || echo "⚠️  Formatting issues detected"
              #         fi
              #       ''
              #     );
              #   }
              # ];
            };

            # ═══════════════════════════════════════════════════════════════════════════
            # Environment Variables - Performance Optimization
            # ═══════════════════════════════════════════════════════════════════════════
            env = {
              # MCP server startup timeout (default: 30s)
              MCP_TIMEOUT = "60000"; # 60 seconds for slow networks

              # Maximum tokens for MCP tool output (default: 25000)
              MAX_MCP_OUTPUT_TOKENS = "50000";

              # Tool search behavior: auto (intelligent), true (always), false (never)
              ENABLE_TOOL_SEARCH = "auto";
            };

            # Status line configuration
            statusLine = {
              command = "input=$(cat); echo \"[$(echo \"$input\" | jq -r '.model.display_name')] 📁 $(basename \"$(echo \"$input\" | jq -r '.workspace.current_dir')\")\"";
              padding = 0;
              type = "command";
            };

            # Theme
            theme = "dark";
          };

          # ═══════════════════════════════════════════════════════════════════════════
          # Prerequisites / Context for Claude Code
          # ═══════════════════════════════════════════════════════════════════════════
          #
          # This user manages their entire dotfiles with Nix/Home Manager.
          # Key facts about this environment:
          #
          # 1. Nix Ecosystem:
          #    - All packages managed declaratively via flake.nix
          #    - Home Manager for user environment configuration
          #    - flake-parts + import-tree for modular organization
          #    - Catppuccin Macchiato theme across all tools
          #
          # 2. Development Workflow:
          #    - devenv for project-specific environments (<100ms startup)
          #    - direnv for automatic environment activation
          #    - treefmt-nix for unified code formatting
          #    - sops-nix for encrypted secrets (when available)
          #
          # 3. Dotfiles Location:
          #    - Repository: ~/ghq/github.com/s0r4d3v/dotfiles
          #    - Update: `pullenv && updateenv` (pull + rebuild)
          #    - Build: `nix build ".#homeConfigurations.$(whoami).activationPackage"`
          #
          # 4. Best Practices:
          #    - Use `nix search nixpkgs <package>` to find packages
          #    - Add packages to modules/home/cli/packages.nix
          #    - Create new modules in modules/home/ (auto-imported)
          #    - Always validate with `nix flake check`
          #
          # ═══════════════════════════════════════════════════════════════════════════

          # ═══════════════════════════════════════════════════════════════════════════
          # MCP (Model Context Protocol) Servers - Extended AI Capabilities
          # ═══════════════════════════════════════════════════════════════════════════
          #
          # All MCP servers are enabled. Claude Code intelligently selects the
          # appropriate server based on the task context.
          #
          mcpServers = {
            # ─────────────────────────────────────────────────────────────────────────
            # Core Servers - Essential Development Tools
            # ─────────────────────────────────────────────────────────────────────────

            # Nix ecosystem MCP server (essential for Nix users)
            # Provides real-time access to:
            # - 130,000+ NixOS packages with version info
            # - 23,000+ NixOS/Home Manager/nix-darwin options
            # - Nixvim configurations and FlakeHub resources
            mcp-nixos = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "mcp-nixos"
              ];
            };

            # Filesystem access with restricted paths (security-hardened)
            # Only allows access to safe development directories
            filesystem = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-filesystem"
              ];
              env = {
                ALLOWED_DIRECTORIES = lib.concatStringsSep ":" [
                  "${config.home.homeDirectory}/ghq"
                  "${config.home.homeDirectory}/Projects"
                  "${config.home.homeDirectory}/Documents"
                  "${config.home.homeDirectory}/Downloads"
                ];
              };
            };

            # Memory server - persistent context across sessions
            # Stores conversation context, learned preferences, and project knowledge
            memory = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-memory"
              ];
            };

            # Git integration (advanced version control)
            # Provides semantic git operations beyond basic commands
            git = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-git"
              ];
            };

            # ─────────────────────────────────────────────────────────────────────────
            # Integration Servers - External Services
            # ─────────────────────────────────────────────────────────────────────────

            # GitHub integration (requires personal access token)
            # Enables PR creation, issue management, code review
            # Token should be set via environment variable GITHUB_PERSONAL_ACCESS_TOKEN
            # or will attempt to use gh CLI configuration if available
            github = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-github"
              ];
              # env.GITHUB_PERSONAL_ACCESS_TOKEN can be set in shell or via sops-nix
            };

            # ─────────────────────────────────────────────────────────────────────────
            # Knowledge & Search Servers
            # ─────────────────────────────────────────────────────────────────────────

            # Brave Search - web and code search
            # Note: Requires BRAVE_API_KEY environment variable
            # Get API key from: https://brave.com/search/api/
            brave-search = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-brave-search"
              ];
              # env.BRAVE_API_KEY will be read from environment if set
            };

            # Fetch - web content retrieval
            # Safely fetches and processes web pages
            fetch = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-fetch"
              ];
            };

            # ─────────────────────────────────────────────────────────────────────────
            # Reasoning & Analysis Servers
            # ─────────────────────────────────────────────────────────────────────────

            # Sequential Thinking - enhanced reasoning for complex problems
            # Enables step-by-step problem decomposition
            sequential-thinking = {
              command = lib.getExe pkgs.uv;
              args = [
                "tool"
                "run"
                "@modelcontextprotocol/server-sequential-thinking"
              ];
            };

            # ─────────────────────────────────────────────────────────────────────────
            # Additional Useful Servers (uncomment to enable)
            # ─────────────────────────────────────────────────────────────────────────

            # Slack integration (requires bot token)
            # slack = {
            #   command = lib.getExe pkgs.uv;
            #   args = [ "tool" "run" "@modelcontextprotocol/server-slack" ];
            #   env.SLACK_BOT_TOKEN = "your-token-here";
            # };

            # Google Drive integration
            # gdrive = {
            #   command = lib.getExe pkgs.uv;
            #   args = [ "tool" "run" "@modelcontextprotocol/server-gdrive" ];
            # };

            # PostgreSQL database access
            # postgres = {
            #   command = lib.getExe pkgs.uv;
            #   args = [ "tool" "run" "@modelcontextprotocol/server-postgres" ];
            #   env.DATABASE_URL = "postgresql://localhost/mydb";
            # };
          };

          # Custom skills configuration
          # Add domain-specific skills here when needed
          # Skills extend Claude Code's capabilities with specialized knowledge
          skills = { };
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
