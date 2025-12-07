local Polaroid = g1_Polaroid

local function SetOwner(ent, ply)
	if ent.CPPISetOwner then
		ent:CPPISetOwner(ply)
	else
		ent:SetOwner(ply)
	end
end

local function Spawn(ply, storageProvider, uid)
	if hook.Run("Polaroid/RewritePhotoSpawn", ply, uid) then return end

	local tr = util.TraceLine({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * 32,
		filter = ply
	})

	local ent = ents.Create("polaroid_photo")
	SetOwner(ent, ply)
	ent:SetStorageProvider(storageProvider)
	ent:SetImgID(uid)
	ent:SetPos(tr.HitPos)
	ent:Spawn()

	hook.Run("Polaroid/PhotoSpawned", ply, ent, uid)
end

concommand.Add("polaroid_spawn_photo", function(ply, _, args)
	if ply:IsSuperAdmin() == false then
		ply:ChatPrint("Nope, superadmin only.")
		return
	end

	if #args ~= 2 then
		ply:ChatPrint("Invalid syntax! Example: polaroid_spawn_photo \"kmi\" \"kzbajxkjnw\"")
		return
	end

	local storageProvider, uid = args[1], args[2]

	if Polaroid.storageProviders[storageProvider] == nil then
		ply:ChatPrint("Invalid storage provider!")
		return
	end

	if #uid == 0 then
		ply:ChatPrint("Invalid uid!")
		return
	end

	Spawn(ply, storageProvider, uid)
end)

local function SpawnPhoto(ply, swep, uid)
	if swep.IsUnlimited == false then
		if swep:Clip1() < 1 then return end
		swep:TakePrimaryAmmo(1)
	end

	swep:EmitSound("polaroid/camera.mp3")

	timer.Simple(1, function()
		if IsValid(swep) == false then return end

		Spawn(ply, Polaroid.config.StorageProvider, uid)
	end)
end

util.AddNetworkString("gmod.one/polaroid")
net.Receive("gmod.one/polaroid", function(_, ply)
	local swep = ply:GetActiveWeapon()
	if not (IsValid(swep) and swep.IsPolaroidCamera) then return end

	local uid = net.ReadString()
	if
		(ply._lastPolaroidPhoto or "") == uid or
		hook.Run("Polaroid/CanSpawnPhoto", ply, uid) == false
	then
		return
	end

	if (ply._polaroidCooldown or 0) > CurTime() then return end
	ply._polaroidCooldown = CurTime() + 1

	ply._lastPolaroidPhoto = uid
	SpawnPhoto(ply, swep, uid)
end)
