# 開発環境セットアップガイド

このガイドでは、direnv と devenv を使用したプロジェクト別の開発環境セットアップ方法を説明します。

## 📋 目次

- [概要](#-概要)
- [direnv の使い方](#-direnv-の使い方)
- [devenv の使い方](#-devenv-の使い方推奨)
- [どちらを選ぶべきか](#-どちらを選ぶべきか)
- [実践例](#-実践例)

---

## 🎯 概要

### direnv とは？

- シェルレベルの環境変数マネージャー
- ディレクトリに入ると自動的に `.envrc` を読み込む
- Nix の `nix-shell` や `nix develop` と統合可能
- 軽量で汎用的

### devenv とは？

- Nix ベースの開発環境マネージャー
- **100ms以下**の高速起動（キャッシュ利用時）
- 言語ごとのベストプラクティス内蔵
- プロセス管理、サービス起動、pre-commit hooks対応
- direnv と組み合わせて使用

### 主な違い

| 機能 | direnv | devenv |
|------|--------|--------|
| 起動速度 | 遅い（数秒） | 高速（<100ms） |
| 設定の簡潔さ | 手動設定必要 | 言語ごとのプリセット |
| プロセス管理 | なし | あり |
| サービス起動 | なし | あり（Postgres等） |
| 学習曲線 | 緩やか | やや急 |

---

## 🔧 direnv の使い方

### 1. 基本的なセットアップ

```bash
cd ~/projects/myproject

# flake テンプレートを使用
nix flake init -t ~/ghq/github.com/s0r4d3v/dotfiles#direnv
# または短縮エイリアス
initdirenv
```

これにより以下のファイルが作成されます：

#### `flake.nix`

```nix
{
  description = "Cross-platform Nix development template with direnv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      perSystem = { config, pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            # パッケージを追加
            python3
            poetry
          ];
          shellHook = ''
            echo "Welcome to the development environment!"
          '';
        };
      };
    };
}
```

#### `.envrc`

```bash
use flake
```

### 2. direnv を許可

```bash
direnv allow
```

### 3. 環境に入る

```bash
# ディレクトリに入ると自動的にアクティベート
cd ~/projects/myproject  # shellHook が実行される
```

### 4. カスタマイズ

#### パッケージの追加

```nix
packages = with pkgs; [
  nodejs
  yarn
  postgresql
];
```

#### 環境変数の設定

```nix
shellHook = ''
  export DATABASE_URL="postgresql://localhost/mydb"
  export API_KEY="your-api-key"
  echo "Environment ready!"
'';
```

---

## ⚡ devenv の使い方（推奨）

### 1. 基本的なセットアップ

```bash
cd ~/projects/myproject

# devenv テンプレートを使用
nix flake init -t ~/ghq/github.com/s0r4d3v/dotfiles#devenv
# または短縮エイリアス
initdevenv
```

これにより以下のファイルが作成されます：

#### `flake.nix`

```nix
{
  description = "Development environment with devenv";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in {
      packages = forEachSystem (system: {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
      });

      devShells = forEachSystem (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [ ./devenv.nix ];
          };
        });
    };
}
```

#### `devenv.nix`

```nix
{ pkgs, lib, ... }:

{
  # パッケージ
  packages = [ pkgs.git ];

  # 言語設定（コメントを解除して有効化）
  # languages.rust.enable = true;
  # languages.python.enable = true;
  # languages.nodejs.enable = true;

  # スクリプト
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # シェルに入ったときに実行
  enterShell = ''
    hello
    git --version
  '';

  # テスト
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # サービス（コメントを解除して有効化）
  # services.postgres.enable = true;

  # pre-commit hooks
  # pre-commit.hooks.shellcheck.enable = true;
}
```

#### `.envrc`

```bash
use devenv
```

### 2. direnv を許可

```bash
direnv allow
```

### 3. 環境に入る

```bash
# ディレクトリに入ると自動的にアクティベート（100ms以下）
cd ~/projects/myproject
```

### 4. よく使う言語の設定

#### Python プロジェクト

```nix
{ pkgs, ... }:

{
  languages.python = {
    enable = true;
    version = "3.11";
    poetry = {
      enable = true;
      activate.enable = true;
    };
  };

  packages = [ pkgs.black pkgs.ruff ];

  enterShell = ''
    echo "Python $(python --version) environment ready"
  '';
}
```

#### Node.js プロジェクト

```nix
{ pkgs, ... }:

{
  languages.javascript = {
    enable = true;
    package = pkgs.nodejs_20;
    npm.enable = true;
  };

  packages = with pkgs; [
    yarn
    pnpm
  ];

  scripts.dev.exec = "npm run dev";
  scripts.build.exec = "npm run build";
}
```

#### Rust プロジェクト

```nix
{ pkgs, ... }:

{
  languages.rust = {
    enable = true;
    channel = "stable";
  };

  packages = with pkgs; [
    rust-analyzer
    cargo-watch
    cargo-edit
  ];

  processes.cargo-watch.exec = "cargo watch -x run";
}
```

#### Go プロジェクト

```nix
{ pkgs, ... }:

{
  languages.go = {
    enable = true;
    package = pkgs.go_1_22;
  };

  packages = with pkgs; [
    gopls
    golangci-lint
  ];
}
```

### 5. サービスの起動

#### PostgreSQL

```nix
{
  services.postgres = {
    enable = true;
    initialDatabases = [{ name = "mydb"; }];
    listen_addresses = "127.0.0.1";
  };

  enterShell = ''
    export DATABASE_URL="postgresql://localhost/mydb"
  '';
}
```

#### Redis

```nix
{
  services.redis = {
    enable = true;
  };
}
```

### 6. プロセス管理

```nix
{
  processes = {
    # フロントエンド開発サーバー
    frontend.exec = "npm run dev";

    # バックエンドサーバー
    backend.exec = "cargo run";

    # Tailwind CSS ウォッチャー
    tailwind.exec = "npx tailwindcss -i ./src/input.css -o ./dist/output.css --watch";
  };
}
```

すべてのプロセスを起動：

```bash
devenv up
```

### 7. pre-commit hooks

```nix
{
  pre-commit.hooks = {
    # Nix
    nixfmt.enable = true;

    # Python
    black.enable = true;
    ruff.enable = true;

    # JavaScript
    prettier.enable = true;
    eslint.enable = true;

    # Rust
    rustfmt.enable = true;
    clippy.enable = true;
  };
}
```

---

## 🤔 どちらを選ぶべきか？

### direnv を選ぶべき場合

- シンプルなプロジェクト
- 既存のNix flakeがある
- 最小限の設定で十分
- プロセス管理が不要

### devenv を選ぶべき場合（推奨）

- 起動速度を重視
- 言語ごとのベストプラクティスを活用したい
- サービス（DB等）を起動したい
- プロセス管理が必要
- pre-commit hooksを使いたい

### 両方を併用する場合

devenv は direnv と統合されているため、`.envrc` に `use devenv` と書くだけで両方の利点を得られます。

---

## 💡 実践例

### フルスタックWebアプリ

```nix
# devenv.nix
{ pkgs, ... }:

{
  # 言語
  languages = {
    python = {
      enable = true;
      poetry.enable = true;
    };
    javascript = {
      enable = true;
      package = pkgs.nodejs_20;
      npm.enable = true;
    };
  };

  # パッケージ
  packages = with pkgs; [
    yarn
    black
    ruff
    postgresql
  ];

  # サービス
  services = {
    postgres = {
      enable = true;
      initialDatabases = [{ name = "app_db"; }];
    };
    redis.enable = true;
  };

  # プロセス
  processes = {
    frontend.exec = "cd frontend && npm run dev";
    backend.exec = "cd backend && poetry run uvicorn main:app --reload";
  };

  # pre-commit
  pre-commit.hooks = {
    black.enable = true;
    ruff.enable = true;
    prettier.enable = true;
    eslint.enable = true;
  };

  # 環境変数
  env = {
    DATABASE_URL = "postgresql://localhost/app_db";
    REDIS_URL = "redis://localhost:6379";
  };

  # 起動時メッセージ
  enterShell = ''
    echo "🚀 Development environment ready!"
    echo "Frontend: http://localhost:3000"
    echo "Backend: http://localhost:8000"
    echo ""
    echo "Run 'devenv up' to start all services"
  '';
}
```

### データサイエンスプロジェクト

```nix
# devenv.nix
{ pkgs, ... }:

{
  languages.python = {
    enable = true;
    version = "3.11";
    poetry = {
      enable = true;
      activate.enable = true;
    };
  };

  packages = with pkgs; [
    # Python data science stack
    python311Packages.jupyter
    python311Packages.numpy
    python311Packages.pandas
    python311Packages.matplotlib
    python311Packages.scikit-learn

    # LaTeX for notebooks
    texlive.combined.scheme-small
  ];

  scripts = {
    notebook.exec = "jupyter notebook";
    lab.exec = "jupyter lab";
  };

  enterShell = ''
    echo "📊 Data Science environment ready"
    echo "Run 'notebook' to start Jupyter Notebook"
    echo "Run 'lab' to start Jupyter Lab"
  '';
}
```

---

## 🔧 トラブルシューティング

### direnv が自動的に読み込まれない

```bash
# direnv を許可
direnv allow

# Fish シェルの統合を確認
type direnv
```

### devenv が遅い

```bash
# キャッシュを使用しているか確認
cat .envrc
# 以下が含まれているはず：
# use devenv

# Cachix を使用
nix-env -iA cachix -f https://cachix.org/api/v1/install
cachix use devenv
```

### パッケージが見つからない

```bash
# パッケージを検索
nix search nixpkgs <package-name>

# または
comma <package-name>
```

### 環境を完全にリセット

```bash
# direnv をアンロード
direnv revoke

# flake.lock を削除
rm flake.lock

# 再度許可
direnv allow
```

---

## 📚 関連ドキュメント

- [セットアップガイド](SETUP.md)
- [モダンツールの使い方](TOOLS.md)
- [シークレット管理](SECRETS.md)
- [README](../README.md)

## 🔗 外部リンク

- [devenv 公式ドキュメント](https://devenv.sh/)
- [direnv 公式サイト](https://direnv.net/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
