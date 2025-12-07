-- developed for gmod.store
-- from gmod.one with love <3

local Polaroid = g1_Polaroid

ENT.TextFont = "PolaroidCamera.Description"
ENT.TextColr = Color(220, 220, 220) -- Color(50, 50, 50)
ENT.MaxDist = 512 ^ 2

ENT.rtSize = Vector(1024, 551)
ENT.rtRotate = Angle(0, 90, 0)

-----------------

ENT.rtTranslate1 = Vector(ENT.rtSize.y, ENT.rtSize.x) * 0.5
ENT.rtTranslate2 = ENT.rtSize * -0.5

-----------------

include("shared.lua")

net.Receive("gmod.one/polaroid/entity", function()
	local ent = net.ReadEntity()

	local menu = vgui.Create("gmod.one/polaroid/menu")
	menu:Center()
	menu:MakePopup()
	if ent.IsPolaroidPhotoFrame then
		menu:SetMode(ent, ent:GetImgID() == "" and 4 or 1)
	else
		menu:SetMode(ent, 3)
	end
end)

surface.CreateFont("PolaroidCamera.Description", {
	font = "Roboto",
	size = 56,
	width = 600,
	extended = true,
	shadow = true
})

local none = {[""] = true}

function ENT:Initialize()
	self.forceUpdateTexture = true
end

function ENT:Draw()
	self:DrawModel()

	if none[self:GetImgID()] then
		if self.forceUpdateTexture or self.forceUpdateTexture == nil then
			local rt = Polaroid:GetRenderTarget(self)
			if rt == nil then return end
			render.PushRenderTarget(rt)
			render.Clear(0, 0, 0, 255, true, true)
			cam.Start2D()
				surface.SetDrawColor(0, 0, 0, 255)
				surface.DrawRect(0, 0, 1024, 1024) -- idunno why render.Clear doesnt works
			cam.End2D()
			render.PopRenderTarget()
		end

		return
	end

	local pos = self:GetPos()
	local dist = pos:DistToSqr(LocalPlayer():GetPos())
	if dist > self.MaxDist then return end

	self:UpdateTexture()
end

function ENT:UpdateTexture()
	local id, metadata, shouldUpdate = Polaroid:Think(self:GetStorageProvider(), self:GetImgID())
	if metadata ~= self.metadata then
		hook.Run("Polaroid/ReadMetadata", metadata, self)
		self.metadata = metadata
	end
	hook.Run("Polaroid/ThinkMetadata", metadata, self)

	-- shouldUpdate = true
	if shouldUpdate == false and not self.forceUpdateTexture then return end
	self.forceUpdateTexture = false

	local rt = Polaroid:GetRenderTarget(self)
	if rt == nil then return end

	if self.rtIndex == nil or self:GetSubMaterial(self.rtIndex) == "" then
		self:UpdatePhotoMaterial(rt)
	end

	local matrix = Matrix()
	matrix:Translate(self.rtTranslate1)
	matrix:Rotate(self.rtRotate)
	matrix:Translate(self.rtTranslate2)

	render.PushRenderTarget(rt)
	render.Clear(0, 0, 0, 255, true, true)
	cam.Start2D()
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, 1024, 1024) -- idunno why render.Clear doesnt works here. so ill just fill background with black.
	cam.PushModelMatrix(matrix)
		local size = self.rtSize

		Polaroid:Draw(id, size.x, size.y)
		draw.SimpleText(self:GetDesc(), self.TextFont, 16, size.y - 12, self.TextColr, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	cam.PopModelMatrix()
	cam.End2D()
	render.PopRenderTarget()
end

function ENT:OnRemove()
	Polaroid:PopRenderTarget(self)
	Polaroid:StateGC(self:GetStorageProvider(), self:GetImgID())
end

local targetMaterials = {
	["models/polaroid_v2/frame/whitepaper"] = true,
	["models/polaroid_v2/photo/blackframe"] = true
}

function ENT:UpdatePhotoMaterial(rt)
	local index = self.rtIndex

	if index == nil then
		for i, mat in ipairs(self:GetMaterials()) do
			if targetMaterials[mat] then
				index = i - 1
				break
			end
		end

		if index == nil then ErrorNoHalt("Polaroid :SetSubMaterial error! Target material not found.") return end
	end

	render.PushRenderTarget(rt)
	cam.Start2D()
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, 1024, 1024) -- idunno why render.Clear doesnt works
	cam.End2D()
	render.PopRenderTarget()

	self:SetSubMaterial(index, "!" .. rt:GetName())
end
