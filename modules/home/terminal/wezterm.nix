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
        config.window_background_opacity = 0.95
        config.window_decorations = "RESIZE"
        config.hide_tab_bar_if_only_one_tab = true

        -- Cursor
        config.default_cursor_style = "SteadyBar"

        -- Keys
        config.keys = {
          { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
          { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
          { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane { confirm = true } },
        }

        return config
      '';
    };
  };
}
