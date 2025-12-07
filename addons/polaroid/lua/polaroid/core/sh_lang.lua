local Polaroid = g1_Polaroid

hook.Add("Polaroid/ConfigLoaded", "Polaroid/LoadLanguage", function()
	local lang = Polaroid.config.Language

	if file.Exists("polaroid/langs/" .. lang .. ".lua", "LUA") == false then
		local fallback = "en"

		if file.Exists("polaroid/langs/en.lua", "LUA") == false then
			local any = (file.Find("polaroid/lang/*.lua", "LUA") or {})[1]
			assert(any, "Polaroid is broken! Looks like server owner deleted directory lua/polaroid/langs/ !!!")

			fallback = any:match("(.+)%..+")
		end

		ErrorNoHalt("Configuration error! Polaroid.config.Language has invalid value! No language file found with given name! Fallback to " .. fallback .. "\n")

		lang = fallback
		Polaroid.config.Language = fallback
	end

	local path = "polaroid/langs/" .. lang .. ".lua"

	AddCSLuaFile(path)
	local phrases = include(path)

	if istable(phrases) == false then
		ErrorNoHalt("Configuration error! Language file with given Polaroid.config.Language returns invalid value!\n")
	end

	function Polaroid.translate(str)
		return phrases[str] or str
	end

	hook.Run("Polaroid/LangsLoaded")
end)
