{ ... }:
{
  flake.modules.homeManager.vscode =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        # Config is synced using GitHub account
      };
    };
}
