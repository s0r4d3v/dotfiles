{ ... }:
{
  flake.modules.homeManager.sops =
    { homeDir, pkgs, ... }:
    {
      # sops-nix の設定
      sops = {
        # シークレットファイルのパス（flakeソースツリー内）
        defaultSopsFile = ../../../secrets/secrets.yaml;

        # age 秘密鍵の設定
        age = {
          keyFile = "${homeDir}/.config/sops/age/keys.txt";
          # 初回セットアップ時に鍵を自動生成
          generateKey = true;
        };

        secrets = {
          # メインの SSH 秘密鍵
          "ssh-private-key-ed25519" = {
            path = "${homeDir}/.ssh/id_ed25519";
            mode = "0600";
          };

          # tanaka-site 用 SSH 秘密鍵
          "ssh-private-key-tanaka-site" = {
            path = "${homeDir}/.ssh/tanaka-site";
            mode = "0600";
          };

          # SSH 公開鍵
          "ssh-public-key-ed25519" = {
            path = "${homeDir}/.ssh/id_ed25519.pub";
            mode = "0644";
          };

          # GitHub Personal Access Token
          # path 未指定の場合は $XDG_RUNTIME_DIR/secrets/github-token にアクセス可能
          "github-token" = { };
        };
      };

      # sops と age のパッケージをインストール
      home.packages = with pkgs; [
        sops
        age
      ];
    };
}
