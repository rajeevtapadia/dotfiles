local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.initial_cols = 120
config.initial_rows = 40

-- vague theme colors
local vague = {}
function vague.colors()
	return {
		foreground = "#cdcdcd",
		background = "#141415",

		cursor_bg = "#cdcdcd",
		cursor_fg = "#141415",
		cursor_border = "#cdcdcd",

		selection_fg = "#cdcdcd",
		selection_bg = "#252530",

		scrollbar_thumb = "#252530",
		split = "#252530",

		ansi = {
			"#252530",
			"#d8647e",
			"#7fa563",
			"#f3be7c",
			"#6e94b2",
			"#bb9dbd",
			"#aeaed1",
			"#cdcdcd",
		},
		brights = {
			"#606079",
			"#e08398",
			"#99b782",
			"#f5cb96",
			"#8ba9c1",
			"#c9b1ca",
			"#bebeda",
			"#d7d7d7",
		},
		tab_bar = {
			background = "#141415",
			active_tab = {
				bg_color = "#252530",
				fg_color = "#cdcdcd",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = "#141415",
				fg_color = "#606079",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab_hover = {
				bg_color = "#252530",
				fg_color = "#cdcdcd",
				italic = false,
			},
			new_tab = {
				bg_color = "#141415",
				fg_color = "#6e94b2",
			},
			new_tab_hover = {
				bg_color = "#252530",
				fg_color = "#8ba9c1",
			},
			inactive_tab_edge = "#252530",
		},
	}
end
function vague.window_frame() -- Fancy tab bar only
	return {
		active_titlebar_bg = "#141415",
		inactive_titlebar_bg = "#141415",
	}
end
config.colors = vague.colors()
config.window_frame = vague.window_frame()

config.keys = {
  -- Enable copy mode with CTRL+y to copy selection (similar to Vim yank)
  {key="y", mods="CTRL", action=wezterm.action{CopyTo="Clipboard"}},
}

return config

