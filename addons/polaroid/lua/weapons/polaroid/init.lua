-- developed for gmod.store
-- from gmod.one with love <3

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

function SWEP:Initialize()
	self:SetColor(HSVToColor(math.random() * 360, 1, 1))
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end
