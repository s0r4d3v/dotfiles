{ ... }:
{
  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [
        maple-mono.NF-CN
        nerd-fonts.fira-code
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
          # OSC 52 clipboard integration (nested tmux support)
          # ============================================================================

          # Terminal capability settings (improved tmux compatibility)
          term = "xterm-256color";

          # Explicitly disable shell integration (avoid conflict with tmux)
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
