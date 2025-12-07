AddCSLuaFile()
--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

  AWarn3 by Mr.President
]]

MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, "Loading ConCommands Module\n")

-- =============================================================================
-- Registry + helpers
-- =============================================================================

local Commands = {}
local IS_SERVER = SERVER

local function is_valid_player(p)
  return IsValid(p) and p:IsPlayer()
end

local function tostring_safe(v)
  if v == nil then return "nil" end
  return tostring(v)
end

-- simple state printer (always adds newline)
local function print_state(...)
  MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, ...)
  MsgC(AWARN3_WHITE, "\n")
end

local function notify(pl, parts)
  if IS_SERVER and is_valid_player(pl) and AWarn and AWarn.SendChatMessage then
    AWarn:SendChatMessage(parts, pl)
  else
    MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE)
    for _, seg in ipairs(parts) do
      if istable(seg) and seg.r and seg.g and seg.b then
        MsgC(seg)
      else
        MsgC(AWARN3_WHITE, tostring_safe(seg))
      end
    end
    MsgC(AWARN3_WHITE, "\n")
  end
end

local function T(key)
  local ok = AWarn and AWarn.Localization and AWarn.Localization.GetTranslation
  if ok then return AWarn.Localization:GetTranslation(key) end
  return key
end

local function has_permission(pl, permkey)
  if not IS_SERVER then return true end
  if not (AWarn and AWarn.CheckPermission) then return false end
  return AWarn:CheckPermission(pl, permkey)
end

local function run_command(pl, args)
  args = args or {}
  local sub = args[1]
  if not sub or sub == "" then
    print_state(T("commandnonexist"))
    return
  end

  local cmd = Commands[sub]
  if not cmd then
    print_state(T("commandnonexist"))
    return
  end

  if not cmd.permissioncheck(pl) then
    print_state(T("insufficientperms"))
    return
  end

  local forwarded = {}
  for i = 2, #args do forwarded[#forwarded + 1] = args[i] end

  if (cmd.requiredargs or 0) > #forwarded then
    -- show usage/help (not a perms error)
    MsgC(AWARN3_WARNING, (cmd.help or "") .. "\n")
    return
  end

  local ok, err = xpcall(function()
    cmd.commandfunction(pl, forwarded)
  end, debug.traceback)

  if not ok then
    print_state("Command '", sub, "' failed: ", err or "unknown error")
  end
end

function AWarn:RegisterConCommand(def)
  assert(isstring(def.command) and def.command ~= "", "Command name required")
  def.help = def.help or ""
  def.requiredargs = tonumber(def.requiredargs or 0) or 0
  def.permissioncheck = def.permissioncheck or function() return true end
  assert(isfunction(def.commandfunction), "commandfunction must be a function")
  Commands[def.command] = def
end

function AWarn:GetConCommand(name)
  return Commands[name]
end

local function AutoComplete(cmdName, argsStr)
  -- argsStr is the raw string after "awarn "
  argsStr = argsStr or ""
  local suggestions = {}

  -- split argsStr into tokens (simple split on spaces, preserving partial last token)
  local tokens = {}
  for token in string.gmatch(argsStr, "%S+") do
    tokens[#tokens + 1] = token
  end

  -- helper: quote a value if it has spaces
  local function quoteIfNeeded(s)
    if s:find("%s") then
      -- escape embedded quotes by doubling them
      s = s:gsub('"', '\\"')
      return '"' .. s .. '"'
    end
    return s
  end

  -- No subcommand typed yet → list subcommands
  if #tokens == 0 then
    -- produce "awarn <cmd>"
    local keys = {}
    for k in pairs(Commands) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, k in ipairs(keys) do
      suggestions[#suggestions + 1] = "awarn " .. k
    end
    return suggestions
  end

  -- Partial/complete subcommand in tokens[1]
  local sub = tokens[1]
  local cmd = Commands[sub]

  -- If subcommand isn't exact yet, offer matching subcommands
  if not cmd then
    local subLower = string.lower(sub)
    local keys = {}
    for k in pairs(Commands) do keys[#keys + 1] = k end
    table.sort(keys)
    for _, k in ipairs(keys) do
      if string.find(string.lower(k), "^" .. string.PatternSafe(subLower)) then
        suggestions[#suggestions + 1] = "awarn " .. k
      end
    end
    return suggestions
  end

  -- We have a known subcommand. If it expects a player as first arg, autocomplete players.
  if cmd.firstArgIsPlayer then
    -- figure out what the user has typed so far for the player (2nd token)
    local partial = tokens[2] or ""
    local partialLower = string.lower(partial)

    for _, ply in ipairs(player.GetAll()) do
      local name = ply:Nick()
      local sid  = ply.SteamID and ply:SteamID() or nil
      local sid64 = ply.SteamID64 and ply:SteamID64() or nil

      -- allow matches on name or SteamID / SteamID64 prefix
      local function matches(s)
        if not s then return false end
        return string.find(string.lower(s), "^" .. string.PatternSafe(partialLower)) ~= nil
      end

      if partial == "" or matches(name) then
        local base = "awarn " .. sub .. " "

        -- prefer name completion first
        suggestions[#suggestions + 1] = base .. quoteIfNeeded(name)
      end
    end

    return suggestions
  end

  -- Default: if the command doesn't have player-first autocomplete, just echo the subcommand so users can keep typing
  suggestions[#suggestions + 1] = "awarn " .. sub .. " "
  return suggestions
end


concommand.Add("awarn", function(pl, _, args)
  run_command(pl, args)
end, AutoComplete)

-- =============================================================================
-- Commands
-- =============================================================================

-- warn
AWarn:RegisterConCommand({
  command = "warn",
  help = "Warn a player. Usage :: awarn warn <player name> <reason>",
  requiredargs = 1,
  firstArgIsPlayer = true,
  permissioncheck = function(pl)
    if IS_SERVER then
      return has_permission(pl, "awarn_warn")
    end
    return true
  end,
  commandfunction = function(pl, args)
    local target_pl = AWarn:GetIDFromNameOrSteamID(args[1])

    local reason
    if #args >= 2 then
      reason = table.concat(args, " ", 2)
      if reason == "" then reason = nil end
    end

    if target_pl == "0" then
      print_state(T("invalidtargetid"))
      return
    end
    if target_pl == nil then
      print_state(T("invalidtarget"))
      return
    end

    local reason_required = false
    if AWarn and AWarn.GetOption then
      reason_required = AWarn:GetOption("awarn_reasonrequired") and true or false
    end

    if IS_SERVER then
      if is_valid_player(pl) then
        if (not reason) and reason_required then
          print_state(T("reasonrequired"))
          AWarn:SendChatMessage({ T("reasonrequired") }, pl)
          return
        end
        AWarn:CreateWarningID(target_pl, AWarn:SteamID64(pl), reason)
      else
        if (not reason) and reason_required then
          print_state(T("reasonrequired"))
          return
        end
        AWarn:CreateWarningID(target_pl, "[CONSOLE]", reason)
      end
    else
      -- client
      local sid64 = "[CLIENT]"
      if LocalPlayer then
        local lp = LocalPlayer()
        if lp and lp.IsValid and lp:IsValid() and lp.SteamID64 then
          sid64 = lp:SteamID64()
        end
      end
      AWarn:CreateWarningID(target_pl, sid64, reason)
    end
  end
})

-- removewarn
AWarn:RegisterConCommand({
  command = "removewarn",
  help = "Removes a single active warning. Usage :: awarn removewarn <player name>",
  requiredargs = 1,
  firstArgIsPlayer = true,
  permissioncheck = function(pl)
    if IS_SERVER then
      return has_permission(pl, "awarn_remove")
    end
    return true
  end,
  commandfunction = function(pl, args)
    local target_pl = AWarn:GetIDFromNameOrSteamID(args[1])

    if target_pl == nil then
      print_state(T("invalidtarget"))
      return
    end
    if target_pl == "0" then
      print_state(T("invalidtargetid"))
      return
    end

    if IS_SERVER then
      if is_valid_player(pl) then
        notify(pl, { T("remove1activewarn") .. " ", Color(255, 0, 0), target_pl })
      else
        MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, T("remove1activewarn") .. " ")
        MsgC(Color(255, 0, 0), tostring_safe(target_pl), "\n")
      end
      AWarn:AddActiveWarning(target_pl, -1)
    else
      AWarn:AddActiveWarning(target_pl, -1)
    end
  end
})

-- deletewarnings
AWarn:RegisterConCommand({
  command = "deletewarnings",
  help = "Deletes all warnings. Usage :: awarn deletewarnings <player name>",
  requiredargs = 1,
  firstArgIsPlayer = true,
  permissioncheck = function(pl)
    if IS_SERVER then
      return has_permission(pl, "awarn_delete")
    end
    return true
  end,
  commandfunction = function(pl, args)
    local target_pl = AWarn:GetIDFromNameOrSteamID(args[1])

    if target_pl == nil then
      print_state(T("invalidtarget"))
      return
    end
    if target_pl == "0" then
      print_state(T("invalidtargetid"))
      return
    end

    if IS_SERVER then
      if is_valid_player(pl) then
        notify(pl, { T("removeallwarnings") .. " ", Color(255, 0, 0), target_pl })
      else
        MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, T("removeallwarnings") .. " ")
        MsgC(Color(255, 0, 0), tostring_safe(target_pl), "\n")
      end
      AWarn:DeleteAllPlayerWarnings(target_pl)
    else
      AWarn:DeleteAllPlayerWarnings(target_pl)
    end
  end
})

-- menu
AWarn:RegisterConCommand({
  command = "menu",
  help = "Opens the AWarn3 Menu for viewing warnings.",
  requiredargs = 0,
  permissioncheck = function(_) return true end,
  commandfunction = function(pl, _)
    if IS_SERVER then
      if is_valid_player(pl) then
        AWarn:OpenMenu(pl)
      else
        print_state(T("cantopenconsole"))
      end
    else
      AWarn:OpenMenu()
    end
  end
})

-- resettodefault
AWarn:RegisterConCommand({
  command = "resettodefault",
  help = "Deletes ALL data and resets AWarn3 to factory settings. WARNING: This cannot be undone.",
  requiredargs = 0,
  permissioncheck = function(_) return true end,
  commandfunction = function(pl, _)
    if IS_SERVER then
      if is_valid_player(pl) then
        if pl.IsListenServerHost and pl:IsListenServerHost() then
          AWarn:ResetToDefaults()
        else
          print_state("This can only be run on the server console.")
        end
      else
        AWarn:ResetToDefaults()
      end
    else
      print_state("This can only be run on the server console.")
    end
  end
})
