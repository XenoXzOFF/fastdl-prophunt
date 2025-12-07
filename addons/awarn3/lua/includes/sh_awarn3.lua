AddCSLuaFile()

--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

    AWarn3 by Mr.President
    Refactor: utility + player lookup + permission registration
]]

-- ---------- locals for tiny perf wins ----------
local pairs       = pairs
local ipairs      = ipairs
local string_lower= string.lower
local string_find = string.find
local tostring    = tostring
local player_GetAll = player.GetAll

-- Ensure AWarn exists
AWarn = AWarn or {}

-- Basic colors may be defined elsewhere in the addon; fall back safely
local STATE = rawget(_G, "AWARN3_STATECOLOR") or Color(  0, 200, 255)
local WHITE = rawget(_G, "AWARN3_WHITE"     ) or Color(255, 255, 255)
local GREEN = Color(0, 255, 0)

-- ---------- tiny logger helpers ----------
function AWarn:LogState(...)
    MsgC(STATE, "[AWarn3] ", WHITE, ...)
    if select('#', ...) == 0 then MsgC(WHITE, "\n") end
end

function AWarn:LogInfo(...)
    MsgC(GREEN, "[AWarn3] ", WHITE, ...)
    if select('#', ...) == 0 then MsgC(WHITE, "\n") end
end

function AWarn:LogWarn(...)
    MsgC(Color(255, 200, 0), "[AWarn3] ", WHITE, ...)
    if select('#', ...) == 0 then MsgC(WHITE, "\n") end
end

function AWarn:LogError(...)
    MsgC(Color(255, 64, 64), "[AWarn3] ", WHITE, ...)
    if select('#', ...) == 0 then MsgC(WHITE, "\n") end
end

-- ---------- filesystem ----------
function AWarn:CheckDirectory()
    if not file.Exists("awarn3", "DATA") then
        file.CreateDir("awarn3")
    end
end

-- ---------- player identification helpers ----------

-- Returns a stable identifier for a player:
--   - bots: their name (original behavior)
--   - real players: SteamID64
function AWarn:SteamID64(pl)
    if not IsValid(pl) then return nil end
    return pl:IsBot() and pl:GetName() or pl:SteamID64()
end

-- Find a single player by (partial, case-insensitive) name.
-- If exactly one match: returns that Player entity.
-- If 0 or >1 matches: returns nil and logs why.
function AWarn:FindPlayerByName(plName)
    if type(plName) ~= "string" or plName == "" then
        self:LogWarn("FindPlayerByName: invalid search string\n")
        return nil
    end

    local needle = string_lower(plName)
    local matches = {}

    for _, pl in pairs(player_GetAll()) do
        local pname = pl:GetName()
        if pname and string_find(string_lower(pname), needle, 1, true) then
            matches[#matches + 1] = pl
        end
    end

    if #matches == 1 then
        return matches[1]
    elseif #matches > 1 then
        self:LogInfo("Multiple players found for '", plName, "'. Be more specific.\n")
        return nil
    else
        self:LogInfo("No players found for '", plName, "'.\n")
        return nil
    end
end

-- Accepts a player name (partial) or SteamID v2 (STEAM_X:Y:Z) or already a 64-bit string.
-- Returns SteamID64 string when resolvable, otherwise nil.
function AWarn:GetIDFromNameOrSteamID(str)
    if type(str) ~= "string" or str == "" then return nil end

    local s = str:lower()

    -- SteamID v2 format (STEAM_0/1/…)
    if s:sub(1, 6) == "steam_" then
        return util.SteamIDTo64(str)
    end

    -- Already a 64-bit ID (17 digits). We trust but verify length.
    if #s >= 17 and tonumber(str) then
        return str
    end

    -- Otherwise, try a name lookup
    local pl = self:FindPlayerByName(str)
    if pl then
        return self:SteamID64(pl)
    end

    return nil
end

-- Returns a Player by SteamID64 (or bot-name if that identifier was used).
function AWarn:GetPlayerFromID64(id)
    if not id or type(id) ~= "string" then return nil end

    for _, pl in pairs(player_GetAll()) do
        -- Maintain compatibility with bots using name-as-id
        local ident = self:SteamID64(pl)
        if ident == id then
            return pl
        end
    end

    return nil
end

-- ---------- permission registration ----------
-- Expects AWarn.Permissions = {
--   { permissionString = "awarn3.example", description = "Do the thing" },
--   ...
-- }
local function registerCAMI(priv)
    if not CAMI then return end
    CAMI.RegisterPrivilege({
        Name        = priv.permissionString,
        MinAccess   = "superadmin",
        Description = priv.description or "AWarn3 privilege"
    })
end

--[[
local function registerULX(priv)
    if not (ulx and ULib and ULib.ucl and ULib.ucl.registerAccess) then return end
    ULib.ucl.registerAccess(priv.permissionString, ULib.ACCESS_SUPERADMIN, priv.description or "AWarn3 privilege", "AWarn")
end

local function registerSAM(priv)
    if not sam then return end
    sam.permissions.add(priv.permissionString, "AWarn Permissions", "superadmin")
end

local function registerServerGuard(priv)
    if not serverguard or not serverguard.permission or not serverguard.permission.Add then return end
    serverguard.permission:Add(priv.permissionString)
end

local function registerSAdmin(priv)
    if not sAdmin or not sAdmin.registerPermission then return end
    -- sAdmin args: (name, category, defaultAllow, showInMenu)
    sAdmin.registerPermission(priv.permissionString, "AWarn3", false, true)
end
]]

function AWarn:RegisterAdminModPermissions()
    if not self.Permissions or type(self.Permissions) ~= "table" then
        self:LogWarn("Permissions table missing; nothing to register.\n")
        return
    end

    self:LogState("Registering Admin Mod Access Permissions\n")
    
    -- Register with CAMI first (broadest integration)
    for _, priv in pairs(self.Permissions) do
        if priv and priv.permissionString then
            registerCAMI(priv)
        end
    end
    
    --[[
    -- Then mirror into specific admin mods if present
    if SERVER then
        for _, priv in ipairs(self.Permissions) do
            if priv and priv.permissionString then
                registerULX(priv)
                registerServerGuard(priv)
                registerSAdmin(priv)
                registerSAM(priv)
            end
        end
    end
    ]]
end

hook.Add("PostGamemodeLoaded", "AWarn3_RegisterPerms", function()
  -- Defer registration slightly to allow other addons to initialize first.
  timer.Simple(2, function()
      if AWarn and AWarn.RegisterAdminModPermissions then
          AWarn:RegisterAdminModPermissions()
      end
  end)
end)