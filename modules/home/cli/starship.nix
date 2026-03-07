{ ... }:
{
  flake.modules.homeManager.starship =
    { pkgs, ... }:
    {
      # Catppuccin theme
      catppuccin.starship.enable = true;
      catppuccin.flavor = "macchiato";

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
           };
           character = {
             success_symbol = "[❯](peach)";
             error_symbol = "[❯](red)";
             vimcmd_symbol = "[❮](subtext1)";
           };
           directory = {
             truncation_length = 3;
             truncate_to_repo = true;
             format = "[📁 $path](lavender) ";
             style = "bold lavender";
           };
           git_branch = {
             symbol = "🌱";
             format = "[$symbol$branch](mauve) ";
             style = "bold mauve";
           };
           git_status = {
             format = "[$all_status$ahead_behind](yellow) ";
             style = "yellow";
           };
           git_commit = {
             commit_hash_length = 7;
             format = "[($hash)](maroon) ";
             style = "maroon";
           };
           git_state = {
             format = "[($state $progress_current/$progress_total)](peach) ";
             style = "peach";
           };
           git_metrics = {
             disabled = false;
             format = "[+$added](green)/[-$deleted](red) ";
             added_style = "green";
             deleted_style = "red";
           };
           python = {
             symbol = "🐍";
             format = "[$symbol$version](green) ";
             style = "green";
             detect_files = [
               "requirements.txt"
               "pyproject.toml"
               "Pipfile"
             ];
           };
           nodejs = {
             symbol = "📗";
             format = "[$symbol$version](green) ";
             style = "green";
             detect_files = [
               "package.json"
               "yarn.lock"
               "pnpm-lock.yaml"
             ];
           };
           nix_shell = {
             symbol = "❄️";
             format = "[$symbol$state](blue) ";
             style = "bold blue";
           };
           rust = {
             symbol = "🦀";
             format = "[$symbol$version](maroon) ";
             style = "maroon";
             detect_files = [ "Cargo.toml" ];
           };
           golang = {
             symbol = "🐹";
             format = "[$symbol$version](teal) ";
             style = "teal";
             detect_files = [ "go.mod" ];
           };
           cmd_duration = {
             min_time = 1000;
             format = "[⏱️ $duration](yellow) ";
             style = "yellow";
           };
           time = {
             disabled = false;
             format = "[$time](sky) ";
             style = "sky";
           };
           memory_usage = {
             disabled = false;
             format = "[$ram](sapphire) ";
             style = "sapphire";
           };
            battery = {
              full_symbol = "🔋";
              charging_symbol = "⚡";
              discharging_symbol = "💀";
              format = "[$symbol$percentage](green) ";
              display = [
                { threshold = 10; style = "bold red"; }
                { threshold = 30; style = "bold yellow"; }
                { threshold = 100; style = "green"; }
              ];
            };

        };
      };
    };
}
