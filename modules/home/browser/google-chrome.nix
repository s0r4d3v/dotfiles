{ ... }:
{
  flake.modules.homeManager.google-chrome =
    { ... }:
    {
      programs.google-chrome = {
        enable = true;
        # Configure in the App
      };
    };
}
