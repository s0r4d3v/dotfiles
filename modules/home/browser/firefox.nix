{ ... }:
{
  flake.modules.homeManager.firefox = { nurPkgs, lib, ... }: {
    programs.firefox = {
      enable = true;
      languagePacks = [ "ja" "en-GB" ];

      policies = {
        DefaultDownloadDirectory = "\${home}/Downloads";
        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Privacy Badger:
          "jid1-MnnxcxisBPnSXQ@jetpack" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
            installation_mode = "force_installed";
          };
          # 1Password:
          "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
            installation_mode = "force_installed";
          };
        };
        DisableTelemetry = lib.mkForce true;
        DisableFirefoxStudies = lib.mkForce true;
        DisablePocket = lib.mkForce true;
        DisableFirefoxAccounts = lib.mkForce false;  # Syncを使いたい場合はfalse
        DisableFormHistory = lib.mkForce true;
        DisablePasswordReveal = lib.mkForce true;
        DontCheckDefaultBrowser = lib.mkForce true;
        EnableTrackingProtection = lib.mkForce {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        EncryptedMediaExtensions = lib.mkForce {
          Enabled = false;
          Locked = true;
        };
        FirefoxHome = lib.mkForce {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snippets = false;
          Locked = true;
        };
        FirefoxSuggest = lib.mkForce {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        NoDefaultBookmarks = lib.mkForce true;
        OfferToSaveLogins = lib.mkForce false;
      PasswordManagerEnabled = lib.mkForce false;
      SearchSuggestEnabled = lib.mkForce true;
      ShowHomeButton = lib.mkForce true;
      };

      profiles.default = {
        isDefault = true;
        search = {
          default = "google";
          force = true;
        };
        extensions.packages = with nurPkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin      # 広告ブロック
          vimium-c           # Vimキーバインド
        ];
        settings = {
          "extensions.autoDisableScopes" = 0;

          # === テレメトリ完全無効化 ===
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.server" = "";
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;

          # === Firefox調査・スタディ無効化 ===
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";

          # === Pocket無効化 ===
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.site" = "";

          # === トラッキング保護 ===
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.pbmode.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;

          # === Cookie制御 ===
          "network.cookie.cookieBehavior" = 1;  # サードパーティCookieブロック
          "network.cookie.lifetimePolicy" = 2;  # セッション終了時に削除

          # === リファラー制御 ===
          "network.http.referer.XOriginPolicy" = 2;  # 同一オリジンのみ
          "network.http.referer.XOriginTrimmingPolicy" = 2;

          # === WebRTC IP漏洩防止 ===
          "media.peerconnection.ice.default_address_only" = true;
          "media.peerconnection.ice.no_host" = true;

          # === フィンガープリント対策 ===
          "privacy.resistFingerprinting" = true;
          "privacy.resistFingerprinting.letterboxing" = true;
          "webgl.disabled" = true;

          # === DNS over HTTPS ===
          "network.trr.mode" = 2;  # TRR優先（フォールバックあり）
          "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

          # === Safe Browsing（Googleへの送信を制限） ===
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;

          # === その他プライバシー設定 ===
          "geo.enabled" = false;  # 位置情報無効
          "dom.battery.enabled" = false;  # バッテリーAPI無効
          "beacon.enabled" = false;  # Beacon API無効
          "browser.send_pings" = false;  # ピング送信無効

          # === パフォーマンス・UX ===
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.activity-stream.enabled" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;

          # === 起動時設定 ===
          "browser.startup.page" = 3;  # 前回のセッションを復元
          "browser.startup.homepage" = "about:blank";
        };

        bookmarks = {
          force = true;
          settings = [
            {
              name = "wikipedia";
              tags = [ "wiki" ];
              keyword = "wiki";
              url = "https://en.wikipedia.org/wiki/Special:Search?search=%s&go=Go";
            }
            {
              name = "kernel.org";
              url = "https://www.kernel.org";
            }
            "separator"
            {
              name = "Nix sites";
              toolbar = true;
              bookmarks = [
                {
                  name = "homepage";
                  url = "https://nixos.org/";
                }
                {
                  name = "wiki";
                  tags = [ "wiki" "nix" ];
                  url = "https://wiki.nixos.org/";
                }
              ];
            }
          ];
        };
      };

    };
  };
}

