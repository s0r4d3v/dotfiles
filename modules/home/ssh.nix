{ config, ... }:
{
  # agenix設定
  age = {
    # SSH秘密鍵のパス（ローカル環境に存在するもの）
    identityPaths = [ "/Users/soranagano/.ssh/id_ed25519" ];

    # SSH設定ファイル
    secrets = {
      "ssh/config" = {
        file = ../core/secrets/ssh/config.age;
        path = "${config.home.homeDirectory}/.ssh/config";
        mode = "600";
      };
    };
  };

  # SSH設定はageで管理するため、programs.sshは使用しない
}