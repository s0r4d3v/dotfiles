# モダンツール使用ガイド

このdotfilesには、開発生産性を向上させる最新のCLIツールが多数含まれています。

## 📊 目次

- [シェル履歴: Atuin](#-シェル履歴-atuin)
- [Nixツール: nix-output-monitor](#-nixツール-nix-output-monitor)
- [データ処理: yq, jless, gron](#-データ処理-yq-jless-gron)
- [検索: ripgrep-all](#-検索-ripgrep-all)
- [プロセス管理: procs](#-プロセス管理-procs)
- [ベンチマーク: hyperfine](#-ベンチマーク-hyperfine)
- [ネットワーク: dog, gping, bandwhich](#-ネットワーク-dog-gping-bandwhich)
- [コンテナ: lazydocker](#-コンテナ-lazydocker)
- [Kubernetes: kubectl, k9s, kubectx](#-kubernetes-kubectl-k9s-kubectx)
- [Git: git-cliff, onefetch](#-git-git-cliff-onefetch)
- [その他: just, tokei](#-その他-just-tokei)

---

## 📜 シェル履歴: Atuin

**従来のツール**: 標準のシェル履歴（Ctrl+R）

### 特徴

- SQLiteベースの高速検索
- マルチラインコマンド対応
- Fuzzy検索
- コマンド実行時間・終了コード記録
- マシン間の暗号化同期（オプション）

### 基本的な使い方

```zsh
# 履歴を検索（Ctrl+Rで起動）
# または
atuin search <query>

# 統計情報を表示
atuin stats

# 同期を有効化（要アカウント: https://atuin.sh）
atuin login
atuin sync
```

### キーバインド

- `Ctrl+R`: 履歴検索を開く
- `↑/↓`: 履歴を移動
- `Ctrl+N/P`: 次/前の履歴（vim風）
- `Enter`: コマンドを実行
- `Tab`: コマンドをコピー（実行せず）

### 設定

`modules/home/cli/atuin.nix`:
```nix
search_mode = "fuzzy";      # fuzzy, exact, prefix
filter_mode = "global";     # global, host, session, directory
style = "compact";          # compact, full
```

---

## 🔨 Nixツール: nix-output-monitor

**従来のツール**: `nix build`（標準出力）

### 特徴

- ビルド進捗の視覚的表示
- 依存関係ツリー表示
- ビルド時間測定
- カラフルで読みやすい出力

### 使い方

```zsh
# エイリアスを使用（推奨）
nb     # = nom build
ns     # = nom shell
nd     # = nom develop

# 直接使用
nom build ".#homeConfigurations.$(whoami).activationPackage"
nom shell nixpkgs#hello
nom develop
```

### 出力例

```
[0/15 built, 0/2/7 copied (10.5/97.2 MiB)] building firefox: checking references
├── [run] building firefox
│   ├── [run] building firefox-unwrapped
│   └── [run] building firefox-wrapper
└── [run] building python3-packages
```

---

## 📊 データ処理: yq, jless, gron

### yq - YAML/JSON/XML/CSV プロセッサ

**従来のツール**: `jq`（JSON専用）

```zsh
# YAML を JSON に変換
yq -o=json file.yaml

# YAML から値を抽出
yq '.services.web.image' docker-compose.yml

# YAML を編集
yq -i '.version = "3.8"' docker-compose.yml

# 複数フォーマット間の変換
yq -p=xml -o=json file.xml > file.json
```

### jless - インタラクティブJSONビューア

**従来のツール**: `jq . | less`

```zsh
# JSONファイルを閲覧
jless data.json

# パイプから入力
curl https://api.github.com/users/s0r4d3v | jless

# YAMLも対応
jless config.yaml
```

**キーバインド**:
- `↑/↓/←/→`: ナビゲーション
- `/`: 検索
- `q`: 終了
- `.`: jqセレクタを表示

### gron - JSON をgrep可能に

**従来のツール**: `jq` + 複雑なフィルタ

```zsh
# JSON をパス形式に展開
gron data.json

# grep で検索
gron data.json | grep "email"

# 部分抽出して JSON に戻す
gron data.json | grep "user" | gron -u
```

**出力例**:
```javascript
json = {};
json.name = "John Doe";
json.email = "john@example.com";
json.age = 30;
```

---

## 🔍 検索: ripgrep-all

**従来のツール**: `ripgrep`（テキストファイルのみ）

### 特徴

- PDF, DOCX, XLSX, ZIP内のテキスト検索
- ripgrepの全機能を継承
- 自動フォーマット検出

### 使い方

```zsh
# PDF内を検索
rga "研究" papers/

# ZIPファイル内を検索
rga "TODO" archive.zip

# すべての形式を検索
rga "API key" .

# 拡張子でフィルタ
rga --type-add 'docs:*.{pdf,docx}' --type docs "keyword" .
```

---

## 🎯 プロセス管理: procs

**従来のツール**: `ps aux`

**エイリアス**: `ps`（上書き）

### 特徴

- カラフルな出力
- ツリー表示
- ソート・フィルタ機能
- TCP/UDPポート表示

### 使い方

```zsh
# すべてのプロセスを表示
procs

# ツリー表示
procs --tree

# 特定のプロセスを検索
procs firefox

# ポート8080を使用しているプロセス
procs --or 8080

# CPU使用率でソート
procs --sortd cpu
```

---

## ⚡ ベンチマーク: hyperfine

**従来のツール**: `time`

### 特徴

- 統計的に有意な測定
- ウォームアップ実行
- 比較機能
- 視覚的な出力

### 使い方

```zsh
# 単一コマンドの測定
hyperfine 'fd -e rs'

# 複数コマンドを比較
hyperfine 'rg pattern' 'grep -r pattern'

# ウォームアップを設定
hyperfine --warmup 3 'my-command'

# パラメータスイープ
hyperfine --prepare 'cargo build' --parameter-scan num_threads 1 8 'my-app {num_threads}'
```

**出力例**:
```
Benchmark 1: rg pattern
  Time (mean ± σ):      12.3 ms ±   0.5 ms    [User: 8.1 ms, System: 4.2 ms]
  Range (min … max):    11.5 ms …  14.2 ms    100 runs

Benchmark 2: grep -r pattern
  Time (mean ± σ):     152.3 ms ±   5.2 ms    [User: 45.1 ms, System: 107.2 ms]
  Range (min … max):   145.1 ms … 165.3 ms    20 runs

Summary
  'rg pattern' ran 12.39 times faster than 'grep -r pattern'
```

---

## 🌐 ネットワーク: dog, gping, bandwhich

### dog - DNS クライアント

**従来のツール**: `dig`

```zsh
# シンプルなクエリ
dog example.com

# 特定のレコードタイプ
dog example.com MX
dog example.com AAAA

# 特定のDNSサーバーを使用
dog @1.1.1.1 example.com

# JSON出力
dog example.com --json
```

### gping - グラフィカルping

**従来のツール**: `ping`

```zsh
# ホストにping
gping google.com

# 複数ホストを同時に
gping google.com 1.1.1.1 8.8.8.8

# グラフの色を変更
gping --color green example.com
```

### bandwhich - 帯域幅モニター

**従来のツール**: `iftop`, `nethogs`（要root）

```zsh
# 帯域幅を監視（要sudo）
sudo bandwhich

# 特定のインターフェースのみ
sudo bandwhich -i en0
```

---

## 🐳 コンテナ: lazydocker

**従来のツール**: `docker ps`, `docker logs`など

**エイリアス**: `lzd`

### 特徴

- TUI（Text User Interface）
- コンテナ/イメージ/ボリューム/ネットワーク管理
- ログのライブ表示
- リソース使用量の可視化

### 使い方

```zsh
# lazydocker を起動
lzd  # または lazydocker

# 起動すると自動的にTUIが表示される
```

**キーバインド**:
- `↑/↓`: 移動
- `x`: メニュー
- `Enter`: 選択/詳細
- `l`: ログを表示
- `e`: コマンド実行
- `d`: 削除
- `q`: 終了

---

## ☸️ Kubernetes: kubectl, k9s, kubectx

### kubectl

**エイリアス**: `k`

```zsh
# 基本的な使い方
k get pods
k get svc
k logs <pod-name>

# コンテキストの切り替え（kubectxを使用）
kubectx                    # コンテキスト一覧
kubectx <context-name>     # 切り替え

# 名前空間の切り替え（kubensを使用）
kubens                     # 名前空間一覧
kubens <namespace>         # 切り替え
```

### k9s - Kubernetes TUI

```zsh
# k9s を起動
k9s

# 特定の名前空間で起動
k9s -n kube-system

# 特定のコンテキストで起動
k9s --context my-cluster
```

**キーバインド**:
- `:pods`: Pod一覧
- `:svc`: Service一覧
- `:deployments`: Deployment一覧
- `/`: フィルタ
- `l`: ログ表示
- `d`: 詳細/YAML
- `e`: 編集
- `Ctrl+D`: 削除

---

## 📝 Git: git-cliff, onefetch

### git-cliff - CHANGELOG 生成

```zsh
# CHANGELOG を生成
git-cliff > CHANGELOG.md

# 最新バージョンのみ
git-cliff --latest

# 特定の範囲
git-cliff v1.0.0..v2.0.0

# カスタム設定
git-cliff --config cliff.toml
```

### onefetch - リポジトリ情報表示

```zsh
# 現在のリポジトリ情報を表示
onefetch

# 特定のディレクトリ
onefetch ~/projects/myrepo

# 統計情報のみ
onefetch --no-art
```

**出力例**: カラフルなアスキーアートとリポジトリ統計

---

## 🛠️ その他: just, tokei

### just - タスクランナー

**従来のツール**: `make`

```zsh
# Justfile を作成
cat > justfile <<'EOF'
# Build the project
build:
    cargo build --release

# Run tests
test:
    cargo test

# Deploy to production
deploy: build test
    ./deploy.sh
EOF

# タスクを実行
just build
just test
just deploy

# 利用可能なタスクを一覧
just --list
```

### tokei - コード統計

**従来のツール**: `cloc`, `sloccount`

```zsh
# 現在のディレクトリの統計
tokei

# 特定の言語のみ
tokei -t Rust,Python

# JSON出力
tokei --output json

# 除外パターン
tokei --exclude node_modules
```

**出力例**:
```
===============================================================================
 Language            Files        Lines         Code     Comments       Blanks
===============================================================================
 Rust                   10         1234         1000          100          134
 Nix                     8          567          450           50           67
 Markdown                3          123          100            0           23
-------------------------------------------------------------------------------
 Total                  21         1924         1550          150          224
===============================================================================
```

---

## 🚀 クイックリファレンス

| カテゴリ | 従来 | モダン | エイリアス |
|---------|------|--------|-----------|
| ファイル一覧 | `ls` | `eza` | `ls`, `ll`, `la` |
| ファイル閲覧 | `cat` | `bat` | `cat` |
| 検索 | `grep` | `ripgrep` | - |
| PDF検索 | - | `ripgrep-all` | `rga` |
| ファイル検索 | `find` | `fd` | - |
| プロセス | `ps` | `procs` | `ps` |
| ディスク使用量 | `du` | `dust` | `du` |
| ディスク容量 | `df` | `duf` | `df` |
| システム監視 | `htop` | `btop` | `top` |
| ネットワーク | `dig` | `dog` | - |
| ping | `ping` | `gping` | - |
| JSON | `jq` | `jq`, `jless`, `fx` | - |
| YAML | - | `yq` | - |
| ヘルプ | `man` | `tldr`/`tealdeer` | `help`, `tldr` |
| Docker | `docker` | `lazydocker` | `lzd` |
| Kubernetes | `kubectl` | `k9s`, `kubectx` | `k` |
| Git | - | `lazygit`, `onefetch` | `lg` |
| Nix build | `nix build` | `nom build` | `nb` |

---

## 📚 関連ドキュメント

- [セットアップガイド](SETUP.md)
- [開発環境のセットアップ](DEVENV.md)
- [シークレット管理](SECRETS.md)
- [README](../README.md)
