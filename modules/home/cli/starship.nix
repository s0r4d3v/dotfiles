{ ... }:
{
  flake.modules.homeManager.starship =
    { pkgs, ... }:
    {
      # Starship prompt
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          format = ''
            $os$directory$git_branch$git_commit$git_state$git_status$git_metrics$nix_shell$python$nodejs$rust$golang$cmd_duration$time$memory$battery
            $character
          '';
          os = {
            disabled = false;
            style = "bold #f8f8f2";
          };
          character = {
            success_symbol = "[❯](bold #50fa7b)"; # Dracula green
            error_symbol = "[❯](bold #ff5555)"; # Dracula red
            vimcmd_symbol = "[❮](bold #bd93f9)"; # vim mode
          };
          directory = {
            style = "bold #8be9fd"; # Dracula cyan
            truncation_length = 3;
            truncate_to_repo = true;
            format = "[📁 $path]($style) ";
          };
          git_branch = {
            symbol = "🌱";
            style = "bold #bd93f9"; # Dracula purple
            format = "[$symbol$branch]($style) ";
          };
          git_status = {
            style = "bold #f1fa8c"; # Dracula yellow
            format = "[$all_status$ahead_behind]($style) ";
          };
          git_commit = {
            commit_hash_length = 7;
            style = "bold #6272a4"; # Dracula comment
            format = "[\\($hash\\)]($style) ";
          };
          git_state = {
            style = "bold #ffb86c"; # Dracula orange
            format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
          };
          git_metrics = {
            disabled = false;
            format = "[+$added]($added_style)/[-$deleted]($deleted_style) ";
            added_style = "bold #50fa7b";
            deleted_style = "bold #ff5555";
          };
          python = {
            symbol = "🐍";
            style = "bold #50fa7b";
            format = "[$symbol$version]($style) ";
            detect_files = [
              "requirements.txt"
              "pyproject.toml"
              "Pipfile"
            ];
          };
          nodejs = {
            symbol = "📗";
            style = "bold #50fa7b";
            format = "[$symbol$version]($style) ";
            detect_files = [
              "package.json"
              "yarn.lock"
              "pnpm-lock.yaml"
            ];
          };
          nix_shell = {
            symbol = "❄️";
            style = "bold #8be9fd";
            format = "[$symbol$state]($style) ";
          };
          rust = {
            symbol = "🦀";
            style = "bold #ff5555";
            format = "[$symbol$version]($style) ";
            detect_files = [ "Cargo.toml" ];
          };
          golang = {
            symbol = "🐹";
            style = "bold #8be9fd";
            format = "[$symbol$version]($style) ";
            detect_files = [ "go.mod" ];
          };
          cmd_duration = {
            min_time = 1000;
            style = "bold #ffb86c"; # Dracula orange
            format = "[⏱️ $duration]($style) ";
          };
          time = {
            disabled = false;
            format = "[$time]($style) ";
            style = "bold #6272a4"; # Dracula comment
          };
          memory_usage = {
            disabled = false;
            format = "[$ram]($style) ";
            style = "bold #ffb86c"; # Dracula orange
          };
          battery = {
            full_symbol = "🔋";
            charging_symbol = "⚡";
            discharging_symbol = "💀";
            format = "[$symbol$percentage](bold #50fa7b) ";
          };
        };
      };
    };
}
