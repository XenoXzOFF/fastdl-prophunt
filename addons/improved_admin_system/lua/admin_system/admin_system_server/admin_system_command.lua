----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

local Admin_Sys_Table_Cmd = {

[Admin_System_Global.Mode_AddCmd_NoClip] = {
     func = function(ply, cmd, args)
     if IsValid(ply) and Admin_System_Global:Sys_Check(ply) then
          if (ply:GetMoveType() == MOVETYPE_NOCLIP) then
		  
               ply:SysNoClipDisabled()
          else
		  
               ply:SysNoClipEnabled()
          end

          Admin_System_Global:Notification(ply, ply:GetMoveType() == MOVETYPE_NOCLIP and Admin_System_Global.lang["cmd_noclipact"] or  Admin_System_Global.lang["cmd_noclipdesact"])
     end
end
},

[Admin_System_Global.Mode_AddCmd_Cloak] = {
     func = function(ply, cmd, args)

     if IsValid(ply) and Admin_System_Global:Sys_Check(ply) then
          if ply:GetNoDraw() then

               ply:SysCloakDisabled()
          else

               ply:SysCloakEnabled()
          end

          Admin_System_Global:Notification(ply, ply:GetNoDraw() and Admin_System_Global.lang["cmd_cloakacti"] or  Admin_System_Global.lang["cmd_cloakdesact"])
     end
end
},

[Admin_System_Global.Mode_AddCmd_GodMod] = {
     func = function(ply, cmd, args)

     if IsValid(ply) and Admin_System_Global:Sys_Check(ply) then
          if ply.SysGodMode then
		  
               ply:SysGodDisabled()
          else
		  
               ply:SysGodEnabled()
          end
          Admin_System_Global:Notification(ply, ply.SysGodMode and Admin_System_Global.lang["cmd_godmodact"] or  Admin_System_Global.lang["cmd_godmoddesact"])
     end
end
},

[Admin_System_Global.Ticket_Cmd] = {
     func = function(ply, cmd, args)

     if IsValid(ply) then
          ply.Admin_Sys_CheckBool = true

          net.Start("Admin_Sys:Crea_Tick")
          net.Send(ply)
     end
end
},

[Admin_System_Global.Stats_Cmd] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 1)
end
},

[Admin_System_Global.ZoneAdmin_Cmd] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 2)
end
},

[Admin_System_Global.Remb_Cmd] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 3)
end
},

[Admin_System_Global.Cmd_General] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 4)
end
},

[Admin_System_Global.Mode_Cmd] = {
     func = function(ply, cmd, args)

     ply:Status_()
end
},

[Admin_System_Global.ModeAdmin_Chx] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 5)
end
},

[Admin_System_Global.Service_Cmd] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 6)
end
},

[Admin_System_Global.Chat_Cmd] = {
     func = function(ply, cmd, args)

     Admin_System_Global:Sys_Cmd(ply, 7)
end
},

[Admin_System_Global.StreamMod_Cmd] = {
     func = function(ply, cmd, args)

     if Admin_System_Global.StreamMod[ply:GetUserGroup()] then

          if ply.SysStreamerMod then
               ply:SysStreamerModDisabled()
			   
			   Admin_System_Global:Notification(ply, "Streamer Mode disabled")
          else
               ply:SysStreamerModEnabled()
			   
			   Admin_System_Global:Notification(ply, "Streamer Mode enabled")
          end
     end

end
}

}

for k, v in pairs(Admin_Sys_Table_Cmd) do
if not Admin_System_Global.TicketLoad and k == Admin_System_Global.Ticket_Cmd then continue end
     concommand.Add(k, v.func)
end 