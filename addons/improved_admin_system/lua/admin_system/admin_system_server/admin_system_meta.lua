----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/
local Admin_Sys = FindMetaTable( "Player" )

function Admin_Sys:SysCloakEnabled()
     self:SetNoDraw(true)
     for _, v in pairs(self:GetWeapons()) do
          v:SetNoDraw(true)
     end
     local Admin_SysFindClass = ents.FindByClass("physgun_beam")
     for _, v in ipairs(Admin_SysFindClass) do
          if (v:GetParent() ~= self) then
               continue
          end
          v:SetNoDraw(true)
     end

     net.Start("Admin_Sys:SyncValue")
     net.WriteUInt( 1, 4 )
     net.WriteBool(true)
     net.Send(self)
end

function Admin_Sys:SysCloakDisabled()
     self:SetNoDraw(false)
     for _, v in pairs(self:GetWeapons()) do
          v:SetNoDraw(false)
     end
     local Admin_SysFindClass = ents.FindByClass("physgun_beam")
     for _, v in ipairs(Admin_SysFindClass) do
          if (v:GetParent() ~= self) then
               continue
          end
          v:SetNoDraw(false)
     end

     net.Start("Admin_Sys:SyncValue")
     net.WriteUInt( 1, 4 )
     net.WriteBool(false)
     net.Send(self)
end

function Admin_Sys:SysGodEnabled()
     self:AddFlags( FL_GODMODE )
     self.SysGodMode = true

     net.Start("Admin_Sys:SyncValue")
     net.WriteUInt( 2, 4 )
     net.WriteBool(self.SysGodMode)
     net.Send(self)
end

function Admin_Sys:SysGodDisabled()
     self:RemoveFlags( FL_GODMODE )
     self.SysGodMode = false

     net.Start("Admin_Sys:SyncValue")
     net.WriteUInt( 2, 4)
     net.WriteBool(self.SysGodMode)
     net.Send(self)
end

function Admin_Sys:SysNoClipEnabled()
     self:SetMoveType(MOVETYPE_NOCLIP)
end

function Admin_Sys:SysNoClipDisabled()
     self:SetMoveType(MOVETYPE_WALK)
end

function Admin_Sys:SysStreamerModEnabled()
     self.SysStreamerMod = true
	 
	 net.Start("Admin_Sys:SyncValue")
     net.WriteUInt( 3, 4 )
     net.WriteBool(self.SysStreamerMod)
     net.Send(self)
end

function Admin_Sys:SysStreamerModDisabled()
     self.SysStreamerMod = false
	 
	 net.Start("Admin_Sys:SyncValue")
     net.WriteUInt( 3, 4 )
     net.WriteBool(self.SysStreamerMod)
     net.Send(self)
end