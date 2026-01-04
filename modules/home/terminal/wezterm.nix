{ ... }:
{
  flake.modules.homeManager.wezterm = {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        local config = wezterm.config_builder()

        -- Font
        config.font = wezterm.font("FiraCode Nerd Font")
        config.font_size = 10.0

        -- Appearance
        config.color_scheme = "Dracula"
        config.window_background_opacity = 0.8
        config.window_decorations = "RESIZE"
        config.hide_tab_bar_if_only_one_tab = true

        config.macos_window_background_blur = 10

        -- Keys
        config.keys = {
          { key = "f", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },
        }

        return config
      '';
    };
  };
}
