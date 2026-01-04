{ ... }:
{
  flake.modules.homeManager.base = { user, homeDir, ... }: {
    home.username = user;
    home.homeDirectory = homeDir;
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
    home.sessionVariables = {
      DOTFILES_PATH = "/Users/soranagano/nix_env";
    };
    programs.zsh = {
      enable = true;
      initContent = ''
        nd() {
          nix develop "$DOTFILES_PATH#$1"
        }
      '';
    };
  };
}
