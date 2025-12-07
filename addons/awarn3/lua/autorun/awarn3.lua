-- AWarn3 - Shared bootstrap
-- Only the server should mark client files for download.
if SERVER then
	AddCSLuaFile()                         -- send this shared file
	AddCSLuaFile("includes/cl_awarn3.lua") -- send the client file explicitly
end

-- Namespace
AWarn = AWarn or {}
AWarn.Version = "2.6.2"
AWarn.DefaultLanguage = "EN-US"

-- Centralized color definitions (kept under AWarn.Colors but with legacy globals preserved)
AWarn.Colors = AWarn.Colors or {
	WHITE   = Color(255, 255, 255),
	SERVER  = Color(  0, 200, 255),
	CLIENT  = Color(255, 136,   0),
	WARNING = Color(128,   0,   0),
	CHATTAG = Color(255,   0,   0),
}

-- Legacy globals for compatibility with older includes/code (do not remove without a major bump)
AWARN3_WHITE    = AWarn.Colors.WHITE
AWARN3_SERVER   = AWarn.Colors.SERVER
AWARN3_CLIENT   = AWarn.Colors.CLIENT
AWARN3_WARNING  = AWarn.Colors.WARNING
AWARN3_CHATTAG  = AWarn.Colors.CHATTAG

-- State color is context-dependent; set after realm loads below.
AWARN3_STATECOLOR = AWarn.Colors.WHITE

local function PrintBanner()
	local y = Color(255, 255, 128)
	local g = Color(  0, 255,   0)
	local w = Color(255, 255, 255)
	local r = Color(255,   0,   0)

	local lines = {
		{y, "\n      __          __              ", g, "____  \n"},
		{y, "     /\\ \\        / /             ", g, "|___ \\ \n"},
		{y, "    /  \\ \\  /\\  / /_ _ _ __ _ __   ", g, "__) |\n"},
		{y, "   / /\\ \\ \\/  \\/ / _` | '__| '_ \\ ", g, "|__ < \n"},
		{y, "  / ____ \\  /\\  / (_| | |  | | | |", g, "___) |\n"},
		{y, " /_/    \\_\\/  \\/ \\__,_|_|  |_| |_|", g, "____/\n"},
	}

	for _, segs in ipairs(lines) do
		MsgC(unpack(segs))
	end

	MsgC(w, "────────────────────────────────────────────\n")
	MsgC(r, "[AWarn3] ", w, "Welcome to AWarn3!\n")
end

PrintBanner()

-- Realm-specific includes and state color
if SERVER then
	AWARN3_STATECOLOR = AWarn.Colors.SERVER
	include("includes/sv_awarn3.lua")
else -- CLIENT
	AWARN3_STATECOLOR = AWarn.Colors.CLIENT
	include("includes/cl_awarn3.lua")
end
