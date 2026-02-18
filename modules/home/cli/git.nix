{ ... }:
{
  flake.modules.homeManager.git =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          ghq
          lazygit
        ];

      programs = {
        git = {
          enable = true;
          settings = {
            user = {
              name = "s0r4d3v";
              email = "s0r4d3v@gmail.com";
            };
            init.defaultBranch = "main";
            push.autoSetupRemote = true;
            pull.rebase = true;
          };
        };

        gh = {
          enable = true;
          extensions = [
            pkgs.gh-notify
          ];
        };

        jujutsu = {
          enable = true;
          settings = {
            user = {
              name = "s0r4d3v";
              email = "s0r4d3v@gmail.com";
            };
          };
        };

        delta = {
          enable = true;
          enableGitIntegration = true;
        };
      };
    };
}
