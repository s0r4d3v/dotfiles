# dotfiles

NixとHome Managerで管理する、macOS/Linux対応のdotfiles。

## ✨ 特徴

- 🎯 **Declarative**: Nixによる宣言的な設定管理
- 🔄 **Reproducible**: どのマシンでも同じ環境を再現
- 🚀 **Modern Tools**: 最新のRust製CLIツールを多数搭載
- 🎨 **Catppuccin**: 統一されたMacchiatoテーマ
- ⚡ **Fast**: devenvによる高速な開発環境セットアップ（<100ms）
- 🔐 **Secure**: sops-nixによるシークレット管理（オプション）

## 📚 ドキュメント

| ドキュメント | 内容 |
|------------|------|
| **[セットアップガイド](docs/SETUP.md)** | 初回インストールとアップデート方法 |
| **[モダンツールの使い方](docs/TOOLS.md)** | 搭載ツールの使用方法とクイックリファレンス |
| **[開発環境のセットアップ](docs/DEVENV.md)** | direnv/devenvを使った開発環境構築 |
| **[シークレット管理](docs/SECRETS.md)** | sops-nixによる安全なシークレット管理 |

## 🚀 クイックスタート

### インストール

```bash
# Nix をインストール
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# dotfiles をセットアップ
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
```

詳細は [セットアップガイド](docs/SETUP.md) を参照してください。

### アップデート

```bash
# リモートの変更を取得してアップデート
pullenv && updateenv

# ローカルの変更のみを反映
updateenv
```

## 🛠️ 主要なツール

### CLI ツール

- **シェル**: Fish + Starship
- **エディタ**: Neovim (nixvim) + LSP
- **ターミナル**: Ghostty + Zellij
- **履歴管理**: Atuin（マルチライン対応、Fuzzy検索）
- **ファイル**: eza, bat, fd, ripgrep-all
- **データ処理**: yq, jless, gron, fx
- **Git**: lazygit, git-cliff, onefetch
- **開発**: devenv, nix-output-monitor, direnv

### コンテナ/クラウド

- **Docker**: lazydocker
- **Kubernetes**: kubectl, k9s, kubectx
- **IaC**: terraform, terragrunt
- **Cloud**: AWS CLI, Google Cloud SDK

詳細は [モダンツールの使い方](docs/TOOLS.md) を参照してください。

## 📁 プロジェクト構成

```
dotfiles/
├── flake.nix              # メインのflake定義
├── flake.lock             # 依存関係のロック
├── modules/
│   ├── core/              # コア設定（home.nix, templates等）
│   └── home/              # Home Manager モジュール
│       ├── base.nix       # 基本設定
│       ├── cli/           # CLIツール（shell, git, packages等）
│       ├── editor/        # Neovim設定
│       ├── terminal/      # Ghostty, Zellij設定
│       ├── browser/       # ブラウザ設定
│       └── productivity/  # 生産性ツール
├── templates/
│   ├── direnv/            # direnv テンプレート
│   └── devenv/            # devenv テンプレート
└── docs/                  # ドキュメント
```

## 🎨 テーマ

すべてのツールで [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) テーマを使用：

- Neovim
- Starship
- Ghostty
- Zellij
- bat
- その他多数

## 📝 カスタマイズ

### パッケージの追加

`modules/home/cli/packages.nix` を編集：

```nix
home.packages = with pkgs; [
  # 既存のパッケージ...
  your-package  # 追加
];
```

### 設定モジュールの追加

新しいファイルを `modules/home/` 配下に作成すると、import-treeが自動的に読み込みます。

詳細は [セットアップガイド](docs/SETUP.md#-カスタマイズ) を参照してください。

## 🔧 トラブルシューティング

よくある問題は [セットアップガイド](docs/SETUP.md#-トラブルシューティング) を参照してください。

## 📄 ライセンス

MIT License

## 🙏 謝辞

このdotfilesは以下のプロジェクトを参考にしています：

- [nix-community/home-manager](https://github.com/nix-community/home-manager)
- [cachix/devenv](https://github.com/cachix/devenv)
- [nix-community/nixvim](https://github.com/nix-community/nixvim)
- [catppuccin/nix](https://github.com/catppuccin/nix)
