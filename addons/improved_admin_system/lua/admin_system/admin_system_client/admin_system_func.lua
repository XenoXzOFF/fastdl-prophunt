----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/
--- All functions that require some performance are done on the client side, let's protect the server side from any annoying computation.

local Admin_Sys_w, Admin_Sys_h, Admin_Sys_BlurMat, Admin_Sys_BlurMat_Number, Admin_Sys_NotfiDelay, Admin_Sys_Clc = 1920, 1080, Material("pp/blurscreen"), 3, 5
local Admin_Sys_TicketDot_Count, Admin_Sys_Dot_Curtime, Admin_SysNBCur = 0, 0, 0

local Admin_Sys_TradTimeTbl = {
     day = "jour",
     year = "année",
     week = "semaine",
     hour = "heure",
     second = "seconde"
}

local function Admin_SysCheckStatus()
     local Admin_Sys_UIInt = net.ReadUInt(4)
     local Admin_Sys_Bool = net.ReadBool()

     if (Admin_Sys_UIInt == 1) then
          Admin_System_Global.SysCloakStatus = not Admin_Sys_Bool and false or Admin_Sys_Bool and true
     elseif (Admin_Sys_UIInt == 2) then
          Admin_System_Global.SysGodModeStatus = not Admin_Sys_Bool and false or Admin_Sys_Bool and true
     elseif (Admin_Sys_UIInt == 3) then
          Admin_System_Global.SysStreamerMod = not Admin_Sys_Bool and false or Admin_Sys_Bool and true
     end
end

local function Admin_SysCheckStatusLoop() -- (Temporary) potiential fix for an addon that causes problem and disabled cloak for no reason (Contact me if you know the incompatible addon).
     if not Admin_System_Global.SysCloakStatus then
          return
     end
     local Admin_Sys = CurTime()

     if Admin_Sys > Admin_SysNBCur then
          local Admin_Sys_Ply = LocalPlayer()

          if (Admin_System_Global.SysCloakStatus ~= Admin_Sys_Ply:GetNoDraw()) then
               net.Start("Admin_Sys:RenderFix")
			   net.SendToServer()
			   
               Admin_Sys_Ply:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["notif_cloakdisabled"])
          end
          Admin_SysNBCur = CurTime() + 5
     end
end ---- Loop loaded only on the client, save server load

function Admin_System_Global:TradTime(Admin_Sys_Time)
     local Admin_Sys_Time = Admin_Sys_Time
     if Admin_System_Global.Mode_Lang == "fr" then
          for k, v in pairs(Admin_Sys_TradTimeTbl) do
               if string.find(Admin_Sys_Time, tostring(k)) then Admin_Sys_Time = string.Replace(Admin_Sys_Time, tostring(k), v) end
          end
     end
	 
     return Admin_Sys_Time
end

function Admin_System_Global:Admin_Sys_TicketDot()
     local Admin_Sys_Dot_RT = ""
     local Admin_Sys_Ticket_Tim = Admin_Sys_Dot_Curtime - CurTime()

     if Admin_Sys_Ticket_Tim < 0 then
          Admin_Sys_TicketDot_Count = Admin_Sys_TicketDot_Count + 1
          if (Admin_Sys_TicketDot_Count > 3) then
               Admin_Sys_TicketDot_Count = 0
          end
          Admin_Sys_Dot_Curtime = CurTime() + math.random(0.2, 2)
     end
     for i = 1, Admin_Sys_TicketDot_Count do
          Admin_Sys_Dot_RT = Admin_Sys_Dot_RT .. "."
     end

     return Admin_Sys_Dot_RT
end

function Admin_System_Global:Size_Auto(Admin_Sys_wd, Admin_Sys_String, Admin_Sys_DisableRdm)
     Admin_Sys_DisableRdm = Admin_Sys_DisableRdm or Admin_System_Global.Admin_System_AutoRdm
     if Admin_Sys_DisableRdm then        
          if Admin_Sys_String == "h" or not Admin_Sys_String then
               Admin_Sys_Clc = Admin_Sys_wd / Admin_Sys_h * ScrH()
          elseif Admin_Sys_String == "w" then
               Admin_Sys_Clc = Admin_Sys_wd / Admin_Sys_w * ScrW()
          end
     end

     return math.Round(Admin_Sys_Clc or Admin_Sys_wd)
end

function Admin_System_Global:Notification( Admin_Sys_String )
     local Admin_Sys_Cur = CurTime() + 0.4
     local Admin_Sys_TableCount = #Admin_Sys_Table_Notif + 1

     Admin_Sys_Table_Notif[Admin_Sys_TableCount] = {Admin_Sys_String = Admin_Sys_String, Admin_Sys_CurPrim = Admin_Sys_Cur, Admin_Sys_CurSec = Admin_Sys_Cur + Admin_Sys_NotfiDelay}
     LocalPlayer():EmitSound( Admin_System_Global.NotifPopup_Sound, 100, 100, 0.25, CHAN_AUTO )
end

function Admin_System_Global:Gui_Blur(Admin_Sys_Frame, Admin_Sys_Float, Admin_Sys_Col, Admin_Sys_Bord)
     local x, y = Admin_Sys_Frame:LocalToScreen(0, 0)

     Admin_Sys_Float = Admin_Sys_Float or 5
     surface.SetDrawColor(255, 255, 255)
     surface.SetMaterial(Admin_Sys_BlurMat)
     for i = 1, Admin_Sys_BlurMat_Number do
          Admin_Sys_BlurMat:SetFloat("$blur", (i / 3) * Admin_Sys_Float)
          Admin_Sys_BlurMat:Recompute()
          render.UpdateScreenEffectTexture()
          surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
     end

     draw.RoundedBoxEx( Admin_Sys_Bord, 0, 0, Admin_Sys_Frame:GetWide(), Admin_Sys_Frame:GetTall(), Admin_Sys_Col, true, true, true, true )
end
if Admin_System_Global.FixForceRender then
     hook.Add("Think", "Admin_SysCheckStatusLoop", Admin_SysCheckStatusLoop)
end
net.Receive("Admin_Sys:SyncValue", Admin_SysCheckStatus)

---- Load fonts
surface.CreateFont(
"Admin_Sys_Font_T1",
{
     font = "Rajdhani Bold",
     size = Admin_System_Global:Size_Auto(18, "w"),
     weight = 250,
     antialias = true
}
)

surface.CreateFont(
"Admin_Sys_Font_T2",
{
     font = "Rajdhani Bold",
     size = Admin_System_Global:Size_Auto(15, "w"),
     weight = 250,
     antialias = true
}
)

surface.CreateFont(
"Admin_Sys_Font_T3",
{
     font = "Rajdhani Bold",
     size = Admin_System_Global:Size_Auto(17, "w"),
     weight = 100,
     antialias = true
}
)

surface.CreateFont("Admin_Sys_Font_T4",{
     font = "Rajdhani Medium",
     size = Admin_System_Global:Size_Auto(22, "w"),
     weight = 1,
     antialias = true
}
)

surface.CreateFont("Admin_Sys_Font_T6",{
     font = "Rajdhani Medium",
     size = Admin_System_Global:Size_Auto(18, "w"),
     weight = 1,
     antialias = true
}
)