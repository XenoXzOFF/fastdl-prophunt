-- developed for gmod.store
-- from gmod.one with love <3
-- https://www.gmodstore.com/market/view/7624

local Polaroid = g1_Polaroid

Polaroid.config.Language = "en" --[[
	en (english)
	ru (russian - русский)
	uk (ukrainian - український)
	fr (french - français)
	tr (turkish - türk)
	es (spanish - español)

	if you enter an unknown language, it will fallback to default (english)
]]--

Polaroid.ExperimentalRenderingSystem = false --[[
	experimental rendering system.
	optimization thing.

	since v2 polaroid switched from 3d2d to rt textures rendering.
	this plays a big role in optimization, features & visual experience.

	since we are actually changing the texture of the model, not rendering overlay, we may not have to render the photos every frame.

	polaroid rendering pipeline built on state system, this way we can re-render texture only when its required.

	might be unstable, more tests are needed.
	testing contributions are welcome.
]]--

-- quality settings
Polaroid.config.PhotoQuality = 90 --[[
	number 0-100

	its max limit, not constant.
	if photo file-size doesn't fit storage provider limits, quality will automatically decrease
]]--
Polaroid.config.PhotoResolution = Vector(960, 540) --[[
	Vector2 - width, height

	dont make it too big, this has huge affect to file-size.
	4K quality will never be noticeable in game, so dont worry about it.

	960x540 with quality 90 will make 35-350kb files - its good for kmi storage-provider.
]]--

Polaroid.config.RateLimit = 10 -- delay between photos

-- photos hosting
Polaroid.config.StorageProvider = "kmi" --[[
	kmi - https://kmi.aeza.net/ - pastebin like thing. limits: 10 uploads per minute (per player), max upload size 512kb

	timetales - https://cdn.voltgaming.de/ - chibisafe hosted by my dude (fair use)

	you can also implement your own storage provider based on any files hosting
	eg you can selfhost pomf/chibisafe/transfer.sh etc & quick create storage-provider for it

	or even make custom files hosting like r2+workers & make provider for it
	look for examples in lua/polaroid/storage_providers/ and docs in lua/polaroid/storage_providers/readme.md
]]--


Polaroid.config.forceDisableThirdpersonHooks = false --[[
	quick auto-compat with any thirdperson addon
	requires restart/reconnect if changed (no hotload support)

	it force disables all CalcView/ShouldDrawLocalPlayer hooks when Polaroid equipped.

	its reliable, but kinda hacky - if possible, add compat in thirdperson addon code manually (its just a quick fix for lazy customers)

	might not work with some 3rdparty hook libs
]]--

Polaroid.config.PhotosTTL = 60 * 60 * 24 * 14 -- number seconds (60 * 60 * 24 means 1 day)
-- polaroid will prune old photos cache (all photos older than TTL)

Polaroid.config.EnableEditor = true -- true/false (ingame photo editor)

Polaroid.config.CartrigeSize = 3 -- Count of "polaroid ammo". when using the `polaroid_cartridge` entity "polaroid ammo" will be filled up to this number (like cartridge changed).
Polaroid.config.InfinityPhotos = false -- true or false (ignores "polaroid ammo" count, take as many photos as you wish)

Polaroid.config.AutoRemovePhotos = true -- enable automatic photo removing (does not affects on framed photos)
Polaroid.config.AutoRemovePhotosTime = 60 * 5 -- seconds

hook.Run("Polaroid/ConfigLoaded") -- do not touch this line!
