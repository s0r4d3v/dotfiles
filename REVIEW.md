# Dotfiles レビューと改善提案

このドキュメントは、Nix Home Managerで管理されているdotfilesの包括的なレビュー結果と改善提案をまとめたものです。

## 実施概要

- **レビュー日**: 2026-03-07
- **対象**: Nix Home Manager dotfiles (flake-parts構成)
- **目的**: 冗長な設定の削減、ベストプラクティスの適用、simplification

## 参考リソース

以下のリソースを参考にベストプラクティスを調査しました：

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [home-manager - flake-parts](https://flake.parts/options/home-manager)
- [NixOS Discourse - How to organize home-manager and NixOS settings](https://discourse.nixos.org/t/how-do-you-organize-home-manager-and-nixos-settings-which-are-related/28466)
- [nixvim Documentation](https://nix-community.github.io/nixvim/)

## 改善可能な項目

### 1. flake.nix - コメントアウトされた設定の削除

**現状**: コメントアウトされたunstableブランチの設定が残っている

```nix
# nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
# url = "github:nix-community/home-manager";
# url = "github:nix-community/nixvim";
```

**提案**:
- ✅ **削除可能**: これらのコメント行は削除しても問題ありません
- 必要になった場合はgit履歴から復元可能

**影響**: なし（コメントのみ）

---

### 2. modules/core/home.nix - ユーザーリストの整理

**現状**: 複数のユーザーが定義されている

```nix
users = [
  "soranagano"
  "s0r4d3v"
  "m"
  "root"
];
```

**提案**:
- ⚠️ **要確認**: 実際に使用しているユーザーのみを残す
- `"m"`や`"root"`が実際に使用されていない場合は削除を検討
- マルチマシン対応が不要であれば、使用中のユーザーのみに絞る

**影響**: 使用していないユーザーのビルド時間削減

---

### 3. modules/home/productivity - モジュール名の重複

**現状**: `productivity.nix`と`karabiner.nix`が両方とも`flake.modules.homeManager.productivity`を定義

```nix
# productivity.nix
flake.modules.homeManager.productivity = { ... };

# karabiner.nix
flake.modules.homeManager.productivity = { ... };
```

**提案**:
- ❌ **修正必要**: モジュール名を分離する
  - `productivity.nix` → `flake.modules.homeManager.productivity`
  - `karabiner.nix` → `flake.modules.homeManager.karabiner`

**影響**: 現状では後から読み込まれた方が上書きされている可能性あり

---

### 4. modules/home/productivity/karabiner.nix - 無効化されたルールの整理

**現状**: 多数のKarabinerルールが`"enabled": false`で無効化されている

**提案**:
- ✅ **削除可能**: 無効化されているルール（enabled: false）は削除しても問題なし
- 必要になったらgit履歴から復元可能
- JSONファイルサイズを約70%削減可能

**影響**: 設定ファイルの可読性向上、ファイルサイズ削減

---

### 5. modules/home/cli/packages.nix - 装飾的パッケージの確認

**現状**: `pokemon-colorscripts`がインストールされている

```nix
pokemon-colorscripts
```

**提案**:
- ⚠️ **要確認**: 実際に使用しているか確認
- Neovimのダッシュボードで使用されているため、削除する場合はneovim.nixも修正が必要
- 使用していない場合は削除可能

**影響**: パッケージ数削減（わずか）

---

### 6. modules/home/cli/packages.nix - コメントアウトされたパッケージ

**現状**: `xdotool`がコメントアウトされている

```nix
# xdotool
```

**提案**:
- ✅ **削除可能**: 使用予定がなければ削除

**影響**: なし（コメントのみ）

---

### 7. modules/home/cli/ssh.nix - ハードコードされたパスの修正

**現状**: ユーザー名がハードコードされている

```nix
includes = [ "/Users/soranagano/.colima/ssh_config" ];
```

**提案**:
- ⚠️ **修正推奨**: `homeDir`変数を使用する

```nix
includes = [ "${homeDir}/.colima/ssh_config" ];
```

**影響**: マルチユーザー環境での移植性向上

---

### 8. modules/home/terminal - tmuxとzellijの重複

**現状**: tmuxとzellijの両方が有効化されている

**提案**:
- ⚠️ **要確認**: 実際に両方使用しているか確認
- 一方のみ使用している場合、もう一方を無効化
- 両方使用している場合は現状維持

**影響**: 使用していないツールの設定削除による simplification

---

### 9. modules/home/cli/starship.nix - カラーパレット定義

**現状**: Catppuccinカラーパレットが全て手動定義されている（42行）

```nix
palettes = {
  catppuccin_macchiato = {
    rosewater = "#f4dbd6";
    flamingo = "#f0c6c6";
    # ... 多数の色定義
  };
};
```

**提案**:
- ⚠️ **要検討**: Starshipの公式Catppuccinテーマを使用する方が保守性が高い
- ただし、カスタマイズしている場合は現状維持

**影響**: 設定の簡潔化、公式テーマとの同期

---

### 10. modules/home/editor/neovim.nix - npm手動インストール

**現状**: activationフックで`spyglassmc-language-server`を手動インストール

```nix
home.activation.installSpyglassmc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  if ! [ -f "$HOME/.npm-global/bin/spyglassmc-language-server" ]; then
    echo "Installing @spyglassmc/language-server..."
    export npm_config_prefix="$HOME/.npm-global"
    $HOME/.nix-profile/bin/npm install -g @spyglassmc/language-server
  fi
'';
```

**提案**:
- ⚠️ **要検討**: Nixパッケージとして管理する方が望ましい
- ただし、パッケージが利用可能でない場合は現状維持もやむを得ない
- `spyglassmc-language-server`をnixpkgsまたはNURから取得できるか確認

**影響**: 宣言的な管理の徹底

---

### 11. modules/core/flake-modules.nix - 最小限のファイル

**現状**: 1つのインポートのみを含む

```nix
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
```

**提案**:
- ⚠️ **要検討**: 他のcoreモジュールに統合可能
- ただし、将来的な拡張を考慮して分離している場合は現状維持

**影響**: ファイル数の削減（わずか）

---

### 12. 全体 - stateVersionの統一性

**現状**: `home.stateVersion = "25.11"`が設定されている

**提案**:
- ✅ **問題なし**: 適切に設定されている
- 変更しないこと（[Home Manager Manual](https://nix-community.github.io/home-manager/)参照）

**影響**: なし

---

## 優先度別まとめ

### 高優先度（修正推奨）

1. ❌ **modules/home/productivity - モジュール名の重複** (要修正)
   - 現状で動作していても、上書きによる予期しない動作の可能性

### 中優先度（確認推奨）

2. ⚠️ **modules/core/home.nix - 使用していないユーザーの削除**
3. ⚠️ **modules/home/cli/ssh.nix - ハードコードパスの修正**
4. ⚠️ **tmux/zellij - 使用していない方の無効化**

### 低優先度（任意）

5. ✅ **flake.nix - コメント行の削除**
6. ✅ **karabiner.nix - 無効ルールの削除**
7. ✅ **packages.nix - コメントアウト行の削除**
8. ⚠️ **pokemon-colorscripts - 使用確認**
9. ⚠️ **starship.nix - カラーパレット定義の見直し**
10. ⚠️ **neovim.nix - npm手動インストールの見直し**

---

## 削除しても確実に問題ない項目

以下は削除してもエラーが発生しない項目です：

1. ✅ flake.nixのコメントアウトされた行（7-8行目、12行目、39行目）
2. ✅ packages.nixのコメントアウトされた`# xdotool`行
3. ✅ karabiner.nixの`"enabled": false`のルール全て

---

## ベストプラクティスとの照合

### ✅ 実施できているベストプラクティス

- flake-partsの使用
- `follows`パターンでnixpkgsバージョンの統一
- モジュール分割による構成の整理
- `home.stateVersion`の適切な設定

### ⚠️ 改善の余地があるベストプラクティス

- 一部のハードコードされたパス
- モジュール名の重複
- 使用していない可能性のある設定の残存

---

## 次のステップ

1. **優先度高**の項目から対応
2. **優先度中**の項目について実際の使用状況を確認
3. **優先度低**の項目は必要に応じて対応
4. 変更後は`nix build`で問題ないことを確認
5. 段階的に適用し、各変更後に動作確認

---

## 参考情報

- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [flake-parts home-manager module](https://flake.parts/options/home-manager)
- [nixvim Documentation](https://nix-community.github.io/nixvim/)
- [NixOS Discourse](https://discourse.nixos.org/)
