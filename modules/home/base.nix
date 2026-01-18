{ inputs, ... }:
{
  flake.modules.homeManager.base =
    {
      user,
      homeDir,
      ...
    }:
    {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
      home.username = user;
      home.homeDirectory = homeDir;
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
      home.sessionVariables = {
        DOTFILES_PATH = "${homeDir}/ghq/github.com/s0r4d3v/dotfiles";
      };
    };
}
