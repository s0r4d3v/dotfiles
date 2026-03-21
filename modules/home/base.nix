{ ... }:
{
  flake.modules.homeManager.base =
    {
      user,
      homeDir,
      pkgs,
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
      targets.genericLinux.enable = !pkgs.stdenv.isDarwin;
      home.sessionVariables = {
        DOTFILES_PATH = "${homeDir}/ghq/github.com/s0r4d3v/dotfiles";
        # UTF-8 locale for proper Unicode handling
        LANG = "C.UTF-8";
        LC_ALL = "C.UTF-8";
      };
    };
}
