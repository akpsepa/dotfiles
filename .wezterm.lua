-- ╭──────────────────────────────────────────────────────────╮
-- │  NEBULA — a WezTerm config                               │
-- │  deep-space indigo, neon accents, powerline tabs         │
-- ╰──────────────────────────────────────────────────────────╯
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ── Palettes ───────────────────────────────────────────────
-- ⌘⇧L switches between dark (default) and light.
local themes = {
  dark = {
    void = '#0b0a1a', deep = '#13112b', dusk = '#1d1a3f', haze = '#2c2860',
    mist = '#6e6aa8', star = '#e6e3ff',
    pink = '#ff5fa2', violet = '#b18cff', cyan = '#5ce1e6', mint = '#7dffb3',
    gold = '#ffd36e', coral = '#ff8a65',
    ansi    = { '#1d1a3f', '#ff5f7e', '#7dffb3', '#ffd36e', '#7aa2ff', '#b18cff', '#5ce1e6', '#cfcaf5' },
    brights = { '#4a4580', '#ff8aa0', '#a8ffcc', '#ffe39b', '#a3bfff', '#cdb3ff', '#8ff0f3', '#ffffff' },
  },
  light = {
    void = '#ffffff', deep = '#f3f3f3', dusk = '#ededed', haze = '#cfe2f3',
    mist = '#4d4d4d', star = '#000000',
    pink = '#185abd', violet = '#707070', cyan = '#185abd', mint = '#555555',
    gold = '#555555', coral = '#555555',
    ansi    = { '#1d1b26', '#c62f55', '#1b7f4b', '#9a6700', '#2a5fd0', '#7040c0', '#0e7c86', '#eeeeee' },
    brights = { '#6b6880', '#e0506f', '#2aa566', '#b8800f', '#4a7fe6', '#9263d8', '#15a0aa', '#ffffff' },
  },
}

local function active_theme() return wezterm.GLOBAL.theme or 'dark' end

-- `c.xxx` always reads the active theme, so the tab bar and status bar follow the switch
local c = setmetatable({}, { __index = function(_, k) return themes[active_theme()][k] end })

local function make_scheme(p)
  return {
    foreground = p.star, background = p.void,
    cursor_bg = p.pink, cursor_fg = p.void, cursor_border = p.pink,
    selection_bg = p.haze, selection_fg = p.star,
    scrollbar_thumb = p.haze, split = p.violet, compose_cursor = p.gold,
    ansi = p.ansi, brights = p.brights,
    tab_bar = {
      background = p.void,
      new_tab = { bg_color = p.void, fg_color = p.mist },
      new_tab_hover = { bg_color = p.dusk, fg_color = p.pink },
    },
    quick_select_label_bg = { Color = p.pink },
    quick_select_label_fg = { Color = p.void },
    quick_select_match_bg = { Color = p.haze },
    quick_select_match_fg = { Color = p.star },
  }
end

config.color_schemes = { Nebula = make_scheme(themes.dark), Paper = make_scheme(themes.light) }
config.color_scheme = active_theme() == 'light' and 'Paper' or 'Nebula'

-- window look per theme; used at startup and by the toggle
local dark_gradient = {
  orientation = { Linear = { angle = -55.0 } },
  colors = { '#0b0a1a', '#141033', '#1c0f2e' },
  interpolation = 'CatmullRom', blend = 'Oklab', noise = 48,
}
local dark_font = wezterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Medium', harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' } },
  'Symbols Nerd Font Mono',
}
local dark_font_rules = {
  { italic = true, font = wezterm.font('JetBrains Mono', { weight = 'Medium', italic = true }) },
}
local function theme_look(name)
  local p = themes[name]
  local frame = {
    font = wezterm.font { family = 'JetBrains Mono', weight = 'Bold' },
    font_size = 11, active_titlebar_bg = p.void, inactive_titlebar_bg = p.void,
  }
  if name == 'light' then
    frame.font = wezterm.font { family = 'Arial', weight = 'Regular' }
    frame.font_size = 12
    frame.active_titlebar_bg = '#e9edf2'
    frame.inactive_titlebar_bg = '#f3f3f3'
    frame.border_left_width = '2px'
    frame.border_right_width = '2px'
    frame.border_top_height = '2px'
    frame.border_bottom_height = '2px'
    frame.border_left_color = '#a0a7b2'
    frame.border_right_color = '#a0a7b2'
    frame.border_top_color = '#a0a7b2'
    frame.border_bottom_color = '#a0a7b2'
    return {
      font = wezterm.font_with_fallback {
        { family = 'JetBrains Mono', weight = 'Regular' },
        'Symbols Nerd Font Mono',
      },
      font_rules = {}, font_size = 12, line_height = 1.1,
      window_padding = { left = 32, right = 32, top = 24, bottom = 24 },
      hide_tab_bar_if_only_one_tab = false, use_fancy_tab_bar = true,
      foreground_text_hsb = { hue = 1.0, saturation = 1.0, brightness = 0.55 },
      color_scheme = 'Paper', window_background_opacity = 1.0, macos_window_background_blur = 0,
      text_background_opacity = 0.12,
      window_background_gradient = { colors = { p.void, p.void }, orientation = 'Vertical', interpolation = 'Linear', blend = 'Rgb', noise = 0 },
      inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 }, window_frame = frame,
    }
  end
  return {
    font = dark_font, font_rules = dark_font_rules, font_size = 11, line_height = 1.05,
    foreground_text_hsb = { hue = 1.0, saturation = 1.0, brightness = 1.0 },
    window_padding = { left = 14, right = 14, top = 10, bottom = 6 },
    hide_tab_bar_if_only_one_tab = false, use_fancy_tab_bar = false,
    color_scheme = 'Nebula', window_background_opacity = 0.92, macos_window_background_blur = 40,
    text_background_opacity = 1.0,
    window_background_gradient = dark_gradient,
    inactive_pane_hsb = { saturation = 0.75, brightness = 0.6 }, window_frame = frame,
  }
end

-- ── Font ───────────────────────────────────────────────────
-- JetBrains Mono and Nerd Font symbols ship inside WezTerm.
config.font = wezterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Medium', harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' } },
  'Symbols Nerd Font Mono',
}
config.font_rules = {
  { italic = true, font = wezterm.font('JetBrains Mono', { weight = 'Medium', italic = true }) },
}
config.font_size = 11
config.line_height = 1.05
config.cell_width = 1.0

-- ── Window ─────────────────────────────────────────────────
config.initial_cols = 130
config.initial_rows = 34
config.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
config.window_padding = { left = 14, right = 14, top = 10, bottom = 6 }

-- ── Cursor & feel ──────────────────────────────────────────
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 550
config.cursor_blink_ease_in = 'EaseOut'
config.cursor_blink_ease_out = 'EaseOut'
config.cursor_thickness = 2
config.animation_fps = 120
config.max_fps = 120
config.front_end = 'WebGpu'
config.scrollback_lines = 20000
config.audible_bell = 'Disabled'
config.visual_bell = {
  fade_in_function = 'EaseIn', fade_in_duration_ms = 80,
  fade_out_function = 'EaseOut', fade_out_duration_ms = 220,
  target = 'CursorColor',
}
config.colors = { visual_bell = c.gold }
config.adjust_window_size_when_changing_font_size = false
config.native_macos_fullscreen_mode = true

-- ── Tab bar ────────────────────────────────────────────────
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32
config.show_new_tab_button_in_tab_bar = true

local nf = wezterm.nerdfonts
local LEFT  = nf.ple_left_half_circle_thick
local RIGHT = nf.ple_right_half_circle_thick

local process_icons = {
  zsh = nf.dev_terminal, bash = nf.dev_terminal, fish = nf.dev_terminal,
  nvim = nf.custom_vim, vim = nf.custom_vim,
  node = nf.md_nodejs, npm = nf.md_npm, pnpm = nf.md_npm, bun = nf.md_food_croissant,
  python = nf.dev_python, python3 = nf.dev_python,
  git = nf.dev_git, lazygit = nf.dev_git,
  docker = nf.linux_docker, ['docker-compose'] = nf.linux_docker,
  ssh = nf.md_server_network, htop = nf.md_chart_areaspline, btop = nf.md_chart_areaspline,
  cargo = nf.dev_rust, go = nf.seti_go, claude = nf.md_star_four_points,
}

-- each tab index gets its own accent, cycling through the palette
local accents = { c.pink, c.violet, c.cyan, c.mint, c.gold, c.coral }

local function basename(s) return (s or ''):gsub('(.*[/\\])(.*)', '%2') end

wezterm.on('format-tab-title', function(tab, _, _, _, hover, max_width)
  if active_theme() == 'light' then
    local title = tab.tab_title ~= '' and tab.tab_title or tab.active_pane.title
    return {
      { Background = { Color = tab.is_active and c.void or c.dusk } },
      { Foreground = { Color = tab.is_active and c.star or c.mist } },
      { Text = wezterm.truncate_right('  ' .. title .. '  ', max_width) },
    }
  end
  local pane = tab.active_pane
  local proc = basename(pane.foreground_process_name):gsub('%.exe$', '')
  local icon = process_icons[proc] or nf.md_console_line
  local title = tab.tab_title ~= '' and tab.tab_title or pane.title
  if proc ~= '' and process_icons[proc] and not title:find(proc, 1, true) then
    title = proc
  end
  if pane.is_zoomed then icon = nf.md_magnify_plus_outline end

  local accent = accents[(tab.tab_index % #accents) + 1]
  local bg, fg = c.dusk, c.mist
  if tab.is_active then bg, fg = accent, c.void
  elseif hover then bg, fg = c.haze, c.star end

  local label = string.format(' %s  %d %s ', icon, tab.tab_index + 1, title)
  label = wezterm.truncate_right(label, max_width - 3)

  return {
    { Background = { Color = c.void } }, { Foreground = { Color = bg } }, { Text = ' ' .. LEFT },
    { Background = { Color = bg } }, { Foreground = { Color = fg } },
    { Attribute = { Intensity = tab.is_active and 'Bold' or 'Normal' } },
    { Text = label },
    { Background = { Color = c.void } }, { Foreground = { Color = bg } }, { Text = RIGHT },
  }
end)

-- ── Status bar ─────────────────────────────────────────────
local moons = { nf.md_moon_new, nf.md_moon_waxing_crescent, nf.md_moon_first_quarter,
  nf.md_moon_waxing_gibbous, nf.md_moon_full, nf.md_moon_waning_gibbous,
  nf.md_moon_last_quarter, nf.md_moon_waning_crescent }

local function pill(cells, icon, text, bg, fg)
  table.insert(cells, { Background = { Color = c.void } })
  table.insert(cells, { Foreground = { Color = bg } })
  table.insert(cells, { Text = ' ' .. LEFT })
  table.insert(cells, { Background = { Color = bg } })
  table.insert(cells, { Foreground = { Color = fg } })
  table.insert(cells, { Text = icon .. ' ' .. text })
  table.insert(cells, { Background = { Color = c.void } })
  table.insert(cells, { Foreground = { Color = bg } })
  table.insert(cells, { Text = RIGHT })
end

wezterm.on('update-status', function(window, pane)
  if active_theme() == 'light' then
    window:set_left_status('')
    window:set_right_status('')
    return
  end
  -- left: mode indicator (leader / key tables)
  local left = {}
  local kt = window:active_key_table()
  if window:leader_is_active() then
    pill(left, nf.md_rocket_launch, 'LEADER', c.pink, c.void)
  elseif kt then
    pill(left, nf.md_keyboard, kt:upper():gsub('_', ' '), c.gold, c.void)
  else
    table.insert(left, { Foreground = { Color = c.violet } })
    table.insert(left, { Text = '  ' .. nf.md_creation .. ' ' })
  end
  window:set_left_status(wezterm.format(left))

  -- right: cwd · workspace · time
  local right = {}
  local cwd = pane:get_current_working_dir()
  if cwd then
    local path = (cwd.file_path or tostring(cwd)):gsub('^' .. wezterm.home_dir, '~')
    path = path:gsub('/$', '')
    if #path > 28 then path = '…' .. path:sub(-27) end
    table.insert(right, { Foreground = { Color = c.mist } })
    table.insert(right, { Text = nf.md_folder_outline .. ' ' .. path .. '  ' })
  end
  table.insert(right, { Foreground = { Color = c.cyan } })
  table.insert(right, { Text = nf.md_orbit .. ' ' .. window:active_workspace() .. '  ' })

  local hour = tonumber(wezterm.strftime '%H')
  local moon = moons[(math.floor(hour / 3) % #moons) + 1]
  pill(right, moon, wezterm.strftime '%a %d %b  %H:%M', c.violet, c.void)
  table.insert(right, { Text = ' ' })
  window:set_right_status(wezterm.format(right))
end)
config.status_update_interval = 1000

-- ── Keys ───────────────────────────────────────────────────
-- Everyday shortcuts are plain ⌘ / ⌘⌥ chords, like iTerm or a browser.
-- The Ctrl-a "leader" versions still work if you prefer tmux style:
-- tap Ctrl-a, let go, then tap the next key.
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2500 }

local split_right = act.SplitHorizontal { domain = 'CurrentPaneDomain' }
local split_down  = act.SplitVertical { domain = 'CurrentPaneDomain' }
local resize_mode = act.ActivateKeyTable { name = 'resize_pane', one_shot = false }
local swap_panes  = act.PaneSelect { alphabet = 'asdfghjkl', mode = 'SwapWithActive' }
local workspaces  = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' }

local rename_tab = act.PromptInputLine {
  description = wezterm.format { { Foreground = { Color = c.pink } }, { Text = 'Rename tab:' } },
  action = wezterm.action_callback(function(window, _, line)
    if line then window:active_tab():set_title(line) end
  end),
}
local new_workspace = act.PromptInputLine {
  description = wezterm.format { { Foreground = { Color = c.cyan } }, { Text = 'New workspace:' } },
  action = wezterm.action_callback(function(window, pane, line)
    if line and line ~= '' then
      window:perform_action(act.SwitchToWorkspace { name = line }, pane)
    end
  end),
}
local toggle_opacity = wezterm.action_callback(function(window)
  local o = window:get_config_overrides() or {}
  o.window_background_opacity = (o.window_background_opacity == 1.0) and 0.92 or 1.0
  window:set_config_overrides(o)
end)

local toggle_theme = wezterm.action_callback(function(window)
  local name = active_theme() == 'dark' and 'light' or 'dark'
  wezterm.GLOBAL.theme = name
  local o = window:get_config_overrides() or {}
  for k, v in pairs(theme_look(name)) do o[k] = v end
  window:set_config_overrides(o)
end)

config.keys = {
  -- ⌘ shortcuts (main set)
  { key = 'l',          mods = 'CMD|SHIFT', action = toggle_theme },
  { key = 'd',          mods = 'CMD',       action = split_right },
  { key = 'd',          mods = 'CMD|SHIFT', action = split_down },
  { key = 'w',          mods = 'CMD',       action = act.CloseCurrentPane { confirm = true } },
  { key = 'LeftArrow',  mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'CMD|OPT',   action = act.ActivatePaneDirection 'Down' },
  { key = 'LeftArrow',  mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Left', 3 } },
  { key = 'RightArrow', mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Right', 3 } },
  { key = 'UpArrow',    mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Up', 2 } },
  { key = 'DownArrow',  mods = 'CMD|CTRL',  action = act.AdjustPaneSize { 'Down', 2 } },
  { key = 'Enter',      mods = 'CMD|SHIFT', action = act.TogglePaneZoomState },
  { key = 'e',          mods = 'CMD|SHIFT', action = swap_panes },
  { key = 'i',          mods = 'CMD|SHIFT', action = rename_tab },
  { key = 's',          mods = 'CMD|SHIFT', action = workspaces },
  { key = 'n',          mods = 'CMD|SHIFT', action = new_workspace },
  { key = 'Space',      mods = 'CMD|SHIFT', action = act.QuickSelect },
  { key = 'x',          mods = 'CMD|SHIFT', action = act.ActivateCopyMode },
  { key = 'o',          mods = 'CMD|SHIFT', action = toggle_opacity },
  { key = 'p',          mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },
  -- ⌘/ opens the shortcut sheet in a pane below (q to close)
  { key = '/',          mods = 'CMD', action = act.SplitPane {
      direction = 'Down',
      size = { Percent = 40 },
      command = { args = { 'less', '-R', wezterm.home_dir .. '/wezterm-keys.md' } },
  } },
  { key = 'k',          mods = 'CMD',       action = act.ClearScrollback 'ScrollbackAndViewport' },
  { key = 'Enter',      mods = 'CMD',       action = act.ToggleFullScreen },
  -- ⌘T new tab, ⌘1–9 jump to tab, ⌘⇧[ / ⌘⇧] prev/next tab are WezTerm defaults

  -- Ctrl-a leader versions (optional)
  { key = '\\', mods = 'LEADER', action = split_right },
  { key = '-',  mods = 'LEADER', action = split_down },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'r', mods = 'LEADER', action = resize_mode },
  { key = 's', mods = 'LEADER', action = swap_panes },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = ',', mods = 'LEADER', action = rename_tab },
  { key = 'w', mods = 'LEADER', action = workspaces },
  { key = 'W', mods = 'LEADER|SHIFT', action = new_workspace },
  { key = 'Space', mods = 'LEADER', action = act.QuickSelect },
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'o', mods = 'LEADER', action = toggle_opacity },
  -- press Ctrl-a twice to send a real Ctrl-a (start of line in zsh)
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  -- word jumps with Option + arrows
  { key = 'LeftArrow',  mods = 'OPT', action = act.SendString '\x1bb' },
  { key = 'RightArrow', mods = 'OPT', action = act.SendString '\x1bf' },
  { key = 'Backspace',  mods = 'OPT', action = act.SendString '\x17' },  -- delete word
  -- line jumps with Cmd + arrows, Cmd-Backspace clears the line
  { key = 'LeftArrow',  mods = 'CMD', action = act.SendString '\x01' },
  { key = 'RightArrow', mods = 'CMD', action = act.SendString '\x05' },
  { key = 'Backspace',  mods = 'CMD', action = act.SendString '\x15' },
}

-- Leader + 1..9 jumps to a tab
for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1) })
end

config.key_tables = {
  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize { 'Left', 3 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 2 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 2 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 3 } },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter', action = 'PopKeyTable' },
  },
}

-- ── Launcher / palette styling ─────────────────────────────
config.command_palette_bg_color = c.deep
config.command_palette_fg_color = c.star
config.command_palette_font_size = 12
config.char_select_bg_color = c.deep
config.char_select_fg_color = c.star

-- Cmd-click opens links
config.mouse_bindings = {
  { event = { Up = { streak = 1, button = 'Left' } }, mods = 'CMD', action = act.OpenLinkAtMouseCursor },
}

-- ── Session persistence ────────────────────────────────────
-- Panes, tabs and workspaces run in a background mux server, so closing
-- the window (or quitting WezTerm) keeps your shells running.
-- Reopening WezTerm reattaches to them. Survives quit, not reboot.
config.unix_domains = { { name = 'unix' } }
config.default_gui_startup_args = { 'connect', 'unix' }

for key, value in pairs(theme_look(active_theme())) do config[key] = value end

return config
