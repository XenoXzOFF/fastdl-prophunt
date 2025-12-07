--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

  AWarn3 by Mr.President
]]

-- ── banner / startup ───────────────────────────────────────────────────────────
AWarn.Server = AWarn.Server or "Server 1"

MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "AWarn3 is loading...\n")

-- ── batch includes ─────────────────────────────────────────────────────────────
local serverIncludes = {
  "includes/awarn3_localization.lua",
  "includes/sh_awarn3.lua",
  "includes/awarn3_util.lua",
  "includes/awarn3_options.lua",
  "includes/awarn3_punishments.lua",
  "includes/awarn3_presets.lua",
  "includes/awarn3_permissions.lua",
  "includes/awarn3_blacklists.lua",
  "includes/awarn3_sql.lua",
  "includes/awarn3_concommands.lua",
  "includes/awarn3_chatcommands.lua",
  "includes/awarn3_discordlogging.lua",
  "includes/awarn3_awarn2import.lua",
  "includes/awarn3_stats.lua",
}
for i = 1, #serverIncludes do include(serverIncludes[i]) end

local clientFiles = {
  "includes/cl_awarn3.lua",
  "includes/sh_awarn3.lua",
  "includes/awarn3_concommands.lua",
  "includes/awarn3_permissions.lua",
  "includes/awarn3_vgui.lua",
  "includes/awarn3_easings.lua",
  "includes/awarn3_localization.lua",
  "includes/awarn3_themes.lua",
  "includes/vgui/aw3_menu_configuration_settings.lua",
}
for i = 1, #clientFiles do AddCSLuaFile(clientFiles[i]) end

-- ── resource adds ──────────────────────────────────────────────────────────────
resource.AddWorkshop("1853618226")

do
  local files, _ = file.Find("materials/vgui/awarn3_*.png", "GAME")
  for i = 1, #files do resource.AddSingleFile("materials/vgui/" .. files[i]) end
end
do
  local files, _ = file.Find("materials/vgui/aw3_*.png", "GAME")
  for i = 1, #files do resource.AddSingleFile("materials/vgui/" .. files[i]) end
end

-- ── locals / constants ─────────────────────────────────────────────────────────
local PLAYER = FindMetaTable("Player")

local C_WARN   = Color(255,100,100)
local C_EMPH   = Color(128,255,0)

local net_Start, net_WriteString, net_WriteUInt, net_Broadcast, net_Send, net_WriteEntity =
  net.Start, net.WriteString, net.WriteUInt, net.Broadcast, net.Send, net.WriteEntity
local timer_Create, timer_Adjust, timer_Exists = timer.Create, timer.Adjust, timer.Exists
local os_time = os.time

-- Unique hook IDs to avoid collisions
local HOOK_INIT  = "AWarn3.PlayerInitialSpawn"
local HOOK_LEAVE = "AWarn3.PlayerDisconnected"

-- ── compact chat schema (replaces WriteTable) ──────────────────────────────────
-- Channel: "awarn3_chatmessagecolor"
-- Schema: [count:uint8] then *count* segments of:
--   [tag:uint8] 0=string -> [string]
--               1=color  -> [r:uint8][g:uint8][b:uint8][a:uint8]
local function SendChatSegments(recipient, segments)
  net_Start("awarn3_chatmessagecolor")
  net_WriteUInt(#segments, 8)
  for i = 1, #segments do
    local seg = segments[i]
    if istable(seg) and seg.r then
      net_WriteUInt(1, 8)
      net_WriteUInt(seg.r, 8)
      net_WriteUInt(seg.g, 8)
      net_WriteUInt(seg.b, 8)
      net_WriteUInt(seg.a or 255, 8)
    else
      net_WriteUInt(0, 8)
      net_WriteString(tostring(seg))
    end
  end
  if recipient then net_Send(recipient) else net_Broadcast() end
end

function AWarn:SendChatMessage(mTbl, pl)
  if pl then
    if not IsValid(pl) or not pl:IsPlayer() then return end
    return SendChatSegments(pl, mTbl)
  end
  SendChatSegments(nil, mTbl)
end

-- Keep this simple string pathway (used by some client popups)
function AWarn:SendClientMessage(pl, msgTxt)
  if not IsValid(pl) then return end
  net_Start("awarn3_clientmessage")
  net_WriteString(msgTxt or "")
  net_Send(pl)
end

-- ── normalized join/leave payload ──────────────────────────────────────────────
-- Channel: "awarn3_playerjoinandleave"
-- Payload: [action:string 'join'|'leave'][steamid64:string]
hook.Add("PlayerInitialSpawn", HOOK_INIT, function(pl)
  AWarn:InitialSpawnPlayer(pl)
  timer.Simple(1, function()
    if not IsValid(pl) then return end
    net_Start("awarn3_playerjoinandleave")
    net_WriteString("join")
    net_WriteEntity(pl)
    net_Broadcast()
  end)
end)

hook.Add("PlayerDisconnected", HOOK_LEAVE, function(pl)
  net_Start("awarn3_playerjoinandleave")
  net_WriteString("leave")
  net_WriteString(AWarn:SteamID64(pl))
  net_Broadcast()
end)

-- ── warnings broadcast (unchanged wire format to clients that already listen) ─
function AWarn:BroadcastWarningMessage(PlayerID, AdminID, WarningReason)
  net_Start("awarn3_warningmessage")
  net_WriteString(PlayerID)
  net_WriteString(AdminID)
  net_WriteString(WarningReason)
  net_Broadcast()

  local pl    = AWarn:GetPlayerFromID64(PlayerID)
  local admin = AWarn:GetPlayerFromID64(AdminID)
  local plName    = IsValid(pl) and pl:GetName() or PlayerID
  local adminName = IsValid(admin) and admin:GetName() or AdminID

  MsgC(C_WARN, "[AWarn3] ",
       C_EMPH, plName,
       AWARN3_WHITE, " was warned by ",
       AWARN3_CLIENT, adminName,
       AWARN3_WHITE, " for ",
       C_WARN, WarningReason,
       AWARN3_WHITE, ".\n")
end

-- ── NW2 helpers ────────────────────────────────────────────────────────────────
function AWarn:SetPlayerActiveWarnings(pl, warnings, shouldWrite)
  if not IsValid(pl) then return end
  local w = tonumber(warnings)
  if not w then return end
  pl:SetNW2Int("awarn3_activewarnings", w)
  if shouldWrite then
    self:UpdatePlayerWarnings(AWarn:SteamID64(pl), w)
  end
end

function AWarn:GetPlayerActiveWarnings(pl)
  return IsValid(pl) and pl:GetNW2Int("awarn3_activewarnings", 0) or 0
end

function PLAYER:GetActiveWarnings()
  return AWarn:GetPlayerActiveWarnings(self)
end

-- ── decay timing ───────────────────────────────────────────────────────────────
local function decayTimerName(pl) return "awarn3decaytimer_" .. AWarn:SteamID64(pl) end

function AWarn:CreateDecayTimerModified(pl, dTime)
  if not self:GetOption("awarn_decay") or not IsValid(pl) then return end
  local name = decayTimerName(pl)
  local delay = math.max(1, tonumber(dTime) or 0)

  if timer_Exists(name) then
    timer_Adjust(name, delay, 1)
  else
    timer_Create(name, delay, 1, function()
      if IsValid(pl) then AWarn:TryDecayWarning(pl) end
    end)
  end
end

function AWarn:ResetDecayTimer(pl)
  if not self:GetOption("awarn_decay") or not IsValid(pl) then return end
  local decayrate = (self:GetOption("awarn_decayrate") or 0) * 60
  self:CreateDecayTimerModified(pl, decayrate)
end

function AWarn:InitialSpawnCheckDecay(pl, lastDecayTime)
  if not self:GetOption("awarn_decay") or not IsValid(pl) then return end
  local t = tonumber(lastDecayTime)
  if not t or t == 0 or lastDecayTime == "NULL" then return end

  local now = os_time()
  local nextTick = t + (self:GetOption("awarn_decayrate") or 0) * 60
  if now >= nextTick then
    self:TryDecayWarning(pl)
  else
    self:CreateDecayTimerModified(pl, nextTick - now)
  end
end

function AWarn:TryDecayWarning(pl)
  if not IsValid(pl) or not self:GetOption("awarn_decay") then return end
  local active = self:GetPlayerActiveWarnings(pl) or 0
  if active <= 0 then return end

  self:DecayWarning(AWarn:SteamID64(pl), active - 1)
  if active - 1 > 0 then
    self:ResetDecayTimer(pl)
  end
end

-- ── open menu ──────────────────────────────────────────────────────────────────
function AWarn:OpenMenu(pl)
  if not IsValid(pl) then return end
  net_Start("awarn3_openmenu")
  net_Send(pl)
end

-- ── admin / player join messages ───────────────────────────────────────────────
function AWarn:AlertAdmins(pl, lastwarn, activeWarnings)
  if not self:GetOption("awarn_joinmessageadmin") then return end
  local players = player.GetAll()
  local ts = os.date("%d/%m/%Y - %H:%M:%S", lastwarn or os_time())
  activeWarnings = tonumber(activeWarnings) or 0

  for i = 1, #players do
    local v = players[i]
    if v ~= pl and AWarn:CheckPermission(v, "awarn_view") then
      self:SendChatMessage({ pl, " " .. AWarn.Localization:GetTranslation("joinmessage1") }, v)
      self:SendChatMessage({ AWarn.Localization:GetTranslation("joinmessage2") .. " ", C_WARN, ts }, v)
      if activeWarnings > 0 then
        self:SendChatMessage({ AWarn.Localization:GetTranslation("activewarnings") .. ": ", C_WARN, activeWarnings }, v)
      end
    end
  end
end

function AWarn:WelcomeBackPlayer(pl)
  if not self:GetOption("awarn_joinmessageclient") then return end
  self:SendChatMessage({ AWarn.Localization:GetTranslation("joinmessage3") }, pl)
  self:SendChatMessage({ AWarn.Localization:GetTranslation("joinmessage4") .. " ", C_WARN, AWarn:GetOption("awarn_chat_prefix") }, pl)
end
