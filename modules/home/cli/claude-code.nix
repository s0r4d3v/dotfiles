{ ... }:
{
  flake.modules.homeManager.claude-code =
    { pkgs, lib, config, ... }:
    {
      programs = {
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
              PreToolUse = [
                {
                  matcher = "Bash";
                  hooks = [
                    {
                      type = "command";
                      command = toString (
                        pkgs.writeShellScript "block-rm" ''
                          input=$(cat)
                          cmd=$(echo "$input" | ${lib.getExe pkgs.jq} -r '.tool_input.command // ""')
                          if echo "$cmd" | grep -qE '^rm\s+-(rf?|r?f)\b'; then
                            echo "❌ Blocked: Use 'trash' instead of 'rm -rf' for safety" >&2
                            echo "💡 Install trash-cli: already in your packages.nix" >&2
                            exit 2  # Exit code 2 blocks the tool use
                          fi
                        ''
                      );
                    }
                  ];
                }
                {
                  matcher = "Bash";
                  hooks = [
                    {
                      type = "command";
                      command = toString (
                        pkgs.writeShellScript "block-force-push" ''
                          input=$(cat)
                          cmd=$(echo "$input" | ${lib.getExe pkgs.jq} -r '.tool_input.command // ""')
                          if echo "$cmd" | grep -qE 'git\s+push\s+.*(-f|--force).*(main|master)'; then
                            echo "❌ Blocked: Force push to main/master is prohibited" >&2
                            echo "💡 Create a feature branch instead" >&2
                            exit 2
                          fi
                        ''
                      );
                    }
                  ];
                }
              ];
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
            # Displays: [Progress Bar] Used% | $Cost | Model | 📁 Directory
            statusLine = {
              command = lib.getExe (
                pkgs.writeShellScriptBin "claude-statusline" ''
                  # Read the JSON session data from stdin
                  input=$(cat)

                  # Validate input - exit gracefully if empty or invalid JSON
                  if [ -z "$input" ] || ! echo "$input" | ${lib.getExe pkgs.jq} -e . >/dev/null 2>&1; then
                      echo "[No session data]"
                      exit 0
                  fi

                  # Extract relevant fields with fallbacks
                  MODEL=$(echo "$input" | ${lib.getExe pkgs.jq} -r '.model.display_name // "Unknown"')
                  MODEL=''${MODEL:-Unknown}
                  USED_PCT=$(echo "$input" | ${lib.getExe pkgs.jq} -r '.context_window.used_percentage // 0' | ${lib.getExe pkgs.gawk} '{printf "%.0f", $1}')
                  USED_PCT=''${USED_PCT:-0}
                  COST=$(echo "$input" | ${lib.getExe pkgs.jq} -r '.cost.total_cost_usd // 0')
                  COST=''${COST:-0}
                  DIR=$(basename "$(echo "$input" | ${lib.getExe pkgs.jq} -r '.workspace.current_dir // "."')")
                  DIR=''${DIR:-.}

                  # Create progress bar (10 characters)
                  if [ "$USED_PCT" -eq 0 ]; then
                      FILLED=0
                  else
                      FILLED=$((USED_PCT / 10))
                      if [ "$FILLED" -gt 10 ]; then
                          FILLED=10
                      fi
                  fi
                  EMPTY=$((10 - FILLED))

                  BAR=$(printf "%''${FILLED}s" | tr ' ' '▓')$(printf "%''${EMPTY}s" | tr ' ' '░')

                  # Color codes based on context usage
                  if [ "$USED_PCT" -lt 50 ]; then
                      COLOR="\033[32m"  # Green
                  elif [ "$USED_PCT" -lt 80 ]; then
                      COLOR="\033[33m"  # Yellow
                  else
                      COLOR="\033[31m"  # Red
                  fi

                  RESET="\033[0m"

                  # Format cost with 4 decimal places
                  COST_FORMATTED=$(printf '%.4f' "$COST")

                  # Output: [Progress Bar] Used% | $Cost | Model | 📁 Directory
                  echo -e "''${COLOR}[''${BAR}]''${RESET} ''${USED_PCT}% | \$''${COST_FORMATTED} | ''${MODEL} | 📁 ''${DIR}"
                ''
              );
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
            filesystem = {
              command = "npx";
              args = [
                "-y"
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
            memory = {
              command = "npx";
              args = [
                "-y"
                "@modelcontextprotocol/server-memory"
              ];
            };

            # Git integration (advanced version control)
            git = {
              command = "uvx";
              args = [ "mcp-server-git" ];
            };

            # ─────────────────────────────────────────────────────────────────────────
            # Knowledge & Search Servers
            # ─────────────────────────────────────────────────────────────────────────

            # Context7 - real-time library documentation lookup (no API key required)
            context7 = {
              command = "npx";
              args = [
                "-y"
                "@upstash/context7-mcp"
              ];
            };

            # Fetch - web content retrieval
            fetch = {
              command = "uvx";
              args = [ "mcp-server-fetch" ];
            };

            # ─────────────────────────────────────────────────────────────────────────
            # Reasoning & Analysis Servers
            # ─────────────────────────────────────────────────────────────────────────

            # Sequential Thinking - enhanced reasoning for complex problems
            sequential-thinking = {
              command = "npx";
              args = [
                "-y"
                "@modelcontextprotocol/server-sequential-thinking"
              ];
            };
          };

          # Custom skills configuration
          skills = { };
        };

        codex = {
          enable = true;
        };
      };
    };
}
