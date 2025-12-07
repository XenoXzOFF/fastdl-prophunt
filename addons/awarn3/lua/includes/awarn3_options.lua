--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Loading Options Module\n" )


AWarn.Options = {}AddCSLuaFile()
--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Loading Options Module\n")

AWarn.Options = AWarn.Options or {}

-- ────────────────────────────────────────────────────────────────────────────────
-- Local helpers
-- ────────────────────────────────────────────────────────────────────────────────

local VALID_TYPES = {
	boolean = true,
	integer = true,
	string  = true
}

local function _coerceByType(expectedType, value)
	if expectedType == "boolean" then
		return tobool(value)
	elseif expectedType == "integer" then
		return tonumber(value) or 0
	elseif expectedType == "string" then
		return tostring(value or "")
	end
	return nil
end

local function _optionExists(name)
	return name and AWarn.Options[name] ~= nil
end

local function _optionType(name)
	return _optionExists(name) and AWarn.Options[name].type or nil
end

local function _logInvalidOption()
	MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation("invalidoption") .. "\n")
end

local function _logInvalidValueType()
	MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation("invalidoptionvaluetype") .. "\n")
end

-- ────────────────────────────────────────────────────────────────────────────────
-- Registration & accessors
-- ────────────────────────────────────────────────────────────────────────────────

function AWarn:RegisterOption(oTbl)
	-- Expected schema: { name = string, value = any, type = "boolean"|"integer"|"string", description = string }
	if not oTbl or type(oTbl) ~= "table" or type(oTbl.name) ~= "string" then return end

	-- Validate type
	if not VALID_TYPES[oTbl.type] then
		_logInvalidValueType()
		return
	end

	-- Coerce the default value to the declared type for consistency
	oTbl.value = _coerceByType(oTbl.type, oTbl.value)

	AWarn.Options[oTbl.name] = {
		name        = oTbl.name,
		value       = oTbl.value,
		type        = oTbl.type,
		description = oTbl.description or ""
	}
end

function AWarn:GetOption(op)
	if not _optionExists(op) then
		_logInvalidOption()
		return nil
	end
	return AWarn.Options[op].value
end

function AWarn:SetOption(op, value)
	if not _optionExists(op) then
		_logInvalidOption()
		return nil
	end

	local oType = _optionType(op)
	if not VALID_TYPES[oType] then
		_logInvalidValueType()
		return
	end

	local coerced = _coerceByType(oType, value)
	if coerced == nil then
		_logInvalidValueType()
		return
	end

	AWarn.Options[op].value = coerced
	AWarn:SaveOptions()
	AWarn:SendOptionsToClient(nil)
end

-- ────────────────────────────────────────────────────────────────────────────────
-- Persistence
-- ────────────────────────────────────────────────────────────────────────────────

function AWarn:SaveOptions()
	if not self.CheckDirectory then return end
	self:CheckDirectory()

	-- Only persist the table as-is (names map to typed entries)
	file.Write("awarn3/options.txt", util.TableToJSON(self.Options, true))
end

function AWarn:LoadOptions()
	if not file.Exists("awarn3/options.txt", "DATA") then
		self:SaveOptions()
		return
	end

	local ok, raw = pcall(file.Read, "awarn3/options.txt", "DATA")
	if not ok or not raw or raw == "" then
		self:SaveOptions()
		return
	end

	local parsed = util.JSONToTable(raw)
	if type(parsed) ~= "table" then
		self:SaveOptions()
		return
	end

	-- Merge by key; only update existing options so removed/unknown keys are ignored gracefully
	for k, v in pairs(parsed) do
		if self.Options[k] and type(v) == "table" then
			-- Keep the original type and description; coerce incoming value to the existing type
			local t = self.Options[k].type
			self.Options[k].value = _coerceByType(t, v.value)
		end
	end

	MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation("optionsloaded") .. "\n")
end

-- ────────────────────────────────────────────────────────────────────────────────
-- Networking (server)
-- ────────────────────────────────────────────────────────────────────────────────

if SERVER then
	util.AddNetworkString("awarn3_networkoptions")

	function AWarn:SendOptionsToClient(pl)
		net.Start("awarn3_networkoptions")
		net.WriteTable(AWarn.Options)
		if IsValid(pl) then
			net.Send(pl)
		else
			net.Broadcast()
		end
	end

	function AWarn:SendNoOptionsToClient(pl)
		net.Start("awarn3_networkoptions")
		net.WriteTable({})
		if IsValid(pl) then net.Send(pl) end
	end

	net.Receive("awarn3_networkoptions", function(_, pl)
		-- Only staff with any of these perms can pull/update options
		if not (AWarn:CheckPermission(pl, "awarn_options")
			or AWarn:CheckPermission(pl, "awarn_remove")
			or AWarn:CheckPermission(pl, "awarn_delete")) then
			AWarn:SendNoOptionsToClient(pl)
			return
		end

		local requestType = net.ReadString()
		if requestType == "update" then
			AWarn:SendOptionsToClient(pl)
			return
		end

		if requestType == "write" then
			local option = net.ReadString()
			if not _optionExists(option) then
				_logInvalidOption()
				return
			end

			local oType = _optionType(option)
			local incoming
			if oType == "boolean" then
				incoming = net.ReadBool()
			elseif oType == "integer" then
				incoming = net.ReadInt(32)
			elseif oType == "string" then
				incoming = net.ReadString()
			else
				_logInvalidValueType()
				return
			end

			AWarn:SetOption(option, incoming)
		end
	end)
end

-- ────────────────────────────────────────────────────────────────────────────────
-- Default option registration
-- ────────────────────────────────────────────────────────────────────────────────

do
	local defaults = {
		{
			name = "awarn_kick",
			value = true,
			type = "boolean",
			description = "Allow AWarn to kick players."
		},
		{
			name = "awarn_ban",
			value = true,
			type = "boolean",
			description = "Allow AWarn to ban players"
		},
		{
			name = "awarn_decay",
			value = true,
			type = "boolean",
			description = "If enabled, active warnings will decay over time."
		},
		{
			name = "awarn_reasonrequired",
			value = true,
			type = "boolean",
			description = "If enabled, a warning must be provided when warning a player."
		},
		{
			name = "awarn_decayrate",
			value = 30,
			type = "integer",
			description = "How often (in minutes) an active warning decays for a player."
		},
		{
			name = "awarn_reset_after_ban",
			value = false,
			type = "boolean",
			description = "If enabled, a player's active warnings will be reset to 0 after being banned by awarn. Recommend disabled if using multiple levels of banning."
		},
		{
			name = "awarn_logging",
			value = true,
			type = "boolean",
			description = "If enabled, AWarn will log actions to a data file."
		},
		{
			name = "awarn_joinmessageclient",
			value = true,
			type = "boolean",
			description = "If enabled, players who join will see if they have any warnings on the server."
		},
		{
			name = "awarn_joinmessageadmin",
			value = true,
			type = "boolean",
			description = "If enabled, admins will get a message in chat when a player with warnings joins the server."
		},
		{
			name = "awarn_removewhendeletewarning",
			value = false,
			type = "boolean",
			description = "If enabled, 1 active warning will be removed form a player when a warning is deleted."
		},
		{
			name = "awarn_allow_warn_admins",
			value = true,
			type = "boolean",
			description = "If enabled, admins will be able to warn other admins."
		},
		{
			name = "awarn_chat_prefix",
			value = "!warn",
			type = "string",
			description = "Chat command to warn players and open the warning menu."
		},
		{
			name = "awarn_server_language",
			value = AWarn.DefaultLanguage,
			type = "string",
			description = "Language all server messages will be in."
		},
		{
			name = "awarn_server_name",
			value = "Server 1",
			type = "string",
			description = "Server name for multi-server support"
		},
	}

	for _, opt in ipairs(defaults) do
		AWarn:RegisterOption(opt)
	end
end

-- Load persisted values (coerced into the current schema)
AWarn:LoadOptions()


function AWarn:RegisterOption( oTbl )
	AWarn.Options[ oTbl.name ] = oTbl
end

function AWarn:GetOption( op )
	if not AWarn.Options[ op ] then
		MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation( "invalidoption" ) .. "\n" )
		return nil
	end
	return AWarn.Options[ op ].value
end

function AWarn:SetOption( op, value )
	if not AWarn.Options[ op ] then
		MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation( "invalidoption" ) .. "\n" )
		return nil
	end
	if AWarn.Options[ op ].type == "boolean" then
		AWarn.Options[ op ].value = tobool( value )
	elseif AWarn.Options[ op ].type == "integer" then
		AWarn.Options[ op ].value = tonumber( value )
	elseif AWarn.Options[ op ].type == "string" then
		AWarn.Options[ op ].value = tostring( value )
	else
		MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation( "invalidoptionvaluetype" ) .. "\n" )
		return
	end
	AWarn:SaveOptions()
	AWarn:SendOptionsToClient( nil )
end

function AWarn:SaveOptions()
	self:CheckDirectory()
	file.Write( "awarn3/options.txt", util.TableToJSON( self.Options, true ) )
end

function AWarn:LoadOptions()
	if file.Exists( "awarn3/options.txt", "DATA" ) then
		loaded_options = util.JSONToTable( file.Read( "awarn3/options.txt", "DATA" ) )
		for k, v in pairs( loaded_options ) do
			if self.Options[k] then
				self.Options[k] = v
			end
		end
		MsgC( AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, AWarn.Localization:GetTranslation( "optionsloaded" ) .. "\n" )
	else
		self:SaveOptions()
	end
end

function AWarn:SendOptionsToClient( pl )
	net.Start( "awarn3_networkoptions" )
	net.WriteTable( AWarn.Options )
	if IsValid( pl ) then
		net.Send( pl )
	else
		net.Broadcast()
	end
end

function AWarn:SendNoOptionsToClient( pl )
	net.Start( "awarn3_networkoptions" )
	net.WriteTable( {} )
	if IsValid( pl ) then
		net.Send( pl )
	end
end

net.Receive( "awarn3_networkoptions", function( len, pl )
	if AWarn:CheckPermission( pl, "awarn_options" ) or AWarn:CheckPermission( pl, "awarn_remove" ) or AWarn:CheckPermission( pl, "awarn_delete" ) then
	
		local requestType = net.ReadString()
		
		if requestType == "update" then
		
			AWarn:SendOptionsToClient( pl )
			
		elseif requestType == "write" then
			
			local option = net.ReadString()
			local oValue = nil
			
			if AWarn.Options[option].type == "boolean" then
				oValue = net.ReadBool()
			elseif AWarn.Options[option].type == "integer" then
				oValue = net.ReadInt( 32 )
			elseif AWarn.Options[option].type == "string" then
				oValue = net.ReadString()
			end
			
			AWarn:SetOption( option, oValue )
		
		end
	else
		AWarn:SendNoOptionsToClient( pl )
	end
end )


local OP = {}
OP.name = "awarn_kick"
OP.value = true
OP.type = "boolean"
OP.description = "Allow AWarn to kick players."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_ban"
OP.value = true
OP.type = "boolean"
OP.description = "Allow AWarn to ban players"
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_decay"
OP.value = true
OP.type = "boolean"
OP.description = "If enabled, active warnings will decay over time."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_reasonrequired"
OP.value = true
OP.type = "boolean"
OP.description = "If enabled, a warning must be provided when warning a player."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_decayrate"
OP.value = 30
OP.type = "integer"
OP.description = "How often (in minutes) an active warning decays for a player."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_reset_after_ban"
OP.value = false
OP.type = "boolean"
OP.description = "If enabled, a player's active warnings will be reset to 0 after being banned by awarn. Recommend disabled if using multiple levels of banning."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_logging"
OP.value = true
OP.type = "boolean"
OP.description = "If enabled, AWarn will log actions to a data file."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_joinmessageclient"
OP.value = true
OP.type = "boolean"
OP.description = "If enabled, players who join will see if they have any warnings on the server."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_joinmessageadmin"
OP.value = true
OP.type = "boolean"
OP.description = "If enabled, admins will get a message in chat when a player with warnings joins the server."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_removewhendeletewarning"
OP.value = false
OP.type = "boolean"
OP.description = "If enabled, 1 active warning will be removed form a player when a warning is deleted."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_allow_warn_admins"
OP.value = true
OP.type = "boolean"
OP.description = "If enabled, admins will be able to warn other admins."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_chat_prefix"
OP.value = "!warn"
OP.type = "string"
OP.description = "Chat command to warn players and open the warning menu."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_server_language"
OP.value = AWarn.DefaultLanguage
OP.type = "string"
OP.description = "Language all server messages will be in."
AWarn:RegisterOption( OP )

local OP = {}
OP.name = "awarn_server_name"
OP.value = "Server 1"
OP.type = "string"
OP.description = "Server name for multi-server support"
AWarn:RegisterOption( OP )

AWarn:LoadOptions()