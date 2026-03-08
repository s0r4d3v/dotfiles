{ ... }:
{
  flake.modules.homeManager.sops =
    { homeDir, pkgs, lib, ... }:
    {
      # sops-nix.service が前回の失敗状態のまま残っている場合にリセットする
      # これにより「The user systemd session is degraded」エラーを防ぐ
      home.activation.resetFailedSopsNix = lib.mkIf (!pkgs.stdenv.isDarwin) (
        lib.hm.dag.entryBefore [ "reloadSystemd" ] ''
          if ${pkgs.systemd}/bin/systemctl --user is-failed sops-nix.service &>/dev/null; then
            $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl --user reset-failed sops-nix.service
          fi
        ''
      );
      sops = {
        defaultSopsFile = ../../../secrets/secrets.yaml;
        validateSopsFiles = false;

        age = {
          keyFile = "${homeDir}/.config/sops/age/keys.txt";
          generateKey = true;
        };

        secrets = {
          # SSH 秘密鍵
          "ssh-private-key-ed25519" = {
            path = "${homeDir}/.ssh/id_ed25519";
            mode = "0600";
          };
          "ssh-public-key-ed25519" = {
            path = "${homeDir}/.ssh/id_ed25519.pub";
            mode = "0644";
          };
          "ssh-private-key-rsa" = {
            path = "${homeDir}/.ssh/id_rsa";
            mode = "0600";
          };
          "ssh-public-key-rsa" = {
            path = "${homeDir}/.ssh/id_rsa.pub";
            mode = "0644";
          };
          "ssh-private-key-tanaka-site" = {
            path = "${homeDir}/.ssh/tanaka-site";
            mode = "0600";
          };

          # SSH ホスト設定（IP、ユーザー名などの機密情報を含む）
          "ssh-config-hosts" = {
            path = "${homeDir}/.ssh/config.d/hosts";
            mode = "0600";
          };
        };
      };

      home.sessionVariables = {
        SOPS_AGE_KEY_FILE = "${homeDir}/.config/sops/age/keys.txt";
      };

      home.packages = with pkgs; [
        sops
        age
      ];
    };
}
