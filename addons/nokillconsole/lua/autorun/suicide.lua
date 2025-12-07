
-----------------------------------------------------
local function BlockSuicide(ply)
	ply:ChatPrint("[Desole] Le suicide n'est pas une solution   !")
	return false
end
hook.Add( "CanPlayerSuicide", "BlockSuicide", BlockSuicide )