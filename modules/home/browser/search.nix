{ ... }:
{
  flake.modules.homeManager.firefox-search = { ... }: {
    programs.firefox.profiles.default.search = {
      default = "google";
      force = true;
      engines = {
        "Nix Packages" = {
          urls = [{ template = "https://search.nixos.org/packages?query={searchTerms}"; }];
          icon = "https://nixos.org/favicon.png";
          definedAliases = [ "@np" ];
        };
        "NixOS Options" = {
          urls = [{ template = "https://search.nixos.org/options?query={searchTerms}"; }];
          icon = "https://nixos.org/favicon.png";
          definedAliases = [ "@no" ];
        };
        # 開発
        "GitHub" = {
          urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
          icon = "https://github.com/favicon.ico";
          definedAliases = [ "@gh" ];
        };
      };
    };
  };
}
