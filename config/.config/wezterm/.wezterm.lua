-- ~/.wezterm.lua
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Helper: check if executable exists in Windows PATH
local function exe_exists(name)
	local ok, _stdout, _stderr = wezterm.run_child_process({ "where", name })
	return ok
end

local has_pwsh = exe_exists("pwsh.exe")
local has_powershell = exe_exists("powershell.exe")
local has_cmd = exe_exists("cmd.exe")

-- config.default_prog = { "wsl.exe", "-e", "/home/kaleb/.local/bin/zsh-with-zellij" }

config.default_prog = {
	"wsl.exe",
	"-d",
	"Ubuntu-22.04",
	"--exec",
	"/home/kaleb/.local/bin/zsh-with-zellij",
}

-- Detect WSL distros and set default_cwd = "~" to start in Linux home
local wsl_domains = wezterm.default_wsl_domains()
local first_wsl_name = nil
for _, dom in ipairs(wsl_domains) do
	dom.default_cwd = "~"
end
if #wsl_domains > 0 then
	first_wsl_name = wsl_domains[1].name -- e.g. "WSL:Ubuntu-22.04"
	config.default_domain = first_wsl_name
end

-- Launch menu entries
local launch_menu = {}
if has_pwsh then
	table.insert(launch_menu, {
		label = "PowerShell (pwsh)",
		domain = { DomainName = "local" }, -- force Windows domain
		args = { "pwsh.exe", "-NoLogo" },
	})
end
if has_powershell then
	table.insert(launch_menu, {
		label = "PowerShell (Windows)",
		domain = { DomainName = "local" },
		args = { "powershell.exe", "-NoLogo" },
	})
end
if has_cmd then
	table.insert(launch_menu, {
		label = "Command Prompt",
		domain = { DomainName = "local" },
		args = { "cmd.exe" },
	})
end
for _, dom in ipairs(wsl_domains) do
	table.insert(launch_menu, {
		label = "WSL: " .. dom.distribution,
		domain = { DomainName = dom.name },
	})
end
config.launch_menu = launch_menu

-- Keybindings
local keys = {}

-- WSL new tab (SpawnTab with domain)
if first_wsl_name then
	table.insert(keys, {
		key = "w",
		mods = "CTRL|ALT",
		action = act.SpawnTab({ DomainName = first_wsl_name }),
	})
else
	table.insert(keys, {
		key = "w",
		mods = "CTRL|ALT",
		action = act.SpawnCommandInNewTab({ args = { "wsl.exe" } }),
	})
end

-- PowerShell new tab in Windows domain (no vanish)
if has_pwsh then
	table.insert(keys, {
		key = "p",
		mods = "CTRL|ALT",
		action = act.SpawnCommandInNewTab({
			domain = { DomainName = "local" },
			args = { "pwsh.exe", "-NoLogo" },
		}),
	})
elseif has_powershell then
	table.insert(keys, {
		key = "p",
		mods = "CTRL|ALT",
		action = act.SpawnCommandInNewTab({
			domain = { DomainName = "local" },
			args = { "powershell.exe", "-NoLogo" },
		}),
	})
end

-- cmd new tab in Windows domain (no vanish)
if has_cmd then
	table.insert(keys, {
		key = "c",
		mods = "CTRL|ALT",
		action = act.SpawnCommandInNewTab({
			domain = { DomainName = "local" },
			args = { "cmd.exe" },
		}),
	})
end

-- Split panes (inherit current domain)
table.insert(keys, {
	key = "\\",
	mods = "CTRL|ALT",
	action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
})
table.insert(keys, {
	key = "-",
	mods = "CTRL|ALT",
	action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
})

-- Tab switching
for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = "ALT",
		action = act.ActivateTab(i - 1),
	})
end
table.insert(keys, { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) })
table.insert(keys, { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) })
table.insert(keys, { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) })
table.insert(keys, { key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration })

config.keys = keys

-- Appearance
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 9
config.win32_system_backdrop = "Tabbed"
config.window_background_opacity = 0.33
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.color_scheme = "Tangoesque (terminal.sexy)"
config.color_scheme = "terafox"
config.color_scheme = "Terminix Dark (Gogh)"
config.color_scheme = "Tomorrow (dark) (terminal.sexy)"
config.color_scheme = "Tomorrow Night Burns"
config.color_scheme = "Vacuous 2 (terminal.sexy)"
config.color_scheme = "Vesper"

config.color_scheme = "X::DotShare (terminal.sexy)"
config.color_scheme = "Violet Dark"
config.color_scheme = "Arthur (Gogh)"
config.color_scheme = "Argonaut (Gogh)"
config.color_scheme = "Aco (Gogh)"
config.color_scheme = "zenwritten_dark"
config.color_scheme = "Unikitty Dark (base16)"

return config
