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
           };
           character = {
             success_symbol = "❯";
             error_symbol = "❯";
             vimcmd_symbol = "❮";
           };
           directory = {
             truncation_length = 3;
             truncate_to_repo = true;
             format = "📁 $path ";
           };
           git_branch = {
             symbol = "🌱";
             format = "$symbol$branch ";
           };
           git_status = {
             format = "$all_status$ahead_behind ";
           };
           git_commit = {
             commit_hash_length = 7;
             format = "( $hash ) ";
           };
           git_state = {
             format = "( $state $progress_current/$progress_total ) ";
           };
           git_metrics = {
             disabled = false;
             format = "+$added/-$deleted ";
           };
           python = {
             symbol = "🐍";
             format = "$symbol$version ";
             detect_files = [
               "requirements.txt"
               "pyproject.toml"
               "Pipfile"
             ];
           };
           nodejs = {
             symbol = "📗";
             format = "$symbol$version ";
             detect_files = [
               "package.json"
               "yarn.lock"
               "pnpm-lock.yaml"
             ];
           };
           nix_shell = {
             symbol = "❄️";
             format = "$symbol$state ";
           };
           rust = {
             symbol = "🦀";
             format = "$symbol$version ";
             detect_files = [ "Cargo.toml" ];
           };
           golang = {
             symbol = "🐹";
             format = "$symbol$version ";
             detect_files = [ "go.mod" ];
           };
           cmd_duration = {
             min_time = 1000;
             format = "⏱️ $duration ";
           };
           time = {
             disabled = false;
             format = "$time ";
           };
           memory_usage = {
             disabled = false;
             format = "$ram ";
           };
           battery = {
             full_symbol = "🔋";
             charging_symbol = "⚡";
             discharging_symbol = "💀";
             format = "$symbol$percentage ";
           };

        };
      };
    };
}
