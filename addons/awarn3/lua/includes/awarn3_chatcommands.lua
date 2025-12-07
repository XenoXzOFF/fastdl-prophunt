--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

-- Chat Commands Module (refactored)

-- small local helpers to avoid global lookups every call
local lower       = string.lower
local sub         = string.sub
local Trim        = string.Trim
local StartWith   = string.StartWith or function(s, prefix) return sub(s, 1, #prefix) == prefix end
local Explode     = string.Explode
local MsgC        = MsgC

-- safe translation helper
local function L(key, fallback)
	if AWarn and AWarn.Localization and AWarn.Localization.GetTranslation then
		return AWarn.Localization:GetTranslation(key) or (fallback or key)
	end
	return fallback or key
end

-- central logging so we keep color usage consistent
local function logLine(text)
	MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, tostring(text) .. "\n")
end

-- prefix fetch with sane default
local function getPrefix()
	if AWarn and AWarn.GetOption then
		return AWarn:GetOption("awarn_chat_prefix") or "!warn"
	end
	return "!warn"
end

-- fetch command table safely
local function getWarnCommand()
	if not (AWarn and AWarn.GetConCommand) then return nil end
	return AWarn:GetConCommand("warn")
end

-- run permission check defensively
local function hasPermission(pl, cmd)
	if not cmd then return false end
	local check = cmd.permissioncheck
	if type(check) ~= "function" then
		-- if a checker isn’t provided, treat it as denied to be safe
		return false
	end
	return check(pl) and true or false
end

-- lightweight args parser: trims off the prefix and splits on spaces
local function parseArgs(text, prefixLen)
	local tail = Trim(sub(text, prefixLen + 1) or "")
	if tail == "" then return {} end
	-- simple split; if you want quotes later, we can drop in a quote-aware parser here
	return Explode(" ", tail, false)
end

hook.Add("PlayerSay", "AWarn3_PlayerSayChatCommand", function(pl, text, teamChat)
	-- guard: if AWarn core isn’t around, bail and don’t eat the message
	if not AWarn then return end

	local prefix = getPrefix()
	if not prefix or prefix == "" then prefix = "!warn" end

	-- case-insensitive, prefix-only trigger
	if not text or text == "" then return end
	local lt = lower(text)
	local lp = lower(prefix)

	if not StartWith(lt, lp) then return end

	-- we’re handling this, don’t echo to chat
	local cmd = getWarnCommand()
	local args = parseArgs(text, #prefix)

	if #args == 0 then
		-- open menu when called bare, but only if OpenMenu exists
		if AWarn.OpenMenu then
			AWarn:OpenMenu(pl)
		else
			logLine("Menu requested but AWarn:OpenMenu is unavailable.")
		end
		return false
	end

	-- ensure permissions & callable command
	if not hasPermission(pl, cmd) then
		local msg = L("insufficientperms", "You do not have permission to use this command.")
		logLine(msg)
		if AWarn.SendClientMessage then
			AWarn:SendClientMessage(pl, msg)
		end
		return false
	end

	if not (cmd and type(cmd.commandfunction) == "function") then
		logLine("Warn command is not available or misconfigured (no commandfunction).")
		return false
	end

	-- execute the command with parsed args
	cmd.commandfunction(pl, args)
	return false
end)
