local wezterm = require 'wezterm';

local mykeys = {
  {key="w", mods="ALT", action=wezterm.action{CloseCurrentPane={confirm=true}}},
}

for i = 1, 8 do
  -- CTRL+ALT + number to activate that tab
  table.insert(mykeys, {
    key=tostring(i),
    mods="ALT",
    action=wezterm.action{ActivateTab=i-1},
  })
end

return {
  colors = {
      background = "#012456",
      scrollbar_thumb = "#ffffff",
  },
  window_background_opacity = 1.0,
  text_background_opacity = 1.0,
  font = wezterm.font({
      family="JetBrains Mono",
      weight="Bold",
      harfbuzz_features={"calt=0", "clig=0", "liga=1"},
    }),
  enable_scroll_bar=true,
  hide_tab_bar_if_only_one_tab = true,
  --enable_wayland = true,
  keys = mykeys,
}
