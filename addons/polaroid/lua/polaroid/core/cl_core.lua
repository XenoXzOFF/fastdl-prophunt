local Polaroid = g1_Polaroid

function Polaroid:Upload(image, cback, _retry)
	_retry = _retry or 3

	Polaroid.storage:Upload(image, cback, function(reason)
		if _retry == 0 then
			notification.AddLegacy("Failed to print photo! Try again later! Check console for details.", NOTIFY_ERROR, 10)
			print("Polaroid: failed to upload photo!\n" .. reason)
			return
		end

		self:Upload(image, cback, _retry - 1)
	end)
end

-----------


local config = Polaroid.config
local capture = {
	rt = nil,
	mat = nil
}

local function Invalidate()
	local name = "Polaroid/" .. config.PhotoResolution.x .. "x" .. config.PhotoResolution.y

	capture.rt = GetRenderTarget(name, config.PhotoResolution.x, config.PhotoResolution.y)
	capture.mat = CreateMaterial(name, "UnlitGeneric", {
		["$basetexture"] = name
	})
end

Invalidate()
hook.Add("Polaroid/ConfigLoaded", "Polaroid/Core", Invalidate)

----------------

function Polaroid:GetRenderTarget()
	return capture.rt
end

function Polaroid:GetMaterial()
	return capture.mat
end

----------------

local overlayColor = Color(0, 0, 15, 200)
local inner_shadow = Material("polaroid/inner_shadow.png")
local vignette = Material("polaroid/vignette.png")

local GetEyePos = MainEyePos or EyePos
local GetEyeAngles = MainEyeAngles or EyeAngles

function Polaroid:CaptureView(fov)
	local size = config.PhotoResolution

	vgui.GetWorldPanel():SetVisible(false)
	render.PushRenderTarget(capture.rt)
		render.Clear(0, 0, 0, 0, true, true)

		cam.Start2D()
			render.RenderView({
				origin = GetEyePos(),
				angles = GetEyeAngles(),
				x = 0,
				y = 0,
				w = size.x,
				h = size.y,
				drawhud = false,
				drawviewmodel = false,
				fov = fov
			})

			surface.SetDrawColor(overlayColor)

			surface.SetMaterial(vignette)
			surface.DrawTexturedRect(0, 0, size.x, size.y)

			surface.SetMaterial(inner_shadow)
			surface.DrawTexturedRect(0, 0, size.x, size.y + 4)
		cam.End2D()
	render.PopRenderTarget()
	vgui.GetWorldPanel():SetVisible(true)
end

----------------

-- metadata api (to store any custom data in photo, eg location name, coordinates)
local Metadata = {marker = "polaroid-metadata:"}

function Metadata:write(image, metadata)
	local eof = image:find("\xff\xd9", 1, true)

	if eof then
		image = image:sub(1, eof + 2) .. self.marker .. util.TableToJSON(metadata)
	end

	return image
end

function Metadata:read(image)
	local eof = image:find("\xff\xd9", 1, true)
	if eof == nil then return {} end

	local data = image:sub(eof + 2)
	if data:sub(1, #self.marker) ~= self.marker then return end

	local succ, metadata = pcall(util.JSONToTable, data:sub(#self.marker + 1))
	return succ and metadata or {}
end

local function Capture(quality)
	local image = render.Capture({
		format = "jpeg",
		quality = quality,
		x = 0,
		y = 0,
		w = config.PhotoResolution.x,
		h = config.PhotoResolution.y,
	})

	local metadata = {}
	hook.Run("Polaroid/WriteMetadata", metadata)
	if next(metadata) then
		image = Metadata:write(image, metadata)
	end

	image = util.Compress(image)

	if Polaroid.storage.encode then
		return util.Base64Encode(image)
	end

	return image
end

function Polaroid:DecodeImage(body)
	if Polaroid.storage.encode then
		body = util.Base64Decode(body)
	end

	return util.Decompress(body)
end

function Polaroid:CaptureImage()
	local quality = math.Clamp(Polaroid.config.PhotoQuality, 0, 100)
	local image = Capture(quality, 1)

	local maxFileSize = Polaroid.storage.maxFileSize
	local meetsLimits = maxFileSize == nil or #image <= maxFileSize
	local stepSize = quality / 3

	while meetsLimits == false and quality > 0 do
		quality = math.max(0, math.floor(quality - stepSize))
		image = Capture(quality)
		meetsLimits = #image <= maxFileSize
	end

	if meetsLimits == false then
		notification.AddLegacy("Error! Photo size doesnt meet the storage provider limits!", NOTIFY_ERROR, 10)
		notification.AddLegacy("Photo rendering may be broken! Ask server owner to reduce Polaroid.config.PhotoResolution", NOTIFY_ERROR, 10)
	end

	return image
end

----------------

file.CreateDir("polaroid/photos")

for _, f in ipairs(file.Find("polaroid/photos/*.jpg", "DATA")) do
	f = "polaroid/photos/" .. f
	if file.Time(f, "DATA") + Polaroid.config.PhotosTTL <= os.time() then
		file.Delete(f, "DATA")
	end
end

local cache, errors = {}, {}
local downloading, queue, lockDownload, lockNextDownload = {}, {}, false, false
local metadata = {}
local Download

hook.Add("Think", "Polaroid/DownloaderQueue", function()
	if lockNextDownload then return end

	local data = table.remove(queue, 1)
	if data == nil then
		lockDownload = false
		return
	end

	Download(data.provider, data.uid)
end)

local function PerformDownload(storage, uid, id, path, _retry)
	_retry = _retry or 3

	local function onFailure(reason)
		if _retry == 0 then
			ErrorNoHalt("Failed to download polaroid photo! URL: " .. storage:GetURL(uid) .. ", reason:\n" .. reason .. "\n")

			errors[id] = "failed to download (check console)"
			downloading[id] = nil
			lockNextDownload = false
			return
		end

		PerformDownload(storage, uid, id, path, _retry - 1)
	end

	storage:Download(uid, function(raw)
		local image = Polaroid:DecodeImage(raw)

		if Polaroid.util.ValidateJPEG(image) == false then
			onFailure("Request error! Invalid body! URL: " .. storage:GetURL(uid))
			return
		end

		file.Write(path, image)

		metadata[id] = Metadata:read(image)
		cache[id] = Material("data/" .. path, "smooth mips")
		downloading[id] = nil

		lockNextDownload = false
	end, onFailure)
end

function Download(provider, uid)
	local id = provider .. "-" .. uid
	local storage = Polaroid.storageProviders[provider]

	if storage == nil then
		lockNextDownload = false
		errors[id] = "invalid storage provider \"" .. provider .. "\"! contact server owner!"
		return
	end

	local path = "polaroid/photos/" .. id .. ".jpg"
	lockNextDownload = true

	PerformDownload(storage, uid, id, path)
end

local function PushDownload(provider, uid)
	if lockDownload then
		table.insert(queue, {
			provider = provider,
			uid = uid
		})
		return
	end

	lockDownload = true
	Download(provider, uid)
end

----------------

local loadingMat = Material("polaroid/loading.png", "smooth mips")

local function DrawLoading(w, h)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)

	local size = math.min(w, h) * 0.5
	local ang = math.EaseInOut((
		(-RealTime() * 200) % 360
	) / 360, 0.5, 0.5) * 360

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(loadingMat)
	surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, size, size, ang)
end

local function DrawCache(id, w, h)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(cache[id])
	surface.DrawTexturedRect(0, 0, w, h)
end

local titleColor = Color(255, 255, 255)
surface.CreateFont("Polaroid/error/title", {
	font = "Roboto Medium",
	size = 40,
	weight = 500
})

local descColor = Color(200, 200, 200)
surface.CreateFont("Polaroid/error/desc", {
	font = "Roboto",
	size = 28,
	weight = 400
})

local function DrawError(w, h, reason)
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(0, 0, w, h)

	local x, y = w * 0.5, h * 0.5

	draw.SimpleText("Failed to download photo!", "Polaroid/error/title", x, y - 2, titleColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.SimpleText(reason, "Polaroid/error/desc", x, y + 2, descColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
end

local oldState = {}

local function pushState(id, state, forceUpdate) -- should update texture?
	if not Polaroid.ExperimentalRenderingSystem then return true end

	local old = oldState[id]
	oldState[id] = state

	return forceUpdate or state ~= old
end

function Polaroid:StateGC(provider, uid)
	local id = provider .. "-" .. uid
	oldState[id] = nil
end

local STATE = {
	cache = 0,
	error = 1,
	downloading = 2
}

function Polaroid:Think(provider, uid)
	local id = provider .. "-" .. uid

	if metadata[id] == nil then metadata[id] = {} end

	local state, forceUpdate = "invalid", false

	if cache[id] then
		state = STATE.cache
	elseif errors[id] then
		state = STATE.error
	elseif downloading[id] then
		state = STATE.downloading
		forceUpdate = true
	else
		local path = "polaroid/photos/" .. id .. ".jpg"

		if file.Exists(path, "DATA") then
			metadata[id] = Metadata:read(file.Read(path, "DATA"))
			cache[id] = Material("data/" .. path, "smooth")

			state = STATE.cache
		elseif Polaroid.storageProviders[provider] == nil then
			errors[id] = "invalid storage provider \"" .. provider .. "\"! contact server owner!"

			state = STATE.error
		else
			downloading[id] = true
			PushDownload(provider, uid)

			state = STATE.downloading
			forceUpdate = true
		end
	end

	return id, metadata[id], pushState(id, state, forceUpdate)
end

function Polaroid:Draw(id, w, h)
	if cache[id] then
		DrawCache(id, w, h)
	elseif errors[id] then
		DrawError(w, h, errors[id])
	elseif downloading[id] then
		DrawLoading(w, h)
	else
		DrawError(w, h, "unknown error")
	end
end

Polaroid.renderTargets = Polaroid.renderTargets or {
	len = 0,
	map = {},
	free = {}
}

local textureFlags = bit.bor(
	2, -- TEXTUREFLAGS_TRILINEAR
	4, -- TEXTUREFLAGS_CLAMPS
	8, -- TEXTUREFLAGS_CLAMPT
	16, -- TEXTUREFLAGS_ANISOTROPIC
	512, -- TEXTUREFLAGS_NOLOD
	32768 -- TEXTUREFLAGS_RENDERTARGET
)

function Polaroid:GetRenderTarget(ent)
	local target = self.renderTargets.map[ent]
	if target then return target.rt end

	target = table.remove(self.renderTargets.free, 1)
	if target then
		self.renderTargets.map[ent] = target
		ent:UpdatePhotoMaterial(target.rt)

		return target.rt
	end

	self.renderTargets.len = self.renderTargets.len + 1
	local name = "Polaroid/model-rt/" .. self.renderTargets.len

	target = {
		rt = GetRenderTargetEx(
			name,
			1024,
			1024,
			RT_SIZE_NO_CHANGE,
			MATERIAL_RT_DEPTH_NONE,
			textureFlags,
			CREATERENDERTARGETFLAGS_HDR,
			IMAGE_FORMAT_RGB888
		),
		mat = CreateMaterial(name, "VertexLitGeneric", {
			["$basetexture"] = name,
			["$surface"] = "paper"
		})
	}

	self.renderTargets.map[ent] = target
	ent:UpdatePhotoMaterial(target.rt)

	return target.rt
end

function Polaroid:PopRenderTarget(ent)
	local target = self.renderTargets.map[ent]
	if target == nil then return end

	table.insert(self.renderTargets.free, target)
	self.renderTargets.map[ent] = nil
end

local flashColor = Color(220, 255, 220)

function Polaroid:Flash()
	if IsValid(self.flash) then self.flash:Remove() end
	timer.Remove("Polaroid/Flash")

	self.flash = ProjectedTexture()
	self.flash:SetTexture("effects/flashlight/soft")
	self.flash:SetColor(flashColor)
	self.flash:SetEnableShadows(true)
	self.flash:SetShadowFilter(2)

	self.flash:SetFOV(128)
	self.flash:SetFarZ(824)
	self.flash:SetBrightness(0.15)

	self.flash:SetPos(GetEyePos())
	self.flash:SetAngles(GetEyeAngles())
	self.flash:Update()

	local ticks = 0
	local duration = 1
	local steps = 10
	local baseBrightness = self.flash:GetBrightness()

	timer.Create("Polaroid/Flash", duration / steps, steps, function()
		ticks = ticks + 1

		if IsValid(self.flash) == false then
			timer.Remove("Polaroid/Flash")
			return
		elseif ticks == steps then
			self.flash:Remove()
			timer.Remove("Polaroid/Flash")
			return
		end

		local fraction = ticks / steps
		local brightness = baseBrightness * (1 - fraction)

		self.flash:SetBrightness(brightness)
		self.flash:Update()
	end)
end


--[[
function Polaroid:Draw(provider, uid, w, h)
	local id = provider .. "-" .. uid

	if metadata[id] == nil then metadata[id] = {} end

	local state, forceUpdate = "invalid", false

	if cache[id] then
		state = "cache"
		DrawCache(id, w, h)
	elseif errors[id] then
		state = "error"
		DrawError(w, h, errors[id])
	elseif downloading[id] then
		state = "downloading"
		forceUpdate = true
		DrawLoading(w, h)
	else
		local path = "polaroid/photos" .. id .. ".jpg"
		if file.Exists(path, "DATA") then
			metadata[id] = Metadata:read(file.Read(path, "DATA"))
			cache[id] = Material("data/" .. path, "smooth mips")

			state = "read cache"
			DrawCache(id, w, h)

			return metadata[id], pushState(id, state, forceUpdate)
		end

		local storage = Polaroid.storageProviders[provider]
		if storage == nil then
			errors[id] = "invalid storage provider \"" .. provider .. "\"! contact server owner!"

			state = "error2"
			DrawError(w, h, errors[id])

			return metadata[id], pushState(id, state, forceUpdate)
		end

		downloading[id] = true
		PushDownload(provider, uid)

		state = "downloading"
		forceUpdate = true
		DrawLoading(w, h)
	end

	return metadata[id], pushState(id, state, forceUpdate)
end
]]--
