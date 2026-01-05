{ ... }:
{
  flake.modules.homeManager.firefox-bookmarks = { ... }: {
    programs.firefox.languagePacks = [ "ja", "en-GB" ];
  };
}

