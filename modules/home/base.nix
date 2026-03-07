{ inputs, ... }:
{
  flake.modules.homeManager.base =
    {
      user,
      homeDir,
      pkgs,
      lib,
      ...
    }:
    {
      nixpkgs.config = {
        allowUnfree = true;
      };
      home.username = user;
      home.homeDirectory = homeDir;
      home.stateVersion = "25.11";
      programs.home-manager.enable = true;
      home.sessionVariables = {
        DOTFILES_PATH = "${homeDir}/ghq/github.com/s0r4d3v/dotfiles";
        # UTF-8 locale for proper Unicode handling (especially for lemonade clipboard)
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };

      # macOS only: lemonade clipboard server for SSH remote clipboard access
      launchd.agents = lib.mkIf pkgs.stdenv.isDarwin {
        lemonade = {
          enable = true;
          config = {
            ProgramArguments = [
              "${pkgs.lemonade}/bin/lemonade"
              "server"
              "--port"
              "2489"
              "--allow"
              "127.0.0.1/32"
            ];
            EnvironmentVariables = {
              LANG = "en_US.UTF-8";
              LC_ALL = "en_US.UTF-8";
            };
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/lemonade.log";
            StandardErrorPath = "/tmp/lemonade.err";
          };
        };
      };
    };
}
