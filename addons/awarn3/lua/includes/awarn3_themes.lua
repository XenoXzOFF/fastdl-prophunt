-- awarn3_themes.lua (refactor)
-- Realms: shared (loaded on both), with client-only persistence helpers.
if SERVER then AddCSLuaFile() end

-- Ensure AWarn exists
AWarn = AWarn or {}

-- ==============================
-- Config / constants
-- ==============================
local DEFAULT_THEME = "Dark"

-- ==============================
-- Internal storage
-- ==============================
local THEMES = {}        -- [name] = { name = "Dark", colors = { KEY = Color(...) } }
AWarn.ActiveThemeName = AWarn.ActiveThemeName or DEFAULT_THEME
AWarn.Colors = AWarn.Colors or {} -- plain table for easy iteration / PrintTable

-- ==============================
-- Utilities
-- ==============================
local function shallowcopy(src)
	local t = {}
	for k, v in pairs(src) do t[k] = v end
	return t
end

local function ensureValidThemeName(name)
	if not name or THEMES[name] == nil then
		-- Back-compat alias (typo)
		if name == "Burgandy" and THEMES["Burgundy"] then
			return "Burgundy"
		end
		return DEFAULT_THEME
	end
	return name
end

-- ==============================
-- Registration
-- ==============================
local function RegisterTheme(theme)
	assert(type(theme) == "table", "RegisterTheme: theme must be a table")
	assert(type(theme.name) == "string" and theme.name ~= "", "RegisterTheme: theme.name must be a non-empty string")
	assert(type(theme.colors) == "table", ("RegisterTheme('%s'): theme.colors must be a table"):format(theme.name))

	-- store plain tables so pairs()/PrintTable() and UI dropdowns work cleanly
	THEMES[theme.name] = {
		name   = theme.name,
		colors = shallowcopy(theme.colors),
	}
end

-- Expose if you want to add themes from other files
function AWarn:RegisterTheme(theme) RegisterTheme(theme) end

-- ==============================
-- Built-in themes
-- ==============================
do
	RegisterTheme({
		name = "Dark",
		colors = {
			COLOR_SELECTED             = Color(255,136,0,100),
			COLOR_BUTTON_SELECTED      = Color(180,120,20,40),
			COLOR_BUTTON               = Color(80,80,80,0),
			COLOR_BUTTON_2             = Color(80,80,80,255),
			COLOR_BUTTON_2_HOVERED     = Color(80,80,80,60),
			COLOR_BUTTON_HOVERED       = Color(92,92,92,220),
			COLOR_BUTTON_DISABLED      = Color(120,120,120,40),
			COLOR_BUTTON_TEXT          = Color(255,255,255,255),
			COLOR_LABEL_TEXT           = Color(255,255,255,255),
			COLOR_LABEL_VALUE_TEXT     = Color(180,180,180,255),
			COLOR_THEME_PRIMARY        = Color(40,40,40,255),
			COLOR_THEME_PRIMARY_SHADOW = Color(35,35,35,255),
			COLOR_THEME_SECONDARY      = Color(50,50,50,255),
			COLOR_RED_BUTTON           = Color(200,40,40,200),
			COLOR_RED_BUTTON_HOVERED   = Color(200,40,40,100),
		}
	})

	RegisterTheme({
		name = "Light",
		colors = {
			COLOR_SELECTED             = Color(255,136,0,200),
			COLOR_BUTTON_SELECTED      = Color(120,120,120,140),
			COLOR_BUTTON               = Color(80,80,80,0),
			COLOR_BUTTON_2             = Color(200,80,60,120),
			COLOR_BUTTON_2_HOVERED     = Color(200,80,60,60),
			COLOR_BUTTON_HOVERED       = Color(80,80,80,60),
			COLOR_BUTTON_DISABLED      = Color(120,120,120,40),
			COLOR_BUTTON_TEXT          = Color(20,20,20,240),
			COLOR_LABEL_TEXT           = Color(60,10,10,210),
			COLOR_LABEL_VALUE_TEXT     = Color(40,30,30,240),
			COLOR_THEME_PRIMARY        = Color(230,230,235,250),
			COLOR_THEME_SECONDARY      = Color(206,206,206,255),
			COLOR_THEME_PRIMARY_SHADOW = Color(189,189,189,250),
			COLOR_RED_BUTTON           = Color(255,0,0,200),
			COLOR_RED_BUTTON_HOVERED   = Color(255,0,0,200),
		}
	})

	RegisterTheme({
		name = "Rose",
		colors = {
			COLOR_SELECTED             = Color(255,0,200,160),
			COLOR_BUTTON_SELECTED      = Color(180,40,40,40),
			COLOR_BUTTON               = Color(80,80,80,0),
			COLOR_BUTTON_2             = Color(180,80,80,120),
			COLOR_BUTTON_2_HOVERED     = Color(180,80,80,180),
			COLOR_BUTTON_HOVERED       = Color(80,80,80,30),
			COLOR_BUTTON_DISABLED      = Color(120,120,120,40),
			COLOR_BUTTON_TEXT          = Color(20,20,20,180),
			COLOR_LABEL_TEXT           = Color(180,80,160,255),
			COLOR_LABEL_VALUE_TEXT     = Color(220,80,220,220),
			COLOR_THEME_PRIMARY        = Color(255,230,255,250),
			COLOR_THEME_SECONDARY      = Color(255,210,255,255),
			COLOR_THEME_PRIMARY_SHADOW = Color(235,216,234,250),
			COLOR_RED_BUTTON           = Color(255,80,80,200),
			COLOR_RED_BUTTON_HOVERED   = Color(255,80,80,255),
		}
	})

	local burgundy = {
		name = "Burgundy",
		colors = {
			COLOR_SELECTED             = Color(200,110,20,200),
			COLOR_BUTTON_SELECTED      = Color(180,50,80,80),
			COLOR_BUTTON               = Color(80,80,80,0),
			COLOR_BUTTON_2             = Color(180,50,80,120),
			COLOR_BUTTON_2_HOVERED     = Color(180,50,80,180),
			COLOR_BUTTON_HOVERED       = Color(80,80,80,30),
			COLOR_BUTTON_DISABLED      = Color(120,120,120,40),
			COLOR_BUTTON_TEXT          = Color(240,240,240,150),
			COLOR_LABEL_TEXT           = Color(250,250,250,200),
			COLOR_LABEL_VALUE_TEXT     = Color(255,200,200,180),
			COLOR_THEME_PRIMARY        = Color(80,0,20,250),
			COLOR_THEME_SECONDARY      = Color(100,0,40,255),
			COLOR_THEME_PRIMARY_SHADOW = Color(60,0,10,250),
			COLOR_RED_BUTTON           = Color(255,0,0,200),
			COLOR_RED_BUTTON_HOVERED   = Color(255,0,0,200),
		}
	}
	RegisterTheme(burgundy)
end

-- ==============================
-- Theme application
-- ==============================
local function applyTheme(name)
	name = ensureValidThemeName(name)
	local theme = THEMES[name] or THEMES[DEFAULT_THEME]
	AWarn.ActiveThemeName = theme.name
	AWarn.Colors = shallowcopy(theme.colors) -- plain table; safe to PrintTable/pairs
	return theme
end

-- Initialize once with current or default
applyTheme(AWarn.ActiveThemeName or DEFAULT_THEME)

-- ==============================
-- Public API (compat + extras)
-- ==============================
-- Original API: ReturnThemes (now returns a plain table, not a proxy)
function AWarn:ReturnThemes()
	return THEMES
end

-- Original API: SetTheme
function AWarn:SetTheme(themeName)
	assert(type(themeName) == "string", "AWarn:SetTheme(themeName) expects a string")
	applyTheme(themeName)
end

-- Convenience: Get a single theme table (or nil)
function AWarn:GetTheme(themeName)
	return THEMES[themeName]
end

-- Convenience: Sorted list of theme names
function AWarn:GetThemeNames()
	local names = {}
	for n in pairs(THEMES) do names[#names + 1] = n end
	table.sort(names)
	return names
end

-- Convenience: Active theme name
function AWarn:GetActiveThemeName()
	return AWarn.ActiveThemeName
end

-- Convenience: Safe color fetch with fallback to default theme
function AWarn:GetColor(key)
	local c = AWarn.Colors and AWarn.Colors[key]
	if c ~= nil then return c end
	local def = THEMES[DEFAULT_THEME]
	return def and def.colors[key] or nil
end

-- Convenience: Validate
function AWarn:IsValidTheme(themeName)
	return THEMES[themeName] ~= nil or themeName == "Burgandy" -- accept alias
end

-- ==============================
-- Optional client-side persistence
-- ==============================
if CLIENT then
	-- Load player's preferred theme from PData (defaults to DEFAULT_THEME)
	function AWarn:LoadThemeFromPData(defaultName)
		local name = LocalPlayer():GetPData("awarn3_theme", defaultName or DEFAULT_THEME)
		self:SetTheme(ensureValidThemeName(name))
	end

	-- Save player's preferred theme to PData
	function AWarn:SaveThemeToPData(themeName)
		themeName = ensureValidThemeName(themeName)
		LocalPlayer():SetPData("awarn3_theme", themeName)
		self:SetTheme(themeName)
	end

	-- Auto-apply once the local player exists
	hook.Add("InitPostEntity", "awarn3_theme_init", function()
		if not IsValid(LocalPlayer()) then return end
		AWarn:LoadThemeFromPData(DEFAULT_THEME)
	end)
end
