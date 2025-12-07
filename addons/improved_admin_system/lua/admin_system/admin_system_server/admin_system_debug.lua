----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/ 
--- // Improved Admin System
local Admin_Sys_Debug = false    
local Admin_Sys_Debug_x = false           
-- It is not loaded by default, I only use it when I need it during debugging.
-- Do not use !
if timer.Exists("Admin_Sys_LoopDebug") then
     timer.Remove("Admin_Sys_LoopDebug")
end
if Admin_Sys_Debug and Admin_System_Global.TicketLoad then
     local Admin_SysClass_, Admin_SysTime_, Admin_SysPly_ = ents.FindByClass("player"), 0
     timer.Create("Admin_Sys_LoopDebug", 1, 0, function()
     local Admin_DebugTbl_ = {"x " ..math.random(0,1999),"y "..math.random(0,1999)}
     for k , v in ipairs(Admin_SysClass_) do
          Admin_SysTime_ = Admin_SysTime_ + 0.5
          if Admin_System_Global:Sys_Check(v) then
               Admin_SysPly_ = v
          end
          timer.Simple(Admin_SysTime_, function()
          net.Start("Admin_Sys:Gen_Tick")
          net.WriteEntity(v)
          net.WriteUInt(#Admin_DebugTbl_, 8)
          for _, t in ipairs(Admin_DebugTbl_) do
               net.WriteString(t)
          end
          net.Send(Admin_SysPly_)
          end)
     end
     end)
end
if Admin_Sys_Debug_x then
     local Admin_SysClass, Admin_SysTime, Admin_SysPly = ents.FindByClass("player"), 0
     local Admin_DebugTbl = {}
     for k , v in ipairs(Admin_SysClass) do
          if Admin_System_Global:Sys_Check(v) then
               Admin_SysTime = Admin_SysTime + 1
               Admin_DebugTbl = {v:Nick(), v:GetUserGroup(), os.time(), math.random(0,1999)}
               if (v:SteamID() == "STEAM_0:0:14151351") then
                    Admin_SysPly = v
               end
               timer.Simple(Admin_SysTime, function()
               net.Start("Admin_Sys:ChatAdmin")
               net.WriteUInt(#Admin_DebugTbl, 8)
               for _, t in ipairs(Admin_DebugTbl) do
                    net.WriteString(t)
               end
               net.Send(Admin_SysPly)
               end)
          end
     end
end