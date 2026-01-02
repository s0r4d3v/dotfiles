{ ... }:
{
  flake.modules.homeManager.firefox-bookmarks = { ... }: {
    programs.firefox.profiles.default.bookmarks = {
      force = true;
      settings = [
        {
          name = "Dev";
          toolbar = true;
          bookmarks = [
            { name = "GitHub"; url = "https://github.com"; }
            { name = "NixOS"; url = "https://nixos.org"; }
            { name = "Home Manager"; url = "https://nix-community.github.io/home-manager/options.xhtml"; }
          ];
        }
        # 検索エンジン
        {
          name = "Search";
          bookmarks = [
            { name = "Google"; url = "https://google.com"; }
          ];
        }
        # Nix関連
        {
          name = "Nix";
          bookmarks = [
            { name = "Nix Packages"; url = "https://search.nixos.org/packages"; }
            { name = "NixOS Wiki"; url = "https://wiki.nixos.org"; }
            { name = "NixVim"; url = "https://nix-community.github.io/nixvim/"; }
          ];
        }
      ];
    };
  };
}
