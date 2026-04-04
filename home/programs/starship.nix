{ ... }:
{
  programs.starship.enable = true;
  xdg.configFile."starship.toml".source = ../../config/.config/starship.toml;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    # zsh-vi-mode overwrites these; zvm_after_init_commands in zsh.nix re-binds them
  };
}
