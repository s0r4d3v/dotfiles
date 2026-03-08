# シークレット管理ガイド

## ⚠️ 重要な注意事項

### sops-nix の現在の状態

**現在、sops-nix は一時的にコメントアウトされています。**

理由：GitHubへの接続時にHTTP 502エラーが発生するため、flake.lockへの追加が失敗しています。

```nix
# flake.nix (現在の状態)
# sops-nix = {
#   url = "github:Mic92/sops-nix";
#   inputs.nixpkgs.follows = "nixpkgs";
# };
```

### 有効化する方法

GitHubが正常にアクセス可能になったら：

1. `flake.nix` と `modules/core/home.nix` のコメントを解除
2. `nix flake lock --update-input sops-nix` を実行
3. `updateenv` で再ビルド

---

## 🔐 シークレット管理の概要

このdotfilesは [sops-nix](https://github.com/Mic92/sops-nix) を使用してシークレット（パスワード、APIキー、SSH鍵など）を安全に管理します。

### sops-nix とは？

- **暗号化**: age または GPG を使用してシークレットを暗号化
- **Git管理**: 暗号化されたシークレットを安全にGitリポジトリにコミット可能
- **自動復号化**: Home Manager によるビルド時に自動的に復号化
- **マルチフォーマット**: YAML, JSON, dotenv, binary をサポート

### 代替手段（sops-nix が利用できない場合）

sops-nix が利用できない間は、以下の方法でシークレットを管理できます：

1. **環境変数** - `~/.config/fish/conf.d/secrets.fish` に記述（Gitには含めない）
2. **手動管理** - `~/.ssh/`, `~/.config/gh/` などに直接配置
3. **1Password CLI** - `op` コマンドでシークレットを取得

---

## 📖 sops-nix の使用方法（利用可能になったら）

### 1. Age鍵の生成

```bash
# Age鍵を生成
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# 公開鍵を表示（次のステップで使用）
age-keygen -y ~/.config/sops/age/keys.txt
```

出力例：
```
age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
```

### 2. .sops.yaml の作成

dotfiles ルートディレクトリに `.sops.yaml` を作成：

```yaml
# .sops.yaml
keys:
  - &admin age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p

creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - age:
          - *admin
```

### 3. シークレットファイルの作成と暗号化

```bash
# secretsディレクトリを作成
mkdir -p secrets

# シークレットファイルを作成・編集
sops secrets/secrets.yaml
```

エディタが開くので、YAMLフォーマットでシークレットを記述：

```yaml
# secrets/secrets.yaml (暗号化前)
github-token: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
ssh-private-key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
  ...
  -----END OPENSSH PRIVATE KEY-----
aws-access-key: AKIAIOSFODNN7EXAMPLE
aws-secret-key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

保存すると自動的に暗号化されます。

### 4. sops.nix の設定を有効化

`modules/home/cli/sops.nix` のコメントを解除：

```nix
sops = {
  defaultSopsFile = ./secrets/secrets.yaml;
  validateSopsFiles = false;

  age = {
    keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    generateKey = true;
  };

  secrets = {
    # GitHub Personal Access Token
    "github-token" = {
      path = "${config.home.homeDirectory}/.config/gh/token";
    };

    # SSH Private Key
    "ssh-private-key" = {
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0600";
    };

    # AWS Credentials
    "aws-access-key" = {};
    "aws-secret-key" = {};
  };
};
```

### 5. シークレットの利用

```bash
# 再ビルド
updateenv

# シークレットが配置される
ls -la ~/.config/gh/token
ls -la ~/.ssh/id_ed25519

# 環境変数として使用する場合
cat ~/.run/secrets/aws-access-key
```

## 🔧 高度な使用方法

### 複数マシンでの使用

各マシンで異なるage鍵を使用する場合：

```yaml
# .sops.yaml
keys:
  - &laptop age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
  - &desktop age1yqz8h7zxqn8q7yy2x2j2j2j2j2j2j2j2j2j2j2j2j2j2j2j2j2j2j2

creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - age:
          - *laptop
          - *desktop
```

### シークレットの再暗号化

age鍵を変更した場合：

```bash
# すべてのシークレットを再暗号化
sops updatekeys secrets/secrets.yaml
```

### シークレットの編集

```bash
# 既存のシークレットを編集
sops secrets/secrets.yaml

# 特定のキーを表示
sops -d secrets/secrets.yaml | yq '.github-token'
```

## 🛡️ セキュリティのベストプラクティス

### やるべきこと

- ✅ `.sops.yaml` をGitにコミット（公開鍵のみ）
- ✅ 暗号化された `secrets/*.yaml` をGitにコミット
- ✅ age秘密鍵を安全に保管（バックアップ推奨）
- ✅ `.gitignore` で平文のシークレットを除外

### やってはいけないこと

- ❌ age秘密鍵（`~/.config/sops/age/keys.txt`）をGitにコミット
- ❌ 平文のシークレットをGitにコミット
- ❌ 暗号化していないシークレットファイルを作成

## 📚 参考資料

- [sops-nix 公式ドキュメント](https://github.com/Mic92/sops-nix)
- [sops 公式ドキュメント](https://github.com/mozilla/sops)
- [age 公式サイト](https://age-encryption.org/)

## 🔗 関連ドキュメント

- [セットアップガイド](SETUP.md)
- [モダンツールの使い方](TOOLS.md)
- [開発環境のセットアップ](DEVENV.md)
- [README](../README.md)
