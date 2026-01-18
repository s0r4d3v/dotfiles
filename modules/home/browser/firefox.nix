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

        policies = {
          # Updates & Background Services
          AppAutoUpdate                 = false;
          BackgroundAppUpdate           = false;

          DefaultDownloadDirectory = "\${home}/Downloads";
          DownloadDirectory = "\${home}/Downloads";

          # Feature Disabling
          DisableBuiltinPDFViewer       = true;
          DisableFirefoxStudies         = true;
          DisableFirefoxAccounts        = true;
          DisableFirefoxScreenshots     = true;
          DisableForgetButton           = true;
          DisableMasterPasswordCreation = true;
          DisableProfileImport          = true;
          DisableProfileRefresh         = true;
          DisableSetDesktopBackground   = true;
          DisablePocket                 = true;
          DisableTelemetry              = true;
          DisableFormHistory            = true;
          DisablePasswordReveal         = true;

          # Access Restrictions
          BlockAboutConfig              = false;
          BlockAboutProfiles            = true;
          BlockAboutSupport             = true;

          # UI and Behavior
          DisplayMenuBar                = "never";
          DisplayBookmarksToolbar	      = "never";
          DontCheckDefaultBrowser       = true;
          HardwareAcceleration          = false;
          OfferToSaveLogins             = false;
        };

        profiles.s0r4d3v = {
          id = 0;
          name = "s0r4d3v";
          isDefault = true;
          search = {
            force = true;
            default = "ddg";
            privateDefault = "ddg";
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      { name = "channel"; value = "unstable"; }
                      { name = "query";   value = "{searchTerms}"; }
                    ];
                  }
                ];
                icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      { name = "channel"; value = "unstable"; }
                      { name = "query";   value = "{searchTerms}"; }
                    ];
                  }
                ];
                icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      { name = "search"; value = "{searchTerms}"; }
                    ];
                  }
                ];
                icon           = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };
            };
          };
          # bookmarks = {
          #   force = true;
          #   settings = [
          #     {
          #       toolbar = true;
          #       bookmarks = [
          #         {
          #           name = "Attendance(2025A)";
          #           tags = [ "CAWK" ];
          #           url = "https://docs.google.com/forms/d/e/1FAIpQLSeDDQTFWIiQz_g3kBOnchplzxh4ZOmUDvUU5qVTFpOAxnDlTA/viewform?pli=1";
          #         }
          #         {
          #           name = "Appointment";
          #           tags = [ "CAWK" ];
          #           url = "https://cawk.c.u-tokyo.ac.jp/mypage2/?blogid=13&serviceid=1&provider_id=15&date_start=&date_end=";
          #         }
          #         {
          #           name = "Revise report";
          #           tags = [ "CAWK" ];
          #           url = "https://gemini.google.com/app/c7e02aca4308bbc6";
          #         }
          #         "separator"
          #         {
          #           name = "Notion";
          #           tags = [ "ACES" ];
          #           url = "https://www.notion.so/acesinc/ACES-Wiki-d4d7df04874b4e80a2d4dcd984032ec7";
          #         }
          #         "separator"
          #         {
          #           name = "Teams";
          #           tags = [ "TCM" ];
          #           url = "https://teams.microsoft.com/v2/";
          #         }
          #       ];
          #     }
          #   ];
          # };
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              # extensions list: https://nur.nix-community.org/repos/rycee/
              ublock-origin
              vimium-c
              onepassword-password-manager
            ];
          };
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
