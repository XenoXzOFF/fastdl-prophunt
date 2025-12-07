--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

    AWarn3 by Mr.President
    Refactored: statistics + version check
]]

if CLIENT then return end

-- ─────────────────────────────────────────────────────────────────────────────
-- Configuration (runtime-togglable via ConVars)
-- ─────────────────────────────────────────────────────────────────────────────

-- Whether to print friendly status messages to server console.
CreateConVar("awarn3_stats_consolemsg", "1", {FCVAR_ARCHIVE}, "Print AWarn3 stats/version messages in console (1/0)")

-- Whether to send anonymous server stats to the developer endpoint. WARNING: If you disable stat tracking, you may not be eligible to receive support for AWarn3.
-- The information that we log is server name, server ip, current map, gamemode, AWarn3 Version.
-- We collect this data to help prevent leaks as well as to help in the development of new features for AWarn3. Please leave it turned on.
CreateConVar("awarn3_stats_enable", "1", {FCVAR_ARCHIVE}, "Enable AWarn3 stats posting (1/0)")

-- Whether to check for new AWarn3 versions periodically.
CreateConVar("awarn3_versioncheck_enable", "1", {FCVAR_ARCHIVE}, "Enable AWarn3 version check (1/0)")

-- How often (seconds) to post stats. Default: 1800 (30 minutes)
CreateConVar("awarn3_stats_interval", "1800", {FCVAR_ARCHIVE}, "AWarn3 stats post interval in seconds")

-- ─────────────────────────────────────────────────────────────────────────────
-- Locals & constants
-- ─────────────────────────────────────────────────────────────────────────────

local STATS_TIMER     = "awarn3_stats_timer"
local VERSION_TIMER   = "awarn3_version_timer"
local VERSION_ENDPOINT = "https://www.g4p.org/awarn3/version.php"
local STATS_ENDPOINT   = "https://g4p.org/addonstats/post.php"

-- Defensive fallbacks in case theme colors aren’t defined yet
local C_TAG   = _G.AWARN3_SERVER or Color(  0, 180, 255)
local C_TEXT  = _G.AWARN3_WHITE  or Color(255, 255, 255)
local C_WARN  = Color(255,   0,   0)
local C_EMPH  = Color(255, 255,   0)

-- Ensure AWarn namespace
_G.AWarn = _G.AWarn or {}
AWarn.Version = AWarn.Version or "UNKNOWN"

-- ─────────────────────────────────────────────────────────────────────────────
-- Small helpers
-- ─────────────────────────────────────────────────────────────────────────────

local function consoleEnabled()  return GetConVar("awarn3_stats_consolemsg"):GetBool() end
local function statsEnabled()    return GetConVar("awarn3_stats_enable"):GetBool() end
local function versionEnabled()  return GetConVar("awarn3_versioncheck_enable"):GetBool() end
local function statsInterval()   return math.Clamp(GetConVar("awarn3_stats_interval"):GetInt(), 600, 3600) end

local function safeGamemodeName()
    local ok, gm = pcall(gmod.GetGamemode)
    if not ok or not gm then return "UNKNOWN" end
    return gm.Name or "UNKNOWN"
end

local function trim(s)
    if not s then return "" end
    -- Remove BOMs/whitespace/newlines that sometimes appear in remote files
    s = s:gsub("^\239\187\191", "") -- strip UTF-8 BOM if present
    s = s:gsub("%s+$", ""):gsub("^%s+", "")
    return s
end

local function logInfo(...)
    if not consoleEnabled() then return end
    MsgC(C_TAG, "[AWarn3] ", C_TEXT, table.concat({...}), "\n")
end

local function logWarn(...)
    if not consoleEnabled() then return end
    MsgC(C_TAG, "[AWarn3] ", C_WARN, table.concat({...}), "\n")
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Stats posting
-- ─────────────────────────────────────────────────────────────────────────────

local function postStatsOnce()
    if not statsEnabled() then return end

    local payload = {
        hostname      = GetHostName() or "UNKNOWN",
        ipport        = game.GetIPAddress() or "UNKNOWN",
        map           = game.GetMap() or "UNKNOWN",
        gamemode      = safeGamemodeName(),
        addon         = "AWarn3",
        addonversion  = AWarn.Version,
        addoninfo     = "76561199065141602", -- original opaque tag preserved
    }

    http.Post(
        STATS_ENDPOINT,
        payload,
        function(body, len, headers, code)
            -- Keep body available for debugging but don’t spam console with it.
            logInfo("Your server info was posted to AWarn3 statistics.")
        end,
        function(err)
            -- Non-fatal; just note the failure without spamming.
            logWarn("Failed to post AWarn3 statistics (", tostring(err), ").")
        end
    )
end

local function startStatsTimer()
    if timer.Exists(STATS_TIMER) then timer.Remove(STATS_TIMER) end
    if not statsEnabled() then return end
    -- kick once shortly after init, then repeat
    timer.Simple(5, postStatsOnce)
    timer.Create(STATS_TIMER, statsInterval(), 0, postStatsOnce)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Version checking
-- ─────────────────────────────────────────────────────────────────────────────

local function checkVersionOnce()
    if not versionEnabled() then return end

    http.Fetch(
        VERSION_ENDPOINT,
        function(body, length, headers, code)
            local latest = trim(body)
            local current = trim(tostring(AWarn.Version))

            if latest == "" then
                logWarn("Version check responded with empty body.")
                return
            end

            if current == latest then
                logInfo("Your version of AWarn3 is up to date (", current, ").")
                return
            end

            MsgC(C_TAG, "[AWarn3] ", C_WARN, "------------------------------------------------------\n")
            MsgC(C_TAG, "[AWarn3] ", C_TEXT, "Your version of AWarn3 is out of date.\n")
            MsgC(C_TAG, "[AWarn3] ", C_TEXT, "You are running version: ", C_EMPH, current, C_TEXT, ".\n")
            MsgC(C_TAG, "[AWarn3] ", C_TEXT, "The latest version of AWarn3 is: ", C_EMPH, latest, C_TEXT, ".\n")
            MsgC(C_TAG, "[AWarn3] ", C_WARN, "------------------------------------------------------\n")
        end,
        function(message)
            logWarn("Failed to retrieve latest AWarn3 version for version check.")
        end
    )
end

local function startVersionTimer()
    if timer.Exists(VERSION_TIMER) then timer.Remove(VERSION_TIMER) end
    if not versionEnabled() then return end
    -- quick initial check, then re-check every 2 hours
    timer.Simple(5, checkVersionOnce)
    timer.Create(VERSION_TIMER, 7200, 0, checkVersionOnce)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Lifecycle hooks
-- ─────────────────────────────────────────────────────────────────────────────

local function onPostInit()
    startStatsTimer()
    startVersionTimer()
end
hook.Add("InitPostEntity", "awarn3_stats_and_version_boot", onPostInit)

hook.Add("ShutDown", "awarn3_stats_and_version_shutdown", function()
    if timer.Exists(STATS_TIMER)   then timer.Remove(STATS_TIMER)   end
    if timer.Exists(VERSION_TIMER) then timer.Remove(VERSION_TIMER) end
end)

-- Optional: react to admin toggling ConVars at runtime without a map change.
cvars.AddChangeCallback("awarn3_stats_enable", function()     startStatsTimer()   end, "awarn3_stats_enable_cb")
cvars.AddChangeCallback("awarn3_stats_interval", function()   startStatsTimer()   end, "awarn3_stats_interval_cb")
cvars.AddChangeCallback("awarn3_versioncheck_enable", function() startVersionTimer() end, "awarn3_version_enable_cb")
