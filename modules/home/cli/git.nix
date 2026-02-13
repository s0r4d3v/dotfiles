{ ... }:
{
  flake.modules.homeManager.git =
    { ... }:
    {
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
