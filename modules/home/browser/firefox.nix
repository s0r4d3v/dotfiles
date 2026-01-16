{ ... }:
{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        # package = if pkgs.stdenv.isDarwin then pkgs.brewCasks.firefox else pkgs.firefox;
        languagePacks = [
          "ja"
          "en-GB"
        ];

        profiles.default = {
          id = 0;
          name = "default";
          isDefault = true;
          search = {
            force = true;
            default = "ddg";
          };
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            # extensions list: https://nur.nix-community.org/repos/rycee/
            ublock-origin
            vimium-c
            onepassword-password-manager
          ];
          settings = {
            # https://kb.mozillazine.org/About:config_entries
            "browser.startup.homepage" = "https://duckduckgo.com/";
            "browser.startup.page" = 1;  # same as homepage
            "browser.compactmode.show" = true;
            "browser.cache.disk.enable" = false;
            "browser.download.folderList" = 0;  # downloads folder
            "browser.tabs.autoHide" = true;  # hide tab bar when only 1 tab
            "browser.tabs.closeButtons" = 2;  # don't display any close buttons
            "browser.tabs.insertRelatedAfterCurrent" = false;  # new tab at the rightmost
            "browser.tabs.loadOnNewTab" = 1;  # homepage
            "browser.tabs.loadOnNewWindow" = 1;  # homepage
            "browser.tabs.closeWindowWithLastTab" = true;
            "browser.safebrowsing.enabled" = true;

            "extensions.autoDisableScopes" = 0;

            "geo.enabled" = false;

            "ui.key.menuAccessKeyFocuses" = 0;  # none

            "view_source.editor.external" = true;
            "view_source.editor.path" = "nvim";
            "view_source.syntax_highlight" = true;
            "view_source.wrap_long_lines" = false;

            "clipboard.autocopy" = false;
            "image.animation_mode" = "normal";
            "permissions.default.image" = 1;  # load all images

            "network.cookie.cookieBehavior" = 1;  # block third party cookie
            "network.cookie.lifetimePolicy" = 2; # accept for session only
          };
        };
      };
    };
}
