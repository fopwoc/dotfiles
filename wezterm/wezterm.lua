local wezterm = require 'wezterm';
return {
  font = wezterm.font("JetBrains Mono"),
  enable_scroll_bar=true,
  hide_tab_bar_if_only_one_tab = true,
  enable_wayland = true,
  font_antialias = "Subpixel"
--  keys = {
--    {key="w", mods="CMD", action=CloseCurrentTab{confirm=true}},
--    {key="w", mods="CMD", action={SpawnTab="CurrentPaneDomain"}},
--  }
}
