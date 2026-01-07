{ ... }:
{
  flake.modules.homeManager.git = { pkgs, ... }: {
    home.packages = with pkgs; [
      gh
      ghq
      lazygit
    ];

    programs.git = {
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

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
