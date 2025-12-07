--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

  AWarn3 by Mr.President
  Blacklists Module (refactored)
]]

-- Server-only logic; clients don't need blacklist evaluation or disk I/O
if CLIENT then return end

MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, "Loading Blacklists Module\n")

local FILE_DIR  = "awarn3"
local FILE_PATH = FILE_DIR .. "/blacklists.json"

-- Small, local helpers --------------------------------------------------------
local function log(...)
  MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, ...)
end

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function toboolset(list)
  -- convert {"a","b"} -> { a=true, b=true }
  local set = {}
  if istable(list) then
    for _, v in ipairs(list) do
      if v ~= nil then set[v] = true end
    end
  end
  return set
end

local function set_to_array(settbl)
  local t = {}
  for k in pairs(settbl or {}) do t[#t+1] = k end
  table.sort(t)
  return t
end

-- SteamID normalization:
-- Accepts SteamID ("STEAM_0:X:Y"), SteamID64 ("7656..."), or Player
-- We store *SteamID64* on disk and in memory.
local function normalize_steamid(any)
  if IsValid(any) and any.SteamID64 then
    return any:SteamID64()
  end
  local s = trim(any)
  if s == "" then return nil end
  if #s >= 15 and s:match("^%d+$") then
    -- Looks like a SteamID64 already
    return s
  end
  -- If it's a legacy SteamID, convert
  if s:find("STEAM_") == 1 then
    local sid64 = util.SteamIDTo64(s)
    if sid64 and sid64 ~= "0" then return sid64 end
  end
  return nil
end

-- Groups stored as lower-case keys to be case-insensitive
local function normalize_group(name)
  name = trim(name):lower()
  if name == "" then return nil end
  return name
end

-- Module table ----------------------------------------------------------------
AWarn = AWarn or {}
AWarn.Blacklist = AWarn.Blacklist or {}

local BL = AWarn.Blacklist

-- Internal state (sets for O(1) lookups)
BL._users  = BL._users  or {} -- [steamid64] = true
BL._groups = BL._groups or {} -- [lower_group_name] = true

-- Persistence -----------------------------------------------------------------
function BL:Save()
  if not file.IsDir(FILE_DIR, "DATA") then
    file.CreateDir(FILE_DIR)
  end
  local payload = {
    users  = set_to_array(self._users),
    groups = set_to_array(self._groups),
    _meta  = { version = 1, saved_at = os.time() },
  }
  file.Write(FILE_PATH, util.TableToJSON(payload, true))
  log("Blacklists saved (", tostring(#payload.users), " users, ", tostring(#payload.groups), " groups).\n")
end

function BL:Load()
  if not file.Exists(FILE_PATH, "DATA") then
    -- First run: support migration from legacy globals if present.
    -- The original file had AWarn.UserBlacklist/GroupBlacklist arrays.
    local migrated = false

    if istable(AWarn.UserBlacklist) and #AWarn.UserBlacklist > 0 then
      for _, legacy in ipairs(AWarn.UserBlacklist) do
        local sid64 = normalize_steamid(legacy)
        if sid64 then self._users[sid64] = true end
      end
      migrated = true
    end

    if istable(AWarn.GroupBlacklist) and #AWarn.GroupBlacklist > 0 then
      for _, g in ipairs(AWarn.GroupBlacklist) do
        local gn = normalize_group(g)
        if gn then self._groups[gn] = true end
      end
      migrated = true
    end

    if migrated then
      log("Migrated legacy blacklists to ", FILE_PATH, ".\n")
      self:Save()
    else
      -- Seed with an example to mirror the original file’s intent (optional)
      -- Comment these two lines out to start empty.
      -- self._users[util.SteamIDTo64("STEAM_0:1:123456")] = true
      -- self._groups["testgroup"] = true
      self:Save()
    end
    return
  end

  local ok, decoded = pcall(function()
    return util.JSONToTable(file.Read(FILE_PATH, "DATA") or "{}") or {}
  end)

  if not ok or not istable(decoded) then
    log("Failed to load blacklists; starting empty.\n")
    self._users, self._groups = {}, {}
    self:Save()
    return
  end

  self._users  = toboolset(decoded.users)
  -- ensure group keys are lower-case
  self._groups = {}
  if istable(decoded.groups) then
    for _, g in ipairs(decoded.groups) do
      local gn = normalize_group(g)
      if gn then self._groups[gn] = true end
    end
  end

  log("Blacklists loaded (", tostring(#decoded.users or 0), " users, ", tostring(#decoded.groups or 0), " groups).\n")
end

-- Queries ---------------------------------------------------------------------
function BL:IsUserBlacklisted(plyOrSteam)
  local sid64 = normalize_steamid(plyOrSteam)
  if not sid64 then return false end
  return self._users[sid64] == true
end

function BL:IsGroupBlacklisted(groupName)
  local gn = normalize_group(groupName or "")
  if not gn then return false end
  return self._groups[gn] == true
end

-- Mutators --------------------------------------------------------------------
function BL:AddUser(plyOrSteam)
  local sid64 = normalize_steamid(plyOrSteam)
  if not sid64 then return false, "invalid_steamid" end
  if self._users[sid64] then return false, "already_present" end
  self._users[sid64] = true
  self:Save()
  return true
end

function BL:RemoveUser(plyOrSteam)
  local sid64 = normalize_steamid(plyOrSteam)
  if not sid64 then return false, "invalid_steamid" end
  if not self._users[sid64] then return false, "not_found" end
  self._users[sid64] = nil
  self:Save()
  return true
end

function BL:AddGroup(groupName)
  local gn = normalize_group(groupName)
  if not gn then return false, "invalid_group" end
  if self._groups[gn] then return false, "already_present" end
  self._groups[gn] = true
  self:Save()
  return true
end

function BL:RemoveGroup(groupName)
  local gn = normalize_group(groupName)
  if not gn then return false, "invalid_group" end
  if not self._groups[gn] then return false, "not_found" end
  self._groups[gn] = nil
  self:Save()
  return true
end

-- Pretty exporters (for admin UIs, debugging, etc.)
function BL:GetUsers()  return set_to_array(self._users)  end
function BL:GetGroups() return set_to_array(self._groups) end

-- Integration points ----------------------------------------------------------
-- Central check you can call from your warn-gatekeeping logic:
-- Returns true if the target should be *blocked* from being warned.
function BL:IsTargetBlockedFromWarn(targetPly)
  -- User-level hard block
  if self:IsUserBlacklisted(targetPly) then return true end

  -- Group-level hard block: adapt this to your admin system.
  -- Example: ULX group
  local group = nil
  if IsValid(targetPly) then
    if targetPly.GetUserGroup then
      group = targetPly:GetUserGroup()
    elseif targetPly.GetNWString then
      group = targetPly:GetNWString("usergroup", "")
    end
  end
  if group and self:IsGroupBlacklisted(group) then return true end

  return false
end

-- Console commands ------------------------------------------------------------
-- Admin-only is strongly recommended; here we lightly gate by IsSuperAdmin.

local function isAllowed(ply)
  if IsValid(ply) then
    return ply:IsSuperAdmin()
  end
  -- Server console always allowed
  return true
end

-- Autocomplete helpers
local function ac_users(_, cmd, args)
  local partial = (args[1] or ""):lower()
  local suggestions = {}

  -- Suggest online players first (SteamID64)
  for _, p in ipairs(player.GetAll()) do
    local sid64 = p:SteamID64()
    local name  = p:Nick()
    if sid64:lower():find(partial, 1, true) or name:lower():find(partial, 1, true) then
      suggestions[#suggestions+1] = sid64 .. "  (" .. name .. ")"
    end
  end

  -- Include already-blacklisted SIDs if they match
  for sid64 in pairs(BL._users) do
    if sid64:lower():find(partial, 1, true) then
      suggestions[#suggestions+1] = sid64
    end
  end
  return suggestions
end

local function ac_groups(_, cmd, args)
  local partial = (args[1] or ""):lower()
  local out = {}
  for g in pairs(BL._groups) do
    if g:find(partial, 1, true) then out[#out+1] = g end
  end
  return out
end

concommand.Add("awarn_blacklist_user_add", function(ply, _, args)
  if not isAllowed(ply) then return end
  local ok, err = BL:AddUser(args[1])
  if ok then
    log("Added user to blacklist: ", tostring(normalize_steamid(args[1])), "\n")
  else
    log("Failed to add user: ", tostring(err), "\n")
  end
end, ac_users, "Add a SteamID/SteamID64 to the AWarn blacklist.")

concommand.Add("awarn_blacklist_user_remove", function(ply, _, args)
  if not isAllowed(ply) then return end
  local ok, err = BL:RemoveUser(args[1])
  if ok then
    log("Removed user from blacklist: ", tostring(normalize_steamid(args[1])), "\n")
  else
    log("Failed to remove user: ", tostring(err), "\n")
  end
end, ac_users, "Remove a SteamID/SteamID64 from the AWarn blacklist.")

concommand.Add("awarn_blacklist_group_add", function(ply, _, args)
  if not isAllowed(ply) then return end
  local ok, err = BL:AddGroup(args[1])
  if ok then
    log("Added group to blacklist: ", tostring(normalize_group(args[1])), "\n")
  else
    log("Failed to add group: ", tostring(err), "\n")
  end
end, ac_groups, "Add a group (case-insensitive) to the AWarn blacklist.")

concommand.Add("awarn_blacklist_group_remove", function(ply, _, args)
  if not isAllowed(ply) then return end
  local ok, err = BL:RemoveGroup(args[1])
  if ok then
    log("Removed group from blacklist: ", tostring(normalize_group(args[1])), "\n")
  else
    log("Failed to remove group: ", tostring(err), "\n")
  end
end, ac_groups, "Remove a group from the AWarn blacklist.")

concommand.Add("awarn_blacklist_list", function(ply)
  if not isAllowed(ply) then return end
  local users  = table.concat(BL:GetUsers(),  ", ")
  local groups = table.concat(BL:GetGroups(), ", ")
  log("Blacklisted users: ",  (users ~= "" and users or "(none)"),  "\n")
  log("Blacklisted groups: ", (groups ~= "" and groups or "(none)"), "\n")
end, nil, "Print the current AWarn blacklists.")

-- Boot ------------------------------------------------------------------------
hook.Add("Initialize", "AWarn3_Blacklists_Load", function()
  BL:Load()
end)
