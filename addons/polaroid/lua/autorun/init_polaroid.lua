-- polaroid 2.2 stable
-- developed for gmod.store
-- from gmod.one with love <3
-- https://www.gmodstore.com/market/view/7624

g1_Polaroid = g1_Polaroid or {
	config = {}
}

------------

AddCSLuaFile("polaroid/core/sh_lang.lua")
include("polaroid/core/sh_lang.lua")

AddCSLuaFile("polaroid/core/sh_storage.lua")
include("polaroid/core/sh_storage.lua")

------------

AddCSLuaFile("polaroid/core/cl_util.lua")
AddCSLuaFile("polaroid/core/cl_menu.lua")
AddCSLuaFile("polaroid/core/cl_editor_tools.lua")
AddCSLuaFile("polaroid/core/cl_editor.lua")
AddCSLuaFile("polaroid/core/cl_core.lua")

AddCSLuaFile("polaroid/core/cl_slawer_mayor_fix.lua")
AddCSLuaFile("polaroid/core/cl_thirdperson_remover.lua")

------------

AddCSLuaFile("polaroid/config.lua")
include("polaroid/config.lua")

------------

if SERVER then
	resource.AddWorkshop("2456881554") -- content (sounds, materials, models)
	include("polaroid/core/sv_core.lua")
else
	include("polaroid/core/cl_util.lua")
	include("polaroid/core/cl_menu.lua")
	include("polaroid/core/cl_editor_tools.lua")
	include("polaroid/core/cl_editor.lua")
	include("polaroid/core/cl_core.lua")

	include("polaroid/core/cl_slawer_mayor_fix.lua")
	include("polaroid/core/cl_thirdperson_remover.lua")
end

hook.Run("Polaroid/Loaded")
