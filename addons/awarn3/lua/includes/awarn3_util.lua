--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

-- Utilities Module (server-side)
-- Refactored for clarity, safety, and reduced global pollution

-- Guard: this file is server-only by design
if CLIENT then return end

-- Optional: pretty boot message if constants exist
if MsgC and AWARN3_STATECOLOR and AWARN3_WHITE then
    MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, "Loading Utilities Module (refactor)\n")
end

-- 1) Network strings
-- Keep the registry in a single place and register in a loop to avoid typos
local NET_STRINGS = {
    -- Chat / notifications
    "awarn3_clientmessage",
    "awarn3_warningmessage",
    "awarn3_chatmessagecolor",

    -- Warnings CRUD
    "awarn3_createwarningid",
    "awarn3_addactivewarning",
    "awarn3_deleteallplayerwarnings",
    "awarn3_deletesinglewarning",

    -- Notes
    "awarn3_updateplayernotes",
    "awarn3_notesrequest",

    -- Queries / views
    "awarn3_requestplayerwarnings",
    "awarn3_requestplayersearchdata",
    "awarn3_requestownwarnings",
    "awarn3_openmenu",

    -- Join/leave feed
    "awarn3_playerjoinandleave",

    -- Options / data models
    "awarn3_networkoptions",
    "awarn3_networkpunishments",
    "awarn3_networkpresets",
}

local function RegisterNetworkStrings()
    for _, id in ipairs(NET_STRINGS) do
        util.AddNetworkString(id)
    end
end

-- Call immediately in case this file loads post-Initialize
RegisterNetworkStrings()

-- Additionally ensure registration on Initialize (harmless if already done)
hook.Add("Initialize", "awarn3_register_netstrings", RegisterNetworkStrings)

-- 2) Player helpers
local PLAYER = FindMetaTable("Player")

--- Returns a sensible team color for this player, with robust fallbacks.
-- @return Color
function PLAYER:GetTeamColor()
    -- Ensure we have a valid team id
    local tid = (self.Team and self:Team()) or nil

    -- team.GetColor is safe if tid is a valid team id; otherwise fallback
    local col = (tid and team.GetColor and team.GetColor(tid))

    -- Some servers set PlayerColor (Vector 0-1). Convert if present
    if not col and self.GetPlayerColor then
        local v = self:GetPlayerColor() -- Vector r,g,b in 0-1 range
        if isvector(v) then
            col = Color(math.floor(v.x * 255), math.floor(v.y * 255), math.floor(v.z * 255))
        end
    end

    -- Final fallback to white
    return col or color_white or Color(255, 255, 255)
end

-- 3) Small sanity utility (optional)
-- Often useful when sending networked messages to a single, valid player
local function IsLivePlayer(ply)
    return IsValid(ply) and ply:IsPlayer()
end

