-- developed for gmod.store
-- from gmod.one with love <3

ENT.Base = "polaroid_photo"
ENT.PrintName 	= "Polaroid Frame - Large"
ENT.Author 		= "Beelzebub"
ENT.Spawnable 	= true
ENT.Category  	= "Polaroid"

ENT.IsPolaroidPhoto = true
ENT.IsPolaroidPhotoFrame = true

function ENT:Initialize()
	if SERVER and self.SvInitialize then self:SvInitialize() end

	if self.ModelScale then self:Resize(self.ModelScale) end
end

function ENT:Resize(scale)
	local phys = self:GetPhysicsObject()

	if IsValid(phys) == false then return false end

	local physmesh = phys:GetMeshConvexes()
	if not istable(physmesh) or #physmesh < 1 then return false end

	for convexkey, convex in pairs(physmesh) do
		for poskey, postab in pairs(convex) do
			convex[poskey] = postab.pos * scale
		end
	end

	self:PhysicsInitMultiConvex(physmesh)
	self:EnableCustomCollisions(true)

	self:SetModelScale(scale)

	phys = self:GetPhysicsObject()
	if IsValid(phys) == false then return false end

	phys:Wake()

	return true
end
