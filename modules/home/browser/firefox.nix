{ ... }:
{
  flake.modules.homeManager.firefox =
    { nurPkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        languagePacks = [
          "ja"
          "en-GB"
        ];

        profiles.default = {
          isDefault = true;
          search = {
            default = "google";
            force = true;
          };
          extensions.packages = with nurPkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin # 広告ブロック
            vimium-c # Vimキーバインド
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
            "network.cookie.cookieBehavior" = 1; # サードパーティCookieブロック
            "network.cookie.lifetimePolicy" = 2; # セッション終了時に削除

            # === リファラー制御 ===
            "network.http.referer.XOriginPolicy" = 2; # 同一オリジンのみ
            "network.http.referer.XOriginTrimmingPolicy" = 2;

            # === WebRTC IP漏洩防止 ===
            "media.peerconnection.ice.default_address_only" = true;
            "media.peerconnection.ice.no_host" = true;

            # === フィンガープリント対策 ===
            "privacy.resistFingerprinting" = true;
            "privacy.resistFingerprinting.letterboxing" = true;
            "webgl.disabled" = true;

            # === DNS over HTTPS ===
            "network.trr.mode" = 2; # TRR優先（フォールバックあり）
            "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

            # === Safe Browsing（Googleへの送信を制限） ===
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;

            # === その他プライバシー設定 ===
            "geo.enabled" = false; # 位置情報無効
            "dom.battery.enabled" = false; # バッテリーAPI無効
            "beacon.enabled" = false; # Beacon API無効
            "browser.send_pings" = false; # ピング送信無効

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
            "browser.startup.page" = 3; # 前回のセッションを復元
            "browser.startup.homepage" = "about:blank";
          };
        };
      };
    };
}
