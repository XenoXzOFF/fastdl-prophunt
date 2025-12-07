-- developed for gmod.store
-- from gmod.one with love <3

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Model = "models/polaroid_v2/frame.mdl" -- "models/polaroid/frame.mdl"
ENT.InitPhys = false

function ENT:SvInitialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:PhysWake()

	self:SetUseType(SIMPLE_USE)
end

local empty_id = {[""] = true}

function ENT:PhysicsCollide(data, phys)
	if self._HandleCollision or empty_id[self:GetImgID()] == nil then return end
	self._HandleCollision = data.HitEntity  -- i do not wanna break engine physics
end

function ENT:Think()
	if self._HandleCollision == nil then return end

	local ent = self._HandleCollision
	self._HandleCollision = nil

	if IsValid(ent) == false or ent.IsPolaroidPhotoFrame or ent.IsPolaroidPhoto == nil then return end

	local imgid = ent:GetImgID()
	if empty_id[imgid] then return end

	local desc = ent:GetDesc()
	local storage = ent:GetStorageProvider()

	ent:EmitSound("polaroid/drop.mp3")
	ent:Remove()

	self:SetImgID(imgid)
	self:SetDesc(desc)
	self:SetStorageProvider(storage)
end

function ENT:DropPhotoFromFrame(ply)
	if self:GetImgID() == "" then return end

	local ent = ents.Create("polaroid_photo")
	ent:SetImgID(self:GetImgID())
	ent:SetDesc(self:GetDesc())
	ent:SetStorageProvider(self:GetStorageProvider())
	ent:SetPos(ply:GetShootPos() + ply:GetAimVector()*32)
	ent:Spawn()

	self:SetImgID("")
	self:SetDesc("")
	self:SetStorageProvider("")
end

function ENT:SpawnFunction(ply, tr, class)
	if not tr.Hit then return end

	local ent = ents.Create(class)
	ent:SetPos(tr.HitPos + tr.HitNormal * 10)
	ent:Spawn()
	ent:Activate()

	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis(ang:Up(), 180)
	ent:SetAngles(ang)

	return ent
end

local polaroid_ents = {
	polaroid_frame			= true,
	polaroid_frame_medium	= true,
	polaroid_frame_small	= true
}

local function FixPos(ply, ent, hitpos, mins, maxs)
	local entPos = ent:GetPos()
	local endposD = ent:LocalToWorld(mins)
	local tr_down = util.TraceLine({
		start = entPos,
		endpos = endposD,
		filter = {ent, ply}
	})

	local endposU = ent:LocalToWorld(maxs)
	local tr_up = util.TraceLine({
		start = entPos,
		endpos = endposU,
		filter = {ent, ply}
	})

	if tr_up.Hit and tr_down.Hit then return end

	if tr_down.Hit then
		ent:SetPos(entPos + tr_down.HitPos - endposD)
	end
	if tr_up.Hit then
		ent:SetPos(entPos + tr_up.HitPos - endposU)
	end
end

local function PolaroidFixPos(ply, ent)
	local tr = util.TraceLine({
		start = ply:EyePos(),
		endpos = ply:EyePos() + ply:GetAimVector() * 4096,
		filter = ply
	})

	local ang = tr.HitNormal:Angle()
	ang:RotateAroundAxis(ang:Up(), 180)
	ent:SetAngles(ang)

	local tr = util.TraceLine({
		start = tr.HitPos,
		endpos = tr.HitPos + ent:OBBMaxs() * 2,
		filter = {ent, ply}
	})

	ent:SetPos(tr.HitPos)

	FixPos(ply, ent, tr.HitPos, Vector(ent:OBBMins().x, 0, 0), Vector(ent:OBBMaxs().x, 0, 0))
	FixPos(ply, ent, tr.HitPos, Vector(0, ent:OBBMins().y, 0), Vector(0, ent:OBBMaxs().y, 0))
	FixPos(ply, ent, tr.HitPos, Vector(0, 0, ent:OBBMins().z), Vector(0, 0, ent:OBBMaxs().z))
end

hook.Add("playerBoughtCustomEntity", "gmod.one/polaroid", function(ply, _, ent)
	if polaroid_ents[ent:GetClass()] then
		PolaroidFixPos(ply, ent)
	end
end)

local polaroid_ents_nophys = {
	polaroid_frame_medium	= true,
	polaroid_frame_small	= true
}

hook.Add("playerBoughtCustomEntity", "gmod.one/polaroid/nophys", function(ply, _, ent)
	if polaroid_ents_nophys[ent:GetClass()] then
		ent:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	end
end)
