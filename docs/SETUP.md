# セットアップガイド

## 📋 前提条件

- Git
- インターネット接続
- macOS または Linux

## 🚀 初回インストール

### 1. Nix のインストール

[Determinate Nix](https://docs.determinate.systems/) を使用してNixをインストールします。

#### macOS / Linux (デスクトップ)

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

#### Linux (コンテナ環境)

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux --init none
echo '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' >> ~/.bashrc
source ~/.bashrc
```

### 2. dotfiles のクローンとビルド

```bash
# dotfiles をクローン
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles

# Home Manager 構成をビルド
nix build ".#homeConfigurations.$(whoami).activationPackage"

# 環境変数を設定
export USER="$(whoami)"

# 構成をアクティベート
./result/activate

# ghq でdotfilesを再配置
cd ..
rm -rf dotfiles
exec fish  # または exec zsh（使用しているシェル）
ghq get s0r4d3v/dotfiles
```

### 3. シェルの切り替え（オプション）

このdotfilesはFishシェルを使用します。初回起動時に自動的に設定されますが、デフォルトシェルを変更する場合：

```bash
# Fishシェルをデフォルトに設定
chsh -s $(which fish)
```

## 🔄 アップデート方法

### dotfiles を更新（リモートの変更を取得）

```bash
pullenv && updateenv
```

- `pullenv`: dotfilesリポジトリを`git pull`
- `updateenv`: Home Manager構成を再ビルド・アクティベート

### ローカルの変更のみを反映

dotfilesをローカルで編集した場合：

```bash
updateenv
```

### 詳細なビルド出力を確認

`nix-output-monitor` (nom) を使用した詳細な出力：

```bash
cd ~/ghq/github.com/s0r4d3v/dotfiles
nom build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
```

## 🎨 カスタマイズ

### ユーザー設定の追加

複数のユーザー/マシンで使用する場合、`modules/core/home.nix` の `users` リストを編集：

```nix
users = [
  "soranagano"
  "s0r4d3v"
  "m"
  "root"
  "your-username"  # 追加
];
```

### パッケージの追加

`modules/home/cli/packages.nix` の `home.packages` に追加：

```nix
home.packages = with pkgs; [
  # 既存のパッケージ...
  your-package
];
```

### プログラム設定の追加

新しいプログラムの設定モジュールを作成：

```bash
# 新しいモジュールファイルを作成
touch modules/home/cli/yourprogram.nix
```

```nix
{ ... }:
{
  flake.modules.homeManager.yourprogram =
    { pkgs, ... }:
    {
      programs.yourprogram = {
        enable = true;
        # 設定...
      };
    };
}
```

import-tree が自動的に読み込みます。

## 🐛 トラブルシューティング

### ビルドエラーが発生する

```bash
# キャッシュをクリア
nix-collect-garbage -d

# flake.lock を更新
nix flake update

# 再ビルド
updateenv
```

### 特定のパッケージが見つからない

```bash
# パッケージを検索
nix search nixpkgs <package-name>

# または
comma <package-name>
```

### シェル統合が動作しない

```bash
# シェルを再起動
exec fish  # または exec zsh
```

### Homebrewとの競合（macOS）

このdotfilesは `brew-nix` を使用してHomebrewパッケージを管理します。手動でインストールしたパッケージは影響を受けません。

## 📚 関連ドキュメント

- [モダンツールの使い方](TOOLS.md)
- [開発環境のセットアップ](DEVENV.md)
- [シークレット管理](SECRETS.md)
- [README](../README.md)
