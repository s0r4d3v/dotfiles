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
            $os$username$hostname$shlvl$directory$git_branch$git_commit$git_state$git_status$git_metrics$nix_shell$python$nodejs$rust$golang$java$ruby$php$docker_context$kubernetes$cmd_duration$jobs$status$line_break$character
          '';
           os = {
             disabled = false;
             symbols = {
               Macos = "🍎";
               Linux = "🐧";
               Ubuntu = "🟠";
               Debian = "🌀";
               Fedora = "🎩";
               Alpine = "🏔️";
               Arch = "🔷";
               NixOS = "❄️";
             };
           };
           username = {
             disabled = false;
             show_always = false;
             format = "[$user](bold yellow)@";
             style_user = "bold yellow";
             ssh_only = true;
           };
           hostname = {
             disabled = false;
             ssh_only = true;
             ssh_symbol = "🌐";
             format = "[$ssh_symbol$hostname](bold red) ";
             style = "bold red";
             trim_at = ".";
           };
           shlvl = {
             disabled = false;
             threshold = 2;
             format = "[$symbol$shlvl](bold yellow) ";
             symbol = "↕️";
             style = "bold yellow";
           };
           character = {
             success_symbol = "[❯](peach)";
             error_symbol = "[❯](red)";
           };
           line_break = {
             disabled = false;
           };
           jobs = {
             disabled = false;
             symbol = "✦";
             format = "[$symbol$number](blue) ";
           };
           status = {
             disabled = false;
             format = "[$symbol$status]($style) ";
             symbol = "✖";
             not_executable_symbol = "🚫";
             not_found_symbol = "🔍";
             sigint_symbol = "🧱";
             signal_symbol = "⚡";
           };
           directory = {
             truncation_length = 3;
             truncate_to_repo = true;
             format = "[$read_only]($read_only_style)[$path](lavender) ";
             style = "bold lavender";
             read_only = "🔒";
             read_only_style = "red";
             home_symbol = "~";
             truncation_symbol = "…/";
           };
           git_branch = {
             symbol = "";
             format = "[$symbol$branch(:$remote_branch)](mauve) ";
             style = "bold mauve";
           };
           git_status = {
             format = "([$all_status$ahead_behind](yellow)) ";
             style = "yellow";
             conflicted = "=";
             ahead = "⇡\${count}";
             behind = "⇣\${count}";
             diverged = "⇕\${ahead_count}⇣\${behind_count}";
             untracked = "?";
             stashed = "$";
             modified = "!";
             staged = "+";
             renamed = "»";
             deleted = "✘";
           };
           git_commit = {
             commit_hash_length = 8;
             format = "[$hash$tag](maroon) ";
             style = "maroon";
             tag_disabled = false;
             tag_symbol = "🏷️";
           };
           git_state = {
             format = "[$state($progress_current/$progress_total)](peach) ";
             style = "peach";
             rebase = "rebase";
             merge = "merge";
             revert = "revert";
             cherry_pick = "cherry";
             bisect = "bisect";
             am = "am";
             am_or_rebase = "am/rb";
           };
           git_metrics = {
             disabled = false;
             format = "([+$added](green) )([-$deleted](red) )";
             added_style = "bold green";
             deleted_style = "bold red";
             only_nonzero_diffs = true;
           };
           python = {
             symbol = "🐍";
             format = "[$symbol$version](green) ";
             style = "green";
             detect_files = [
               "requirements.txt"
               "pyproject.toml"
               "Pipfile"
               ".python-version"
             ];
           };
           nodejs = {
             symbol = "⬢";
             format = "[$symbol$version](green) ";
             style = "green";
             detect_files = [
               "package.json"
               "yarn.lock"
               "pnpm-lock.yaml"
               ".nvmrc"
             ];
           };
           nix_shell = {
             symbol = "❄️";
             format = "[$symbol$state](blue) ";
             style = "bold blue";
             impure_msg = "[impure](red)";
             pure_msg = "[pure](green)";
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
           java = {
             symbol = "☕";
             format = "[$symbol$version](red) ";
             style = "red";
           };
           ruby = {
             symbol = "💎";
             format = "[$symbol$version](red) ";
             style = "red";
           };
           php = {
             symbol = "🐘";
             format = "[$symbol$version](purple) ";
             style = "purple";
           };
           docker_context = {
             symbol = "🐳";
             format = "[$symbol$context](blue) ";
             only_with_files = true;
           };
           kubernetes = {
             disabled = false;
             symbol = "☸️";
             format = "[$symbol$context( \\($namespace\\))](cyan) ";
             detect_files = [ "k8s" ];
           };
           cmd_duration = {
             min_time = 2000;
             format = "⏱️[$duration](yellow) ";
             style = "yellow";
             show_milliseconds = false;
           };
           time = {
             disabled = true;
             format = "🕙[$time](sky) ";
             style = "sky";
             time_format = "%T";
           };
           memory_usage = {
             disabled = true;
             threshold = 75;
             format = "[$symbol$ram( | $swap)](sapphire) ";
             style = "sapphire";
             symbol = "🧠";
           };
            battery = {
              disabled = false;
              full_symbol = "🔋";
              charging_symbol = "⚡";
              discharging_symbol = "💀";
              unknown_symbol = "❓";
              empty_symbol = "🪫";
              format = "[$symbol$percentage]($style) ";
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
