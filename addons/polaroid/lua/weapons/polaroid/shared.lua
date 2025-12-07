-- developed for gmod.store
-- from gmod.one with love <3

local Polaroid = g1_Polaroid

SWEP.MaxZoom = 5
SWEP.IsUnlimited = false -- infinity photos (CONFIG.InfinityPhotos)

SWEP.IsPolaroidCamera = true

SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = Model("models/polaroid/camera.mdl")

SWEP.Primary.ClipSize		= SWEP.IsUnlimited and -1 or Polaroid.config.CartrigeSize
SWEP.Primary.DefaultClip	= SWEP.IsUnlimited and -1 or Polaroid.config.CartrigeSize
SWEP.Primary.Automatic		= false

game.AddAmmoType({name = "polaroid"})
SWEP.Primary.Ammo = SWEP.IsUnlimited and "none" or "polaroid"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.Category  	= "Polaroid"
SWEP.PrintName	= "Polaroid Camera"
SWEP.Author 	= "Beelzebub"
SWEP.Instructions = "LMB: Take Photo\nRMB: Zoom\nReload: DOF\nRMB+ALT: Auto Dolly Zoom"

SWEP.Slot		= 5
SWEP.SlotPos	= 1

SWEP.DrawAmmo		= false
SWEP.DrawCrosshair	= false
SWEP.Spawnable		= true

SWEP.ShootSound = Sound("NPC_CScanner.TakePhoto")

function SWEP:Initialize()
	self:_Initialize()
	self._polaroidInitialized = true
	self.Think = self._Think
end

function SWEP:Think() -- hack (Initialize hook for some reason is not called on the server-side, perhaps this is a bug of the p2p server)
	if not self._polaroidInitialized  then
		self:_Initialize()
		self._polaroidInitialized = true
	end

	self.Think = self._Think
	if self._Think then self:_Think() end
end

function SWEP:_Initialize()
	self:SetHoldType("camera")

	self.IsUnlimited = tobool(Polaroid.config.InfinityPhotos)
	self.Primary.Ammo 			= self.IsUnlimited and "none" or "polaroid"
	self.Primary.ClipSize		= self.IsUnlimited and -1 or Polaroid.config.CartrigeSize
	self.Primary.DefaultClip	= self.IsUnlimited and -1 or Polaroid.config.CartrigeSize

	hook.Add("Polaroid/ConfigLoaded", self, function()
		self.IsUnlimited = tobool(Polaroid.config.InfinityPhotos)
		self.Primary.Ammo 			= self.IsUnlimited and "none" or "polaroid"
		self.Primary.ClipSize		= self.IsUnlimited and -1 or Polaroid.config.CartrigeSize
		self.Primary.DefaultClip	= self.IsUnlimited and -1 or Polaroid.config.CartrigeSize

		if self.IsUnlimited then
			self:SetClip1(9999)
		elseif self:Clip1() < 0 or self:Clip1() > 3 then
			self:SetClip1(3)
		end
	end)

	if CLIENT then self:Deploy() end
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "Zoom")

	if SERVER then
		self:SetZoom(70)
	end
end

function SWEP:Equip()
	local ply = self:GetOwner()

	if self:GetZoom() == 70 and ply:IsPlayer() and ply:IsBot() == false then
		self:SetZoom(88)
	end
end

function SWEP:TranslateFOV()
	local ply = self:GetOwner()

	if ply:GetViewEntity() ~= ply then return end
	return self:GetZoom()
end

function SWEP:SecondaryAttack() end

local chat_message
if CLIENT then
	chat_message = {
		Color(227, 68, 47),
		"[P",
		Color(243, 131, 23),
		"OL",
		Color(232, 164, 37),
		"AR",
		Color(127, 178, 60),
		"OI",
		Color(18, 143, 201),
		"D]: ",
		Color(225, 225, 225),
		"placeholder"
	}
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	self:SetNextPrimaryFire(CurTime() + 1)

	if (self.NextPhotoShot or 0) > CurTime() then
		if CLIENT and IsFirstTimePredicted() then
			self.FailedByOverheat = CurTime() + 0.5

			chat_message[#chat_message] = Polaroid.translate("The polaroid is overheated, try again later.")
			chat.AddText(unpack(chat_message))
		end
		return
	end

	if self:Clip1() < 1 and self.IsUnlimited == false then
		if CLIENT and IsFirstTimePredicted() then
			chat_message[#chat_message] = Polaroid.translate("Replace the cartridge with a new one.")
			chat.AddText(unpack(chat_message))
		end

		self.NextPhotoShot = CurTime() + 0.5
		return
	end

	self.NextPhotoShot = CurTime() + Polaroid.config.RateLimit

	if hook.Run("Polaroid/CanTakePhoto", self:GetOwner(), self) == false then return end

	self:DoShootEffect()

	if SERVER or IsFirstTimePredicted() == false then return end

	self:TakePhoto()
end

function SWEP:DoShootEffect()
	local ply = self:GetOwner()

	self:EmitSound(self.ShootSound)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	ply:SetAnimation(PLAYER_ATTACK1)

	if SERVER and game.SinglePlayer() == false then
		local vPos = ply:GetShootPos()
		local vForward = ply:GetAimVector()

		local trace = {}
		trace.start = vPos
		trace.endpos = vPos + vForward * 256
		trace.filter = ply

		local tr = util.TraceLine(trace)

		local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		util.Effect("camera_flash", effectdata, true)
	end
end

function SWEP:Tick()
	local ply = self:GetOwner()
	if CLIENT and ply ~= LocalPlayer() then return end -- spectate fix

	local cmd = ply:GetCurrentCommand()

	if cmd:KeyDown(IN_RELOAD) then
		if CLIENT then
			self.DOF = math.Clamp(self:GetDOF() - cmd:GetMouseY() * 0.005, 0, 5)
		end
	end

	if cmd:KeyDown(IN_ATTACK2) then
		self:SetZoom(
			math.Clamp(self:GetZoom() + cmd:GetMouseY() * 0.01, 20, 90)
		)
	end
end
