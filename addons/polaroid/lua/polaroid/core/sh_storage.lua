local Polaroid = g1_Polaroid

Polaroid.storageProviders = {}

for _, f in ipairs(file.Find("polaroid/storage_providers/*.lua", "LUA")) do
	local path = "polaroid/storage_providers/" .. f

	AddCSLuaFile(path)
	if CLIENT then
		Polaroid.storageProviders[f:match("(.+)%..+")] = include(path)
	else
		Polaroid.storageProviders[f:match("(.+)%..+")] = true
	end
end

hook.Add("Polaroid/ConfigLoaded", "Polaroid/StorageProvider", function()
	local new = Polaroid.config.StorageProvider

	if file.Exists("polaroid/storage_providers/" .. new .. ".lua", "LUA") == false then
		local fallback

		if file.Find("polaroid/storage_providers/kmi.lua", "LUA") then
			fallback = "kmi"
		else
			local any = (file.Find("polaroid/storage_providers/*.lua", "LUA") or {})[1]
			assert(any, "Polaroid is broken! Looks like server owner deleted directory lua/polaroid/storage_providers/ !!!")

			fallback = any:match("(.+)%..+")
		end

		ErrorNoHalt("Configuration error! Polaroid.config.StorageProvider has invalid value! No storage provider found with given name \"" .. new .. "\"! Fallback to \"" .. fallback .. "\"\n")

		new = fallback
		Polaroid.config.StorageProvider = fallback
	end

	if CLIENT then
		Polaroid.storage = Polaroid.storageProviders[new]
		assert(Polaroid.storage, "Failed to load storage provider! Make sure Polaroid.config.StorageProvider configuration are ok!")
	end

	if Polaroid._PreviousStorageProvider == new then return end
	Polaroid._PreviousStorageProvider = new

	hook.Run("Polaroid/StorageProviderChanged")
end)
