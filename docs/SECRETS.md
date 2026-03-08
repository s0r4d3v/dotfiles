# シークレット管理ガイド

sops-nix + age を使ってSSH鍵などのシークレットを暗号化・Git管理しています。

## 仕組み

- `secrets/secrets.yaml` — age で暗号化されたシークレットファイル（Git管理）
- `~/.config/sops/age/keys.txt` — age 秘密鍵（**Git管理しない**）
- `.sops.yaml` — 復号に使う公開鍵の設定（Git管理）
- `SOPS_AGE_KEY_FILE` — 秘密鍵の場所を指す環境変数（シェル起動時に自動設定）

Home Manager のビルド時に secrets.yaml が復号され、SSH鍵などが正しいパーミッションで配置されます。

## 管理しているシークレット

| キー | 配置先 | 用途 |
|------|--------|------|
| `ssh-private-key-ed25519` | `~/.ssh/id_ed25519` | メインSSH秘密鍵 |
| `ssh-public-key-ed25519` | `~/.ssh/id_ed25519.pub` | メインSSH公開鍵 |
| `ssh-private-key-rsa` | `~/.ssh/id_rsa` | RSA SSH秘密鍵 |
| `ssh-public-key-rsa` | `~/.ssh/id_rsa.pub` | RSA SSH公開鍵 |
| `ssh-private-key-tanaka-site` | `~/.ssh/tanaka-site` | tanaka-site用SSH秘密鍵 |
| `ssh-config-hosts` | `~/.ssh/config.d/hosts` | SSHホスト設定（IP等） |

---

## age 秘密鍵のバックアップ

**age秘密鍵を紛失すると secrets.yaml を復号できなくなります。** 必ず安全な場所にバックアップしてください。

### バックアップ方法（優先順）

**1. 1Password（推奨）**

```bash
# 秘密鍵の内容を確認
cat ~/.config/sops/age/keys.txt

# 1Password に "age secret key (dotfiles)" などの名前でセキュアノートとして保存
# → 1Password アプリ > 新規アイテム > セキュアノート
```

**2. 暗号化したファイルを別ドライブに保存**

```bash
# USB等に暗号化して保存（復号パスワードは別途記憶）
age -p ~/.config/sops/age/keys.txt > /Volumes/USB/age-keys-backup.age
```

**3. 紙に印刷して保管**

```bash
# keys.txt の内容を印刷し、鍵と一緒に保管
cat ~/.config/sops/age/keys.txt
```

---

## 新しいマシンへの引き継ぎ

### パターンA: 同じ age 鍵を使い回す（推奨・簡単）

既存の秘密鍵をそのままコピーするので、`.sops.yaml` の変更不要です。

```bash
# 1. 新マシンで鍵ディレクトリを作成
mkdir -p ~/.config/sops/age

# 2. バックアップから秘密鍵を復元
#    - 1Password からコピペ、または
#    - 旧マシンから scp でコピー:
scp old-machine:~/.config/sops/age/keys.txt ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt

# 3. dotfiles をクローン
nix run nixpkgs#git -- clone https://github.com/s0r4d3v/dotfiles ~/ghq/github.com/s0r4d3v/dotfiles

# 4. ビルド・適用（sops が復号して SSH 鍵等を配置）
updateenv
```

### パターンB: 新しいマシン専用の age 鍵を使う

セキュリティを高めたい場合。`.sops.yaml` に新しい公開鍵を追加して再暗号化します。

```bash
# === 新マシンで作業 ===

# 1. 新しい age 鍵を生成
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
# → 公開鍵が表示される: age1xxxxxxxxxx...

# 公開鍵を確認（後で使う）
age-keygen -y ~/.config/sops/age/keys.txt


# === 旧マシン（または既存マシン）で作業 ===

# 2. .sops.yaml に新マシンの公開鍵を追加
#    例: new-machine のエントリを追加
#
# keys:
#   - &primary  age1gxcqm7f4m226vmakn3r6evxs8wc85ck2h0lkss9tfskxszg50uesn35x8q
#   - &new-machine age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#
# creation_rules:
#   - path_regex: secrets/[^/]+\.yaml$
#     key_groups:
#       - age:
#           - *primary
#           - *new-machine

# 3. secrets.yaml を新しい鍵で再暗号化
sops updatekeys secrets/secrets.yaml

# 4. コミット・プッシュ
git add .sops.yaml secrets/secrets.yaml
git commit -m "feat: add age key for new-machine"
git push


# === 新マシンで作業に戻る ===

# 5. dotfiles をクローン・ビルド
nix run nixpkgs#git -- clone https://github.com/s0r4d3v/dotfiles ~/ghq/github.com/s0r4d3v/dotfiles
updateenv
```

---

## 日常的な操作

### シークレットを編集する

```bash
sops secrets/secrets.yaml
# エディタが開く → 編集して保存すると自動で再暗号化される
```

### 特定のキーを確認する

```bash
# 全体を復号して確認
sops -d secrets/secrets.yaml

# 特定のキーだけ
sops -d secrets/secrets.yaml | yq '.ssh-config-hosts'
```

### 新しいシークレットを追加する

1. `sops secrets/secrets.yaml` で編集・追加
2. `modules/home/cli/sops.nix` に `secrets."new-key"` のエントリを追加
3. `updateenv` で再ビルド

---

## トラブルシューティング

### `no identity matched any of the recipients` エラー

```bash
# 秘密鍵の場所を確認
ls -la ~/.config/sops/age/keys.txt

# 環境変数が設定されているか確認
echo $SOPS_AGE_KEY_FILE

# シェルを再起動して環境変数を読み込ませる
exec fish
```

### 現在の公開鍵と .sops.yaml が一致しているか確認

```bash
# 手元の秘密鍵から公開鍵を表示
age-keygen -y ~/.config/sops/age/keys.txt

# .sops.yaml の公開鍵と比較
cat .sops.yaml
```

### secrets.yaml の再暗号化

```bash
# 鍵の更新・追加後に再暗号化
sops updatekeys secrets/secrets.yaml
```

---

## セキュリティ上のルール

- ✅ `.sops.yaml` はコミットする（公開鍵のみ含む）
- ✅ `secrets/secrets.yaml` はコミットする（暗号化済み）
- ✅ age 秘密鍵は必ず複数箇所にバックアップ
- ❌ `~/.config/sops/age/keys.txt` はコミットしない（`.gitignore` で除外済み）
- ❌ 復号した平文をファイルに書き出してコミットしない

## 関連ドキュメント

- [セットアップガイド](SETUP.md)
- [開発環境のセットアップ](DEVENV.md)
- [sops-nix 公式ドキュメント](https://github.com/Mic92/sops-nix)
- [age 公式サイト](https://age-encryption.org/)
