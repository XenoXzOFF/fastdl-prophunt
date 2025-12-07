--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

----------------------------------------------------------------------
-- Configuration
----------------------------------------------------------------------

-- Set this to true if you wish to enable discord logging. Note: You'll need to provide a webhook URL below as well.
local enable_discord_logging = true

-- Set the Webhook URL for your discord server channel here. To create a webhook:
-- Server Settings > Integrations > View Webhooks > New Webhook > copy Webhook URL.
local discord_webhook_url = "https://discord.com/api/webhooks/1447186182579421322/gpUyK1XCQqGFO6VN5IRgPsaWeIKHOirEficLPkAVFKLBJrgkKZ_HAuqZ3cIs6vzUnlY9"

-- Feel free to keep this using the relay on my server. If you want your own, upload the relay script and change the path here.
local discord_webhook_relay_url = "https://g4p.org/awarn3/discordrelay/discordrelay.php"

----------------------------------------------------------------------
-- Module
----------------------------------------------------------------------

if CLIENT then return end

-- Soft-check globals provided by AWarn3 for colored console output; degrade gracefully if absent.
local cOK       = _G.AWARN3_STATECOLOR or Color(0, 255, 0)
local cWHITE    = _G.AWARN3_WHITE      or Color(255, 255, 255)
local say       = _G.MsgC or print

say(cOK, "[AWarn3] ", cWHITE, "Loading Discord Module (refactored)\n")

-- Defensive guard: ensure AWarn table exists
_G.AWarn = _G.AWarn or {}
local AWarn = _G.AWarn

----------------------------------------------------------------------
-- Small Utilities
----------------------------------------------------------------------

local function nonempty(str)
	return isstring(str) and str ~= "" and str or nil
end

local function getServerName()
	-- Protect against method absence and handle nil/empty returns cleanly
	local name
	if AWarn.GetOption then
		-- NOTE: Use parentheses to avoid '..' having higher precedence than 'or'
		name = AWarn:GetOption("awarn_server_name")
	end
	return nonempty(name) or game.GetIPAddress() or "Unknown Server"
end

local function logLocal(prefix, ok, msg)
	if not msg or msg == "" then return end
	local tag = ok and "OK" or "ERR"
	say(cOK, "[AWarn3] ", cWHITE, ("Discord %s: %s\n"):format(tag, msg))
end

-- Centralized poster with validation and minimal noise
local function postToRelay(payload, onDone)
	if not enable_discord_logging then return end

	-- Validate required bits before posting
	if not nonempty(discord_webhook_relay_url) then
		logLocal("relay", false, "Relay URL missing.")
		return
	end
	if not nonempty(discord_webhook_url) then
		-- Still post to relay if your relay doesn’t strictly require 'url'—but usually it does.
		-- Here we enforce presence to avoid silent failures.
		logLocal("relay", false, "Discord webhook URL missing.")
		return
	end

	-- Inject common payload fields safely
	payload = payload or {}
	payload.url = discord_webhook_url
	payload.title = payload.title or ("AWarn3 - Event on " .. getServerName())

	http.Post(
		discord_webhook_relay_url,
		payload,
		function(res)
			logLocal("relay", true, tostring(res or ""))
			if onDone then onDone(true, res) end
		end,
		function(err)
			logLocal("relay", false, tostring(err or "unknown error"))
			if onDone then onDone(false, err) end
		end
	)
end

-- Normalize player/admin names (works with strings, entities, or nil)
local function nameOf(who)
	if isstring(who) then return who end
	if IsValid(who) and who.GetName then return who:GetName() end
	return tostring(who or "Unknown")
end

----------------------------------------------------------------------
-- Public API
----------------------------------------------------------------------

--: DiscordWarning(warnedPlayerNameOrEnt, adminNameOrEnt, reasonString)
function AWarn:DiscordWarning(pl, adm, reason)
	if not enable_discord_logging then return end

	local payload = {
		log_type        = "warning",
		title           = "AWarn3 - Warning on " .. getServerName(),
		bar_color       = "#FF8C00",
		warned_player   = nameOf(pl),
		warning_admin   = nameOf(adm),
		warning_reason  = tostring(reason or "No reason provided")
	}

	postToRelay(payload)
end

--: DiscordPunishment(playerNameOrEnt, punishmentText, warningsCount)
function AWarn:DiscordPunishment(pl, punishmentText, warnings)
	if not enable_discord_logging then return end

	-- Historically this used a short delay; keep a tiny delay in case other hooks finish up.
	timer.Simple(0.25, function()
		local payload = {
			log_type        = "punishment",
			title           = "AWarn3 - Punishment on " .. getServerName(),
			bar_color       = "#FF0000",
			punished_player = nameOf(pl),
			punishment      = tostring(punishmentText or "Unknown"),
			player_warnings = tostring(warnings or "0")
		}
		postToRelay(payload)
	end)
end

----------------------------------------------------------------------
-- Hooks
----------------------------------------------------------------------

-- When a player entity is warned
hook.Add("AWarnPlayerWarned", "AWarn3.WarningDiscordRelay", function(pl, aID, reason)
	local admin = aID and AWarn.GetPlayerFromID64 and AWarn:GetPlayerFromID64(aID) or nil
	-- Allow logs even if admin couldn’t be resolved to an entity; we’ll pass the id string.
	AWarn:DiscordWarning(pl, IsValid(admin) and admin or tostring(aID or "Unknown Admin"), reason)
end)

-- When an offline/ID target is warned
hook.Add("AWarnPlayerIDWarned", "AWarn3.IDWarningDiscordRelay", function(pID, aID, reason)
	local admin = aID and AWarn.GetPlayerFromID64 and AWarn:GetPlayerFromID64(aID) or nil
	AWarn:DiscordWarning(("ID: %s"):format(tostring(pID or "Unknown")), IsValid(admin) and admin or tostring(aID or "Unknown Admin"), reason)
end)
