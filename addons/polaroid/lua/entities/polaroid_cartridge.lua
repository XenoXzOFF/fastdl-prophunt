-- developed for gmod.store
-- from gmod.one with love <3

local Polaroid = g1_Polaroid

AddCSLuaFile()

ENT.Base 		= "base_gmodentity"
ENT.PrintName 	= "Polaroid Cartridge"
ENT.Author 		= "Beelzebub"
ENT.Spawnable 	= true
ENT.Category  	= "Polaroid"

if CLIENT then return end

ENT.Model = "models/polaroid/photo.mdl"
ENT.NewPhys = {
	mins = -Vector(2, 4, 1),
	maxs = Vector(2, 4, 1)
}

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInitBox(self.NewPhys.mins, self.NewPhys.maxs)
	self:SetModelScale(0.5)

	self:PhysWake()

	self:SetUseType(SIMPLE_USE)
end

function ENT:Use(ply)
	if self.Used then return end

	local camera = ply:GetWeapon("polaroid")
	if IsValid(camera) == false then return end

	self.Used = true

	local tname = "PolaroidAmmo".. self:EntIndex()

	self:SetModelScale(0, 0.25)
	timer.Simple(0.25, function()
		timer.Remove(tname)
		self:Remove()
		camera:SetClip1(Polaroid.config.CartrigeSize)
	end)

	local pos = self:GetPos()
	local i = 0

	timer.Create(tname, 0, 0, function()
		i = i + 0.25
		pos.z = pos.z + i
		self:SetPos(pos)
	end)
end

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end

	local ent = ents.Create(class)
	ent:SetPos(tr.HitPos + tr.HitNormal * 10)
	ent:Spawn()
	ent:Activate()

	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis(ang:Right(), -90)
	ang.y = ply:EyeAngles().y
	ent:SetAngles(ang)

	return ent
end
