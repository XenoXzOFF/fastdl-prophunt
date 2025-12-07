-- developed for gmod.store
-- from gmod.one with love <3

local Polaroid = g1_Polaroid

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = "models/polaroid_v2/photo.mdl" -- "models/polaroid/photo.mdl"

ENT.InitPhys = true
ENT.NewPhys = {
	mins = -Vector(4, 8, 1),
	maxs = Vector(4, 8, 1)
}

util.AddNetworkString("gmod.one/polaroid/entity")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if self.InitPhys then self:PhysicsInitBox(self.NewPhys.mins, self.NewPhys.maxs) end

	self:PhysWake()

	self:SetUseType(SIMPLE_USE)

	if Polaroid.config.AutoRemovePhotos then
		timer.Simple(Polaroid.config.AutoRemovePhotosTime, function()
			if IsValid(self) then
				self:Remove()
			end
		end)
	end
end

function ENT:SpawnFunction(ply, tr, ClassName)
	if not tr.Hit then return end

	local pos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create(ClassName)
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()

	return ent
end

local function GetOwner(ent)
	return ent.CPPIGetOwner and ent:CPPIGetOwner() or ent:GetOwner()
end

function ENT:Use(ply)
	if CPPI == nil or ply:IsSuperAdmin() or GetOwner(self) == ply then
		net.Start("gmod.one/polaroid/entity")
			net.WriteEntity(self)
		net.Send(ply)
	end
end

local NextNetUse = {}

net.Receive("gmod.one/polaroid/entity", function(len, ply)
	local sid = ply:SteamID64()
	local CT = CurTime()
	if (NextNetUse[sid] or 0) > CT then return end
	NextNetUse[sid] = CT + 0.5


	local ent = net.ReadEntity()
	if not (
		(IsValid(ent) and ent.SetDesc and ent.IsPolaroidPhoto) and
		(CPPI == nil or ply:IsSuperAdmin() or GetOwner(ent) == ply)
	) then return end

	if net.ReadBool() then
		if ent.IsPolaroidPhotoFrame then
			ent:EmitSound("polaroid/drop.mp3")
			ent:DropPhotoFromFrame(ply)
		else
			ent:EmitSound("polaroid/tear.mp3")
			timer.Simple(0.4, function()
				ent:Remove()
			end)
		end
	else
		ent:EmitSound("polaroid/pencil.mp3")
		ent:SetDesc(utf8.sub(net.ReadString() or "", 1, 128))
	end
end)
