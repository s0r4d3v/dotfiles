{ ... }:
{
  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        maple-mono.NF-CN
      ];

      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs.brewCasks.ghostty else pkgs.ghostty;
        settings = {
          font-family = "Maple Mono NF CN";
          font-size = 10;
          clipboard-read = "allow";
          clipboard-write = "allow";
          cursor-style = "block";
          cursor-style-blink = false;
          mouse-hide-while-typing = true;
          theme = "dracula";
          background-opacity = 0.8;
          background-opacity-cells = true;
          background-blur = 10;
          window-decoration = "auto";
          macos-titlebar-style = "hidden";
          macos-titlebar-proxy-icon = "hidden";
          maximize = true;
          focus-follows-mouse = false;
          quick-terminal-position = "right";
          quick-terminal-screen = "main";
          
          # ============================================================================
          # OSC 52 クリップボード連携設定（ネストtmux対応）
          # ============================================================================
          
          # ターミナル機能設定（tmuxとの互換性向上）
          term = "xterm-256color";
          
          # Shell integration を明示的に無効化（tmuxとの競合を回避）
          shell-integration = "none";
          
          keybind = [
            "ctrl+shift+f=toggle_maximize"
            "global:ctrl+shift+h=toggle_visibility"
            "global:ctrl+shift+i=toggle_quick_terminal"
          ];
        };
        enableZshIntegration = true;
      };
    };
}
