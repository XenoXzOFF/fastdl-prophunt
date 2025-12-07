-- developed for gmod.store
-- from gmod.one with love <3

AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.PrintName 	= "Polaroid"
ENT.Author 		= "Beelzebub"
ENT.Spawnable 	= true
ENT.Category  	= "Polaroid"

function ENT:SpawnFunction(ply)
	ply:ConCommand("gm_spawnswep polaroid")
end
