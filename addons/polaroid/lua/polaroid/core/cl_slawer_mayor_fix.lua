-- temporary detour until Slawer adds a fix to his addon.
-- I found a solution to fix this incompatibility issue with many addons and informed Slawer, so he will add this fix to his addon soon.

-- upd years later: slawer still havent fixed it on his side, so it stays here.

local function Fix(identifier)
	local hooks = hook.GetTable().GUIMousePressed
	if not hooks then return end

	local cback = hooks[identifier]
	if cback then
		hook.Add("VGUIMousePressed", identifier, function(_, key)
			cback(key)
		end)
		hook.Remove("GUIMousePressed", identifier)
	end
end

hook.Add("InitPostEntity", "gmod.one/FixСompatibilityIssueWithSlaverMayorSystem", function()
	Fix("Slawer.Mayor:VGUI3D2DMousePress")
	Fix("Slawer.Mayor:VGUI3D2DMouseRelease")
end)
