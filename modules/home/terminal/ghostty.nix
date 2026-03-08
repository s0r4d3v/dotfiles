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
          command = "${pkgs.fish}/bin/fish --login";
          font-family = [
            "Maple Mono NF CN"
            "Apple Color Emoji"
          ];
          font-size = 10;

          # Force emoji unicode ranges to use Apple Color Emoji
          font-codepoint-map = [
            # Emoji ranges
            "U+1F300-U+1F9FF=Apple Color Emoji"  # Misc Symbols and Pictographs, Emoticons, etc.
            "U+2600-U+26FF=Apple Color Emoji"     # Misc symbols
            "U+2700-U+27BF=Apple Color Emoji"     # Dingbats
            "U+1F000-U+1F02F=Apple Color Emoji"   # Mahjong Tiles
            "U+1F0A0-U+1F0FF=Apple Color Emoji"   # Playing Cards
            "U+1FA00-U+1FAFF=Apple Color Emoji"   # Chess, Extended-A
          ];
          clipboard-read = "allow";
          clipboard-write = "allow";
          cursor-style = "block";
          cursor-style-blink = false;
          mouse-hide-while-typing = true;
          theme = "Catppuccin Macchiato";
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
          macos-option-as-alt = "left";

          keybind = [
            "ctrl+shift+f=toggle_maximize"
            "global:ctrl+shift+h=toggle_visibility"
            "global:ctrl+shift+i=toggle_quick_terminal"
          ];
        };
        enableFishIntegration = true;
      };
    };
}
