{ ... }:
{
  flake.modules.homeManager.base = { user, homeDir, ... }: {
    home.username = user;
    home.homeDirectory = homeDir;
    home.stateVersion = "25.05";
    programs.home-manager.enable = true;
    home.sessionVariables = {
      DOTFILES_PATH = "/Users/soranagano/ghq/github.com/m02uku/dotfiles";
    };
  };
}
