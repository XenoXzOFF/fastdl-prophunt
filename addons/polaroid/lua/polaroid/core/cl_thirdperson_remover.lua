-- kinda hacky, but most reliable way.

local Polaroid = g1_Polaroid

if Polaroid.config.forceDisableThirdpersonHooks == false then return end

local filter = {Call = true}
local proxy = {}
local disableHooks = {
	CalcView = true,
	ShouldDrawLocalPlayer = true
}

local function checkEquipped()
	local swep = LocalPlayer():GetActiveWeapon()
	return IsValid(swep) and swep.IsPolaroidCamera
end

function proxy.Call(event, ...)
	if Polaroid.config.forceDisableThirdpersonHooks and disableHooks[event] and checkEquipped() then return end

	return Polaroid.origHookCall(event, ...)
end

if hook.Call ~= Polaroid.origHookCall then
	Polaroid.origHookCall = hook.Call
end

hook.Call = nil
setmetatable(hook, {
	__index = proxy,
	__newindex = function(me, k, v)
		if v and filter[k] then
			Polaroid.origHookCall = v
		else
			rawset(me, k, v)
		end
	end
})
