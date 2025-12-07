-- developed for gmod.store
-- from gmod.one with love <3

ENT.Base 		= "base_gmodentity"
ENT.PrintName 	= "Polaroid Photo"
ENT.Author 		= "Beelzebub"
ENT.Spawnable 	= false
ENT.Category  	= "Polaroid"

ENT.IsPolaroidPhoto = true

local function invalidateTexture(ent)
	ent.forceUpdateTexture = true
end

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ImgID")
	self:NetworkVar("String", 1, "StorageProvider")
	self:NetworkVar("String", 2, "Desc")

	if SERVER then return end

	self:NetworkVarNotify("ImgID", invalidateTexture)
	self:NetworkVarNotify("StorageProvider", invalidateTexture)
	self:NetworkVarNotify("Desc", invalidateTexture)
end
