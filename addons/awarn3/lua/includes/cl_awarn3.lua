--==============================================================
--  AWarn3 (Client) — Refactored for readability & resilience
--  Notes:
--   • Fewer globals, more locals
--   • Safer net reads, defensive checks
--   • DRY'ed chat/translation helpers
--   • Compact, documented structure
--==============================================================

AddCSLuaFile()

--[[ Banner
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 
    AWarn3 by Mr.President
]]

----------------------------------------------------------------
-- Locals / Upvalues (avoid global lookups in hot paths)
----------------------------------------------------------------
local chat_AddText      = chat.AddText
local Color             = Color
local file_Exists       = file.Exists
local file_Read         = file.Read
local file_Write        = file.Write
local http_Fetch        = http.Fetch
local IsValid           = IsValid
local LocalPlayer       = LocalPlayer
local net_ReadString    = net.ReadString
local net_ReadUInt      = net.ReadUInt
local net_Start         = net.Start
local net_WriteInt      = net.WriteInt
local net_WriteString   = net.WriteString
local net_SendToServer  = net.SendToServer
local string_Trim       = string.Trim
local table_unpack      = table.unpack
local timer_Simple      = timer.Simple
local util_JSONToTable  = util.JSONToTable
local util_TableToJSON  = util.TableToJSON
local hook_Add          = hook.Add
local file_CreateDir      = file.CreateDir
local unpack_safe         = unpack or table and table.unpack

-- Respect existing globals, ensure table exists
AWarn = AWarn or {}

----------------------------------------------------------------
-- Constants
----------------------------------------------------------------
local CONFIG_VERSION   = 3
local CONFIG_DIR       = "awarn3"
local CONFIG_FILEPATH  = CONFIG_DIR .. "/client_configuration.txt"
local VERSION_URL      = "https://www.g4p.org/awarn3/version.php"

-- Shared colors (fallbacks in case theme not loaded yet)
local COL_PREFIX   = AWARN3_CLIENT or Color(  64, 200, 255 )
local COL_TEXT     = AWARN3_WHITE  or Color( 255, 255, 255 )
local COL_WARNING  = AWARN3_WARNING or Color( 255, 180,  64 )

-- Small color cache for tag decoding
local CACHED = {
  TARGET = Color(128,255,0),
  ADMIN  = Color(128,255,0)
}

----------------------------------------------------------------
-- Bootstrap logging
----------------------------------------------------------------
chat_AddText(COL_PREFIX, "[AWarn3] ", COL_TEXT, "AWarn3 is loading...\n")

----------------------------------------------------------------
-- Includes (kept as-is, but grouped)
----------------------------------------------------------------
include("includes/awarn3_localization.lua")
include("includes/sh_awarn3.lua")
include("includes/awarn3_concommands.lua")
include("includes/awarn3_permissions.lua")
include("includes/awarn3_vgui.lua")
include("includes/awarn3_themes.lua")

----------------------------------------------------------------
-- Helper: safe chat print (guards empty payloads)
----------------------------------------------------------------
local function SafeChatAddText(...)
  local n = select("#", ...)
  if n == 0 then return end
  chat_AddText(...)
end

----------------------------------------------------------------
-- Helper: localized format with fallback
-- key:  localization key
-- ... : string.format args
----------------------------------------------------------------
local function LFmt(key, ...)
  local loc = AWarn.Localization
  if not loc or not loc.GetTranslation then return key end
  local tmpl = loc:GetTranslation(key)
  if type(tmpl) ~= "string" or tmpl == "" then return key end
  local ok, out = pcall(string.format, tmpl, ...)
  return ok and out or tmpl
end

----------------------------------------------------------------
-- Networking: plain client message
----------------------------------------------------------------
net.Receive("awarn3_clientmessage", function()
  local message = net_ReadString() or ""
  if message == "" then return end
  SafeChatAddText(COL_WARNING, "[AWarn3] ", COL_TEXT, message)
end)

----------------------------------------------------------------
-- Helper: resolve SteamID64 → player name (fallback to id)
----------------------------------------------------------------
local function ResolveNameFromID64(id64)
  if not id64 or id64 == "" then return "N/A" end
  local pl = AWarn.GetPlayerFromID64 and AWarn:GetPlayerFromID64(id64)
  return IsValid(pl) and pl:GetName() or id64
end

----------------------------------------------------------------
-- Networking: warning message routing
-- Expects: PlayerID, AdminID, Reason
----------------------------------------------------------------
net.Receive("awarn3_warningmessage", function()
  local playerID      = net_ReadString() or ""
  local adminID       = net_ReadString() or ""
  local warningReason = net_ReadString() or ""

  local lp       = LocalPlayer()
  local plName   = ResolveNameFromID64(playerID)
  local admName  = ResolveNameFromID64(adminID)
  local noReason = (warningReason == "NONE GIVEN")

  -- Same player helper
  local function isLP(id64)
    if not lp or not IsValid(lp) then return false end
    return (lp:SteamID64() == id64)
  end

  local msg
  if isLP(playerID) then
    msg = noReason and LFmt("warnmessage4", admName)
                   or  LFmt("warnmessage1", admName, warningReason)

  elseif isLP(adminID) then
    msg = noReason and LFmt("warnmessage5", plName)
                   or  LFmt("warnmessage2", plName, warningReason)

  else
    msg = noReason and LFmt("warnmessage6", plName, admName)
                   or  LFmt("warnmessage3", plName, admName, warningReason)
  end

  SafeChatAddText(COL_WARNING, "[AWarn3] ", COL_TEXT, msg)
end)

----------------------------------------------------------------
-- Networking: compact colored chat stream
-- Protocol:
--   count: u8
--   repeated (count):
--     tag: u8  (1=Color, else=String)
--       if Color: r,g,b,a   (each u8)
--       else String: net.ReadString()
----------------------------------------------------------------
net.Receive("awarn3_chatmessagecolor", function()
  local count = net_ReadUInt(8) or 0
  if count <= 0 or count > 64 then return end  -- sanity cap

  local out = {}
  for i = 1, count do
    local tag = net_ReadUInt(8) or 0
    if tag == 1 then
      local r = net_ReadUInt(8) or 255
      local g = net_ReadUInt(8) or 255
      local b = net_ReadUInt(8) or 255
      local a = net_ReadUInt(8) or 255
      out[#out + 1] = Color(r, g, b, a)
    else
      local s = net_ReadString() or ""
      if s ~= "" then
        out[#out + 1] = s
      end
    end
  end

  if #out > 0 then
    SafeChatAddText(unpack_safe(out))
  end
end)

----------------------------------------------------------------
-- Networking: normalized join/leave notice
----------------------------------------------------------------
net.Receive("awarn3_playerjoinandleave", function()
  local action  = net_ReadString() or ""  -- "join" | "leave"
  local steamID = net_ReadString() or ""
  -- Hook point for UI/logic; intentionally quiet here.
  -- Example:
  -- surface.PlaySound(action == "join" and "buttons/button14.wav" or "buttons/button19.wav")
end)

----------------------------------------------------------------
-- Client → Server RPCs
----------------------------------------------------------------
function AWarn:CreateWarningID(target_id, admin_id, reason)
  if not target_id or not admin_id then return end
  net_Start("awarn3_createwarningid")
    net_WriteString(target_id)
    net_WriteString(admin_id)
    net_WriteString(reason or "")
  net_SendToServer()
end

function AWarn:SavePlayerNotes(target_id, notes)
  if not target_id then return end
  net_Start("awarn3_updateplayernotes")
    net_WriteString(target_id)
    net_WriteString(notes or "")
  net_SendToServer()
end

function AWarn:RequestNotes(target_id)
  if not target_id then return end
  net_Start("awarn3_notesrequest")
    net_WriteString(target_id)
  net_SendToServer()
end

function AWarn:AddActiveWarning(target_id, amt)
  if not target_id then return end
  net_Start("awarn3_addactivewarning")
    net_WriteString(target_id)
    net_WriteInt(tonumber(amt) or 0, 8)
  net_SendToServer()
end

function AWarn:DeleteAllPlayerWarnings(target_pl)
  if not target_pl then return end
  net_Start("awarn3_deleteallplayerwarnings")
    net_WriteString(target_pl)
  net_SendToServer()
end

----------------------------------------------------------------
-- Networked warning getter (sugar on Player metatable)
----------------------------------------------------------------
local PLAYER = FindMetaTable("Player")
function AWarn:GetPlayerActiveWarnings(pl)
  if not IsValid(pl) then return 0 end
  return pl:GetNW2Int("awarn3_activewarnings", 0)
end

function PLAYER:GetActiveWarnings()
  return AWarn:GetPlayerActiveWarnings(self)
end

----------------------------------------------------------------
-- Client settings load/save (defensive, versioned)
----------------------------------------------------------------
function AWarn:CheckDirectory()
  if not file_Exists(CONFIG_DIR, "DATA") then
    file_CreateDir(CONFIG_DIR)
  end
end

function AWarn:SaveClientSettings()
  self:CheckDirectory()
  local cfg = {
    Colors  = self.Colors,
    Version = CONFIG_VERSION
  }
  file_Write(CONFIG_FILEPATH, util_TableToJSON(cfg, true))
end

function AWarn:LoadClientSettings()
  if not file_Exists(CONFIG_FILEPATH, "DATA") then
    self:SaveClientSettings()
    return
  end

  local raw = file_Read(CONFIG_FILEPATH, "DATA")
  if not raw or raw == "" then
    self:SaveClientSettings()
    return
  end

  local ok, cfg = pcall(util_JSONToTable, raw)
  if not ok or type(cfg) ~= "table" then
    self:SaveClientSettings()
    return
  end

  if (cfg.Version or 0) < CONFIG_VERSION then
    self:SaveClientSettings()
    return
  end

  if cfg.Colors then
    self.Colors = cfg.Colors
  end
end

----------------------------------------------------------------
-- Remote version check (quiet failure, trims whitespace)
----------------------------------------------------------------
AWarn.Outdated = false

local function AWarn3_Version_Check_CL()
  http_Fetch(
    VERSION_URL,
    function(body)
      if type(body) ~= "string" then return end
      local latest  = string_Trim(body or "")
      local current = string_Trim(tostring(AWarn.Version or ""))
      if latest ~= "" and current ~= "" and latest ~= current then
        AWarn.Outdated = true
      end
    end,
    function()
      -- Silent is golden; keep console log sparse & themed
      chat_AddText(COL_PREFIX, "[AWarn3] ", COL_TEXT, "Failed to retrieve latest version for version check.\n")
    end
  )
end

local function AWarn3_Stats_TimerStart()
  timer_Simple(5, AWarn3_Version_Check_CL)
end

hook_Add("InitPostEntity", "awarn3_version_check_cl", AWarn3_Stats_TimerStart)

----------------------------------------------------------------
-- Init
----------------------------------------------------------------
AWarn:LoadClientSettings()
