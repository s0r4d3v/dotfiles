# Dotfiles Review - Home Manager Configuration

このドキュメントは、NixのHome Managerで管理されているdotfilesの包括的なレビュー結果です。コミュニティのベストプラクティスと公式ドキュメントに基づいて分析し、改善点を特定しました。

## 目次

1. [全体構造の評価](#全体構造の評価)
2. [確実に削除できる冗長・不要な設定](#確実に削除できる冗長不要な設定)
3. [改善推奨事項](#改善推奨事項)
4. [ベストプラクティスとの比較](#ベストプラクティスとの比較)
5. [参考資料](#参考資料)

---

## 全体構造の評価

### 優れている点

✅ **flake-partsの活用**: `import-tree`と`flake-parts`を使ったモジュール構造は、保守性と拡張性が高い設計です。

✅ **明確な分離**: `modules/core`（システム設定）と`modules/home`（ユーザー設定）の分離が適切です。

✅ **nixpkgsのfollows**: Home ManagerとNixpkgsのバージョンを一致させる`follows`設定により、バージョン不整合を回避しています。

✅ **Catppuccinテーマの統一**: 複数のツール間でCatppuccin Macchiatoテーマが統一されており、一貫性があります。

### 構造図

```
dotfiles/
├── flake.nix                 # エントリーポイント（最小限の記述）
├── modules/
│   ├── core/                 # Flake設定
│   │   ├── home.nix         # Home Manager設定のコア
│   │   ├── systems.nix      # サポート対象システム
│   │   ├── templates.nix    # Flakeテンプレート
│   │   └── flake-modules.nix
│   └── home/                # ユーザー設定モジュール
│       ├── base.nix         # 基本設定
│       ├── cli/             # CLI関連
│       ├── editor/          # エディタ設定
│       ├── terminal/        # ターミナル設定
│       ├── browser/         # ブラウザ設定
│       └── productivity/    # 生産性ツール
└── templates/               # プロジェクトテンプレート
```

---

## 確実に削除できる冗長・不要な設定

以下は、削除してもエラーが発生しない、確実に不要な設定です。

### 1. Zellijモジュール全体（高優先度）

**ファイル**: `modules/home/terminal/zellij.nix`

**理由**:
- `enable = false` に設定されているため、設定内容はすべて無効
- 322行の設定コードが完全に未使用

**推奨アクション**:
```bash
# ファイル全体を削除可能
rm modules/home/terminal/zellij.nix
```

**影響**: なし（既に無効化されているため）

---

### 2. Karabinerの無効化されたルール（中優先度）

**ファイル**: `modules/home/productivity/karabiner.nix`

**理由**:
- 10個のルール中9個が`"enabled": false`に設定されている
- 有効なルールは以下の2つのみ：
  - "Caps Lockを、英数・かなのトグルに変更する"（line 257-288）
  - "escキーを押したときに、英数キーも送信する（vim用）"（line 316-327）

**推奨アクション**:
無効化されたルール（enabled: false）を削除し、有効なルールのみを残す。削除対象：
- Line 14-51: コマンドキー単体押し
- Line 52-89: CTRLキー単体押し
- Line 90-127: オプションキー単体押し
- Line 128-221: コマンドキートグル
- Line 222-255: 右コマンドキートグル
- Line 289-314: 英数・かなキー+Option
- Line 328-373: Ctrl+[
- Line 374-413: Ctrl+[ escape送信版
- Line 414-441: 英数・かなtoggle
- Line 442-479: 右コマンド+左Control
- Line 480-517: シフトキー単体押し

**影響**: なし（既に無効化されているため）

---

### 3. コメントアウトされたalias（低優先度）

**ファイル**: `modules/home/cli/shell.nix`

**該当箇所**:
```nix
# Line 75-76
# Zellij
# zj = "zellij";
```

**理由**: Zellijが無効化されており、コメントアウトされたaliasは不要

**推奨アクション**: コメント行を削除

**影響**: なし

---

### 4. packages.nixの冗長な記述（低優先度）

**ファイル**: `modules/home/cli/packages.nix`

**該当箇所**:
```nix
# Line 54-65
++ (
  if pkgs.stdenv.isDarwin then
    [
      zathura
      skimpdf
    ]
  else
    [
      # Linux: Zathura
      zathura
    ]
);
```

**理由**: `zathura`がDarwinとLinuxの両方に含まれており、条件分岐が不要

**推奨アクション**:
```nix
# 以下に簡略化
++ (
  if pkgs.stdenv.isDarwin then
    [ skimpdf ]
  else
    [ ]
)
++ [ zathura ]
```

または、より簡潔に：
```nix
++ [ zathura ]
++ lib.optionals pkgs.stdenv.isDarwin [ skimpdf ]
```

**影響**: なし（機能的に同一）

---

### 5. 使用していないユーザー設定（要確認）

**ファイル**: `modules/core/home.nix`

**該当箇所**:
```nix
users = [
  "soranagano"
  "s0r4d3v"
  "m"
  "root"
];
```

**理由**:
- 実際に使用しているユーザーアカウントは限定的である可能性が高い
- 不要なユーザー設定は、ビルド時間とストレージを消費

**推奨アクション**:
実際に使用するユーザーのみを残す（例：`soranagano`のみ、など）

**注意**: ユーザーの実際の使用状況を確認してから削除すること

---

### 6. allowUnsupportedSystem設定（要調査）

**ファイル**: `modules/home/base.nix`

**該当箇所**:
```nix
nixpkgs.config = {
  allowUnfree = true;
  allowUnsupportedSystem = true;
};
```

**理由**:
- `allowUnsupportedSystem`は通常不要
- サポート外のシステムでパッケージをビルドする必要がある場合のみ必要

**推奨アクション**:
使用しているシステム（macOS）が正式サポート対象であれば、`allowUnsupportedSystem = true;`を削除

**影響**: システムがサポート対象の場合、影響なし

---

## 改善推奨事項

以下は、削除すると潜在的にエラーが発生する可能性があるため、慎重に検討すべき改善項目です。

### 1. Neovimの設定の簡素化（検討推奨）

**ファイル**: `modules/home/editor/neovim.nix`

**現状**: 1103行の大規模な設定ファイル

**懸念点**:
- Jupyter/Quarto関連の設定（Molten、Quarto、Jupytext、Otter）が多数含まれる
- これらの機能を使用していない場合、冗長な設定となる

**推奨アクション**:
もしJupyter/Quartoを使用していない場合、以下のプラグインと設定を削除検討：
- `molten`プラグイン（line 775-777）
- `quarto`プラグイン（line 779-791）
- `otter`プラグイン（line 793-795）
- `jupytext`プラグイン（line 797-808）
- `hydra`プラグイン（line 810-812）
- Molten関連のキーマップ（line 347-408）
- Quarto runner関連のキーマップ（line 410-446）
- extraConfigLua内のnotebook関連設定（line 989-1099）

**注意**: これらの機能を実際に使用している場合は削除しないこと

---

### 2. Git設定の最適化

**ファイル**: `modules/home/cli/git.nix`

**現状**: 問題なし（`settings`は正しいオプション名）

**参考**: [Home-manager programs.git.settings](https://discourse.nixos.org/t/home-manager-option-programs-git-settings-does-not-exist-use-programs-git-extraconfig-instead/72586)

---

### 3. Home Manager npm global設定

**ファイル**: `modules/home/editor/neovim.nix`

**該当箇所**:
```nix
# Line 13-19
home.activation.installSpyglassmc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  if ! [ -f "$HOME/.npm-global/bin/spyglassmc-language-server" ]; then
    echo "Installing @spyglassmc/language-server..."
    export npm_config_prefix="$HOME/.npm-global"
    $HOME/.nix-profile/bin/npm install -g @spyglassmc/language-server
  fi
'';
```

**懸念点**:
- Home Managerのactivation scriptで外部パッケージをインストールするのは非推奨
- Nixの宣言的アプローチに反する

**推奨アクション**:
- Spyglassmc language serverをNixパッケージとして定義するか、使用していない場合は削除

---

### 4. lemonade設定の冗長性チェック

**ファイル**:
- `modules/home/base.nix` (launchd agent設定)
- `modules/home/editor/neovim.nix` (clipboard設定)
- `modules/home/cli/packages.nix` (パッケージインストール)
- `modules/home/cli/ssh.nix` (remoteForwards設定)

**現状**: lemonadeに関する設定が複数ファイルに分散

**推奨アクション**: 機能的には問題ないが、設定の集約を検討

---

## ベストプラクティスとの比較

### ✅ 実装されているベストプラクティス

1. **Flake lock fileの使用**: 再現性を保証（[Nix Flakes Best Practices](https://callistaenterprise.se/blogg/teknik/2025/04/10/nix-flakes/)）

2. **nixpkgs.follows**: Home ManagerとNixpkgsのバージョン一致（[Home Manager Manual](https://nix-community.github.io/home-manager/)）

3. **flake-partsでのモジュール化**: 再利用可能な設定構造（[flake-parts Best Practices](https://flake.parts/best-practices-for-module-writing.html)）

4. **設定の分離**: システムとユーザー設定の明確な分離

5. **Catppuccinテーマの統合**: 複数ツール間での一貫したテーマ管理

### ⚠️ 改善余地のある項目

1. **大規模なNeovim設定**: モジュール分割の検討（[Nixvim Best Practices](https://valentinpratz.de/posts/2024-02-12-nixvim-home-manager/)）

2. **無効化された設定の削除**: 使用していない設定の削除

3. **npm global installのactivation hook**: より宣言的なアプローチへの移行

---

## ベストプラクティスに関する追加推奨事項

### 1. mkOutOfStoreSymlinkの活用（検討推奨）

**参考**: [Nix Flakes Best Practices](https://callistaenterprise.se/blogg/teknik/2025/04/10/nix-flakes/)

**内容**: 頻繁に更新される設定（nvimなど）には、`mkOutOfStoreSymlink`を使用してdotfilesディレクトリへの直接シンボリックリンクを作成することで、`home-manager switch`なしで即座に変更を反映できます。

**現状**: 実装されていない

**影響**: 現在の実装でも機能するが、開発体験の向上余地あり

---

### 2. 秘密情報の管理

**参考**: [Nix Flakes Common Mistakes](https://nixos.wiki/wiki/Flakes)

**現状チェック**:
- ✅ SSH設定に秘密鍵のパスは含まれているが、鍵自体は含まれていない
- ✅ Git設定に認証情報は含まれていない
- ✅ 機密情報は適切に管理されている

---

### 3. home.stateVersionの管理

**参考**: [Home Manager stateVersion](https://github.com/nix-community/home-manager/issues/2073)

**現状**:
```nix
home.stateVersion = "25.11";
```

**推奨**:
- stateVersionは初回インストール時のバージョンに固定すべき
- nixpkgsのチャネルを更新しても、stateVersionは変更しない
- 現在25.11が初回インストールバージョンであれば問題なし

---

## 実装優先順位

### 🔴 高優先度（すぐに実行可能）

1. **Zellijモジュールの削除** - 322行の不要なコード削除
2. **Karabinerの無効ルール削除** - 約400行の冗長な設定削除

### 🟡 中優先度（検証後に実行）

3. **packages.nixのzathura冗長記述の修正**
4. **コメントアウトされたaliasの削除**
5. **allowUnsupportedSystem設定の削除**（確認後）

### 🟢 低優先度（慎重に検討）

6. **使用していないユーザー設定の削除**（使用状況確認後）
7. **Jupyter/Quarto関連設定の削除**（使用状況確認後）
8. **spyglassmc activation scriptの見直し**（使用状況確認後）

---

## まとめ

### 削除推奨ファイル/設定

確実に削除できるもの：

1. `modules/home/terminal/zellij.nix` - ファイル全体
2. `modules/home/productivity/karabiner.nix` - 無効化されたルール（9個）
3. `modules/home/cli/shell.nix` - コメントアウトされたalias
4. `modules/home/cli/packages.nix` - zathuraの冗長記述

### 見積もり削減量

- **行数**: 約750行以上の冗長コードを削除可能
- **ファイル数**: 1ファイル完全削除可能
- **ビルド時間**: わずかに短縮
- **保守性**: 大幅に向上

---

## 参考資料

### 公式ドキュメント

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [flake-parts Documentation](https://flake.parts/)
- [Nixvim GitHub](https://github.com/nix-community/nixvim)

### ベストプラクティスガイド

- [Next step in Nix: Embracing Flakes and Home Manager](https://callistaenterprise.se/blogg/teknik/2025/04/10/nix-flakes/)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [flake-parts Best Practices for Module Writing](https://flake.parts/best-practices-for-module-writing.html)
- [Declarative Neovim Configuration with Nixvim](https://valentinpratz.de/posts/2024-02-12-nixvim-home-manager/)

### コミュニティディスカッション

- [Home-manager programs.git.settings](https://discourse.nixos.org/t/home-manager-option-programs-git-settings-does-not-exist-use-programs-git-extraconfig-instead/72586)
- [Allow unfree in flakes](https://discourse.nixos.org/t/allow-unfree-in-flakes/29904)
- [Nix Flakes Common Mistakes](https://dev.to/beckmateo/5-very-common-mistakes-a-beginner-should-avoid-when-trying-nixos-for-the-first-time-to-truly-start-2j3n)

---

**レビュー日**: 2026-03-07
**Nixバージョン**: nixos-25.11
**Home Managerバージョン**: release-25.11
