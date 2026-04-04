{ config, pkgs, ... }:
{
  # Broot — interactive directory navigator
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
    settings.verbs = [
      {
        key = "enter";
        execution = "$EDITOR {file}";
        apply_to = "file";
      }
    ];
  };

  # Direnv — auto-load .envrc / nix flake env per directory
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Yazi — TUI file manager
  xdg.configFile."yazi/yazi.toml".source = ../../config/.config/yazi/yazi.toml;

  # gwq — git worktree manager
  xdg.configFile."gwq/config.toml".text = ''
    [worktree]
    basedir = "${config.home.homeDirectory}/ghq"

    [naming]
    template = "{{.Host}}/{{.Owner}}/{{.Repository}}={{.Branch}}"
  '';

  # gh — GitHub CLI
  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-notify ];
  };

  # OpenCode
  xdg.configFile."opencode/opencode.json".source = ../../config/.config/opencode/opencode.json;
  xdg.configFile."opencode/skills" = {
    source = ../../config/.config/opencode/skills;
    recursive = true;
  };

  # Claude Code
  home.file.".claude/settings.json".source = ../../config/.claude/settings.json;
  home.file.".claude/hooks/block-rm.sh" = {
    source = ../../config/.claude/hooks/block-rm.sh;
    executable = true;
  };
  home.file.".claude/hooks/block-force-push.sh" = {
    source = ../../config/.claude/hooks/block-force-push.sh;
    executable = true;
  };
  home.file.".claude/hooks/statusline.sh" = {
    source = ../../config/.claude/hooks/statusline.sh;
    executable = true;
  };
}
