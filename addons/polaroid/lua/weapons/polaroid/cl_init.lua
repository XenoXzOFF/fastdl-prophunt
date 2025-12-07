-- developed for gmod.store
-- from gmod.one with love <3

local Polaroid = g1_Polaroid

include("shared.lua")

----------
--[[
local thirdpersonCompat = {
	ignoreHooks = {
		CalcView = true,
		ShouldDrawLocalPlayer = true
	},
	shouldUndo = false,
	origHookCall = Polaroid.origHookCall,
	detouredHookCall = nil,
	apply = function(me)
		-- not sure, but maybe some hook libs can replace hook lib after swep include (loaded after swep)
		if me.origHookCall == nil then
			me.origHookCall = hook.Call
			Polaroid.origHookCall = me.origHookCall -- save between lua refreshes
		end

		me.shouldUndo = true
		hook.Call = me.detouredHookCall

		print("apply detour")
	end,
	undo = function(me)
		if me.shouldUndo == false then return end

		me.shouldUndo = false
		hook.Call = me.origHookCall

		print("undo detour")
	end
}

thirdpersonCompat.detouredHookCall = function(event_name, ...)
	if thirdpersonCompat.ignoreHooks[event_name] then print("block", event_name) return end
	return thirdpersonCompat.origHookCall(event_name, ...)
end
]]--
----------

function SWEP:Deploy()
	Polaroid.equipped = true
	--if Polaroid.config.forceDisableThirdpersonAddons then
	--	thirdpersonCompat:apply()
	--end

	return true
end

function SWEP:OnRemove()
	Polaroid.equipped = false
--	thirdpersonCompat:undo()
end

function SWEP:Holster()
	Polaroid.equipped = true
	--thirdpersonCompat:undo()

	self:DisableDof()
	return true
end


SWEP.WM_Offsets = {
	ang = Angle(188.69, 175.448, 16.552),
	vec = Vector(4.482759, -4.827586, -1.37931)
}

function SWEP:DrawWorldModel()
	local Owner = self:GetOwner()

	if not IsValid(self._WM) then
		self._WM = ClientsideModel(self.WorldModel)
		self._WM:SetNoDraw(true)
	end

	if IsValid(Owner) then
		local boneid = Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if not boneid then return end
		local matrix = Owner:GetBoneMatrix(boneid)
		if not matrix then return end
		local newPos, newAng = LocalToWorld(self.WM_Offsets.vec, self.WM_Offsets.ang, matrix:GetTranslation(), matrix:GetAngles())
		self._WM:SetPos(newPos)
		self._WM:SetAngles(newAng)
		self._WM:SetupBones()
	else
		self._WM:SetPos(self:GetPos())
		self._WM:SetAngles(self:GetAngles())
	end

	self._WM:DrawModel()
end

function SWEP:AdjustMouseSensitivity()
	local ply = self:GetOwner()
	if ply:KeyDown(IN_ATTACK2) or ply:KeyDown(IN_RELOAD) then return 0 end

	return self:GetZoom() / 140
end

function SWEP:FreezeMovement()
	local ply = self:GetOwner()
	if
		ply:KeyDown(IN_ATTACK2) or ply:KeyReleased(IN_ATTACK2) or
		ply:KeyDown(IN_RELOAD) or ply:KeyReleased(IN_RELOAD)
	then
		return true
	end

	return false
end

function SWEP:PrintWeaponInfo() end

local CHudWeaponSelection = {CHudWeaponSelection = true}
function SWEP:HUDShouldDraw(elem)
	if CHudWeaponSelection[elem] then return true end
	return self.DrawInnerShadow == nil
end

SWEP.WepSelectIcon = surface.GetTextureID("vgui/gmod_camera")

local OverlayText = Polaroid and {
	Zoom = Polaroid.translate("ZOOM") .. ": ",
	Dof = Polaroid.translate("DOF") .. ": ",
	Frames = Polaroid.translate("Frames") .. ": ",
}

hook.Add("Polaroid/LangsLoaded", "Polaroid/SWEP", function()
	OverlayText = {
		Zoom = Polaroid.translate("ZOOM") .. ": ",
		Dof = Polaroid.translate("DOF") .. ": ",
		Frames = Polaroid.translate("Frames") .. ": ",
	}
end)

local screenFlashColor = Color(220, 255, 220, 125)

function SWEP:TakePhoto()
	if Polaroid.storage == nil then
		notification.AddLegacy("Failed to take photo! Polaroid.config.StorageProvider configuration error! Dm server owner!", NOTIFY_ERROR, 10)
		return
	end

	Polaroid:Flash()
	Polaroid:CaptureView(self:GetZoom())

	LocalPlayer():ScreenFade(SCREENFADE.IN, screenFlashColor, 0.25, 0.15)

	if Polaroid.config.EnableEditor == false then
		render.PushRenderTarget(Polaroid:GetRenderTarget())
			local image = Polaroid:CaptureImage()

			Polaroid:Upload(image, function(uid)
				net.Start("gmod.one/polaroid")
					net.WriteString(uid)
				net.SendToServer()
			end)
		render.PopRenderTarget()
		return
	end

	local photoEditor = vgui.Create("gmod.one/polaroid/editor")
	photoEditor.swep = self
	photoEditor.photo = Polaroid:GetMaterial()
end

local overlay = {
	mat = Material("polaroid/overlay.png"),
	vignette = Material("polaroid/vignette.png"),
	col = Color(0, 0, 15, 125),
	txtcol = Color(0, 0, 15, 200),
	vignette_col = Color(0, 0, 15, 200),
	redcol = Color(225, 0, 15, 225),
}

surface.CreateFont("polaroid", {
	font = "Roboto",
	size = 28 * ScrH() / 1080
})

SWEP.DOF = 0

function SWEP:GetDOF()
	return self.DOF
end

function SWEP:SetDOF(n)
	self.DOF = n
end

local dof = GetConVar("pp_dof")
local dof_spacing = GetConVar("pp_dof_spacing")
local dof_initlength = GetConVar("pp_dof_initlength")
local oldDOF
local manualDOF

function SWEP:DisableDof()
	if oldDOF == nil then return end

	dof_spacing:SetFloat(oldDOF.spacing)
	dof_initlength:SetFloat(oldDOF.initlength)

	if manualDOF then
		if oldDOF.enable == false then DOF_Kill() end
	end

	dof:SetBool(oldDOF.enable)

	oldDOF = nil
end

function SWEP:_Think()
	local value = self:GetDOF()
	local enableDOF = value > 0.1

	if enableDOF == false then
		self:DisableDof()
		return
	end

	if oldDOF == nil then
		oldDOF = {
			enable = dof:GetBool(),
			spacing = dof_spacing:GetFloat(),
			initlength = dof_initlength:GetFloat()
		}
	end

	if oldDOF._tmpValue == value then return end
	oldDOF._tmpValue = value

	if manualDOF == nil and (GAMEMODE or {}).PostProcessPermitted then
		manualDOF = GAMEMODE:PostProcessPermitted("dof") == false
	end

	local val = 5000 - value * 975
	dof_spacing:SetFloat(val)
	dof_initlength:SetFloat(5000 - value * 975)

	if manualDOF and dof:GetBool() == false then
		DOF_Start()
	end

	dof:SetBool(true)
end

local overheatUI = {
	color = {
		[false] = Color(255, 255, 255, 255),
		[true] = Color(255, 0, 0, 255),
	},
	width = 192 * ScrH() / 1080,
	height = 8 * ScrH() / 1080,
}

hook.Add("OnScreenSizeChanged", "Polaroid/overheatUI", function()
	overheatUI.width = 192 * ScrH() / 1080
	overheatUI.height = 8 * ScrH() / 1080
end)

function SWEP:DrawHUD()
	local ply = LocalPlayer()
	if GetViewEntity() ~= ply then return end

	local w, h = ScrW(), ScrH()

	surface.SetDrawColor(overlay.vignette_col)
	surface.SetMaterial(overlay.vignette)
	surface.DrawTexturedRect(0, 0, w, h)

	surface.SetDrawColor(overlay.col)
	surface.SetMaterial(overlay.mat)
	surface.DrawTexturedRect(0, 0, w, h)

	local WScale = w / 1920
	local HScale = h / 1080
	local x, y = WScale * 110, HScale * 990

	local zoomText = OverlayText.Zoom .. math.Round(
		(90 - self:GetZoom()) / 20
	)
	local dofText = OverlayText.Dof .. math.Round(self:GetDOF())

	local _, txth = draw.SimpleText(zoomText, "polaroid", x, y, overlay.txtcol, nil, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(dofText, "polaroid", x, y - txth, overlay.txtcol, nil, TEXT_ALIGN_BOTTOM)

	if (self.NextPhotoShot or 0) > CurTime() then
		local delta = self.NextPhotoShot - CurTime()
		local fraction = delta / Polaroid.config.RateLimit
		local baseWidth = overheatUI.width
		local width = baseWidth * fraction
		local height = overheatUI.height
		local x2 = w * 0.5 - baseWidth * 0.5

		surface.SetDrawColor(0, 0, 15, 125)
		surface.DrawRect(x2, y, baseWidth, height)

		surface.SetDrawColor(overheatUI.color[(self.FailedByOverheat or 0) > CurTime()])
		surface.DrawRect(x2, y, width, height)
	end

	if self.IsUnlimited then return end

	local col = overlay.txtcol
	if self:Clip1() < 1 and input.IsMouseDown(MOUSE_LEFT) then
		col = overlay.redcol
	end
	draw.SimpleText(OverlayText.Frames .. self:Clip1(), "polaroid", w - x, y, col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
end
