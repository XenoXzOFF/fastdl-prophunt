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

MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, "Loading Permissions Module\n")

AWarn.Permissions = AWarn.Permissions or {}

--- Register a new permission table
---@param pTbl table
function AWarn:RegisterPermission(pTbl)
	if not pTbl or not pTbl.permissionString then return end
	self.Permissions[pTbl.permissionString] = pTbl
end

--- Lookup a permission by string
---@param p string
---@return table|false
function AWarn:LookupPermission(p)
	return self.Permissions[p] or false
end

--- Check if a player has a permission
---@param pl Player
---@param p string
---@return boolean
function AWarn:CheckPermission(pl, p)
	local perm = self:LookupPermission(p)
	return perm and perm.permissionCheck(pl) or false
end

--- Compatibility wrapper for multiple admin mods
---@param pl Player
---@param pString string
---@return boolean
function AWarn:AdminCompatStringCheck(pl, pString)
	if ulx then
		return ULib and ULib.ucl.query(pl, pString) or false
	elseif sAdmin then
		return sAdmin.hasPermission(pl, pString) or false
	elseif CAMI then
		return CAMI.PlayerHasAccess(pl, pString, nil)
	elseif xAdmin then
		return pl.xAdminHasPermission and pl:xAdminHasPermission(pString) or false
	elseif serverguard then
		return serverguard.player:HasPermission(pl, pString) or false
	elseif SAM then
		return SAM.HasPermission(pl, pString)
	else
		return pl:IsSuperAdmin() or pl:IsAdmin() or false
	end
end

-- Helper to streamline permission registration
local function registerPermission(id, short, desc)
	AWarn:RegisterPermission({
		permissionString = id,
		shortString      = short,
		description      = desc,
		permissionCheck  = function(pl)
			return AWarn:AdminCompatStringCheck(pl, id)
		end
	})
end

-- Define AWarn permissions
registerPermission("awarn_view",    "AWarn View",    "Allows a player to view other players' warnings.")
registerPermission("awarn_warn",    "AWarn Warn",    "Allows a player to warn other players.")
registerPermission("awarn_remove",  "AWarn Remove",  "Allows a player to decrease another player's active warnings.")
registerPermission("awarn_delete",  "AWarn Delete",  "Allows a player to delete all warnings for a player.")
registerPermission("awarn_options", "AWarn Options", "Allows a player to view and change the script's configurations.")
registerPermission("awarn_immune",  "AWarn Immune",  "Players with this permission are immune to being warned.")
