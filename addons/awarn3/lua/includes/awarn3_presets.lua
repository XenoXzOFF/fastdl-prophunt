--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

    AWarn3 by Mr.President
]]

-- Server-only module.
if CLIENT then return end

MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Loading Presets Module\n")

-- ---------------------------------------------------------------------------
-- Constants / locals
-- ---------------------------------------------------------------------------
local FILE_PATH   = "awarn3/presets.txt"
local NET_PRESETS = "awarn3_networkpresets"

-- In case this net string isn't already added elsewhere.
if not util.NetworkIDToString or not util.NetworkStringToID or util.NetworkStringToID(NET_PRESETS) == 0 then
    util.AddNetworkString(NET_PRESETS)
end

AWarn.Presets = AWarn.Presets or {}  -- map: [presetName] = { pName = string, pReason = string }

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

local function is_string(v) return type(v) == "string" end
local function is_table(v)  return type(v) == "table"  end

--- Returns a shallow copy of a table (non-recursive).
local function shallow_copy(tbl)
    local out = {}
    for k, v in pairs(tbl) do out[k] = v end
    return out
end

--- Basic sanitation for a single preset table.
--- Returns sanitized {pName=..., pReason=...} or nil if invalid.
local function sanitize_preset(tbl)
    if not is_table(tbl) then return nil end
    local name   = tbl.pName
    local reason = tbl.pReason

    if not is_string(name) or name == "" then return nil end
    if not is_string(reason) then reason = "" end

    -- Trim leading/trailing whitespace (cheap trim).
    name   = name:match("^%s*(.-)%s*$")
    reason = reason:match("^%s*(.-)%s*$")

    if name == "" then return nil end
    return { pName = name, pReason = reason }
end

--- Validates and returns a sanitized presets map.
local function sanitize_preset_map(maybeMap)
    if not is_table(maybeMap) then return nil end
    local clean = {}

    for k, v in pairs(maybeMap) do
        -- Accept either keyed map [pName] = preset or array entries
        local preset = sanitize_preset(v)
        if not preset and is_table(k) then
            preset = sanitize_preset(k) -- ultra-defensive; ignore if weird
        end
        if preset then
            clean[preset.pName] = preset
        end
    end

    return clean
end

-- ---------------------------------------------------------------------------
-- Public API
-- ---------------------------------------------------------------------------

--- Register or update a single preset.
function AWarn:RegisterPreset(pTbl)
    local preset = sanitize_preset(pTbl)
    if not preset then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Refused to register invalid preset.\n")
        return false
    end
    self.Presets[preset.pName] = preset
    return true
end

--- Get a preset by name, or nil.
function AWarn:GetPreset(pName)
    if not is_string(pName) or pName == "" then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "No preset name provided.\n")
        return nil
    end

    local p = self.Presets[pName]
    if not p then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "No preset with this name.\n")
        return nil
    end
    return p
end

--- Optional: get all presets as a shallow copy (prevents accidental mutation).
function AWarn:GetAllPresets()
    return shallow_copy(self.Presets)
end

--- Persist current presets to disk.
function AWarn:SavePresets()
    self:CheckDirectory()  -- defined elsewhere in your codebase
    local ok, encoded = pcall(util.TableToJSON, self.Presets, true)
    if not ok or not is_string(encoded) then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Failed to encode presets JSON; not saving.\n")
        return false
    end
    file.Write(FILE_PATH, encoded)
    return true
end

--- Load presets from disk (safe against missing or corrupt files).
function AWarn:LoadPresets()
    if not file.Exists(FILE_PATH, "DATA") then
        -- Seed file from current in-memory presets (or defaults below).
        self:SavePresets()
        return true
    end

    local raw = file.Read(FILE_PATH, "DATA")
    if not is_string(raw) or raw == "" then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Preset file empty; keeping current presets.\n")
        return false
    end

    local ok, decoded = pcall(util.JSONToTable, raw)
    if not ok or not is_table(decoded) then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Corrupt preset file; keeping current presets.\n")
        return false
    end

    local clean = sanitize_preset_map(decoded)
    if not clean then
        MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Invalid preset structure; keeping current presets.\n")
        return false
    end

    self.Presets = clean
    MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Presets Loaded\n")
    return true
end

--- Send presets to one player or broadcast to everyone.
function AWarn:SendPresetsToPlayer(pl)
    net.Start(NET_PRESETS)
    net.WriteTable(self.Presets)

    if IsValid(pl) then
        net.Send(pl)
    else
        net.Broadcast()
    end
end

-- ---------------------------------------------------------------------------
-- Networking
-- ---------------------------------------------------------------------------

net.Receive(NET_PRESETS, function(_, pl)
    if not IsValid(pl) then return end

    local requestType = net.ReadString()

    if requestType == "update" then
        if not AWarn:CheckPermission(pl, "awarn_warn") then return end
        AWarn:SendPresetsToPlayer(pl)

    elseif requestType == "write" then
        if not AWarn:CheckPermission(pl, "awarn_options") then return end

        local incoming = net.ReadTable()
        local clean = sanitize_preset_map(incoming)

        if not clean then
            -- Don’t overwrite on bad input
            MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Rejected invalid preset map from client.\n")
            return
        end

        AWarn.Presets = clean
        AWarn:SavePresets()
        -- Acknowledge by sending back the authoritative version
        AWarn:SendPresetsToPlayer(pl)
    end
end)

-- ---------------------------------------------------------------------------
-- Defaults (registered only if they aren't already present on disk)
-- ---------------------------------------------------------------------------

-- Seed a few defaults in-memory first (only used if no valid file exists).
local defaults = {
    { pName = "RDM",             pReason = "Killing random players for no reason." },
    { pName = "OOC",             pReason = "Using OOC chat in the main chat." },
    { pName = "Disobeying Staff",pReason = "Not following the instructions of staff members." },
}

for _, preset in ipairs(defaults) do AWarn:RegisterPreset(preset) end

-- Load file (will overwrite with disk version if present & valid).
AWarn:LoadPresets()
