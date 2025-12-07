----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/ 
local Admin_Sys_Frame_Cmd, Admin_Sys_Cmd_GeneralTbl = nil, nil

local function Admin_Sys_AnimQuad(AddSys_Delta, AddSys_PosA, AddSys_PosB)
	return AddSys_PosB * (AddSys_Delta % 2) + AddSys_PosA
end

local function Admin_Sys_General_Cmd()
if IsValid(Admin_Sys_Frame_Cmd) then
     return
end
if not Admin_Sys_Cmd_GeneralTbl then
     Admin_Sys_Cmd_GeneralTbl = Admin_System_Global:AddCmdBut(nil, nil, nil, nil, true) or {}
end

local Admin_Sys_CountTable, Admin_Sys_TableMax = #Admin_Sys_Cmd_GeneralTbl, 3
local Admin_Sys_Math, Admin_Sys_Count_Math = math.ceil(Admin_Sys_CountTable / Admin_Sys_TableMax), 0
local Admin_Sys_Count_MT = Admin_Sys_Math - Admin_Sys_Math
local Admin_Sys_Gradient, Admin_Sys_Col, Admin_SysCountAnim = surface.GetTextureID( "gui/gradient" ), Color(52,73,94), 0
Admin_Sys_Frame_Cmd = vgui.Create( "DFrame" )
local Admin_Sys_Frame_Dimage = vgui.Create("DImageButton", Admin_Sys_Frame_Cmd )

Admin_Sys_Frame_Cmd:SetTitle( "" )
Admin_Sys_Frame_Cmd:SetSize( Admin_System_Global:Size_Auto(430, "w"), Admin_Sys_Math * Admin_System_Global:Size_Auto(50, "h") + Admin_System_Global:Size_Auto(80, "h") )
Admin_Sys_Frame_Cmd:ShowCloseButton(false)
Admin_Sys_Frame_Cmd:Center()
Admin_Sys_Frame_Cmd:MakePopup()
Admin_Sys_Frame_Cmd:AlphaTo(5, 0, 0)
Admin_Sys_Frame_Cmd:AlphaTo(255, 1.5, 0)
local Admin_Sys_Frame_Anim = Derma_Anim("Admin_SysAnimLoad", Admin_Sys_Frame_Cmd, function(pnl, anim, delta, data)
	pnl:SetPos(Admin_Sys_AnimQuad(delta, 0, ScrW() / 2 - Admin_System_Global:Size_Auto(225, "w")), ScrH() / 2 - Admin_System_Global:Size_Auto(125, "h"))
end)
Admin_Sys_Frame_Anim:Start(1)
local Admin_SysCurAnim = CurTime() + 1
Admin_Sys_Frame_Cmd.AnimationThink = function()
if Admin_Sys_Frame_Anim:Active() then
     Admin_Sys_Frame_Anim:Run()
     if CurTime() > Admin_SysCurAnim then
          Admin_Sys_Frame_Cmd:SetAnimationEnabled( false )
     end
end
end
Admin_Sys_Frame_Cmd.Paint = function( self, w, h )
local Admin_Sys_Abs = math.abs(math.sin(CurTime() * 1.5) * 170)
Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 8)
draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Admin_System_Global.CmdGeneralColor )
draw.DrawText( Admin_System_Global.lang["general_cmd"], "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.CmdGeneralColorTitle, TEXT_ALIGN_CENTER )
draw.DrawText("v" ..Admin_System_Global.Version.. " by Inj3", "Admin_Sys_Font_T1", w-Admin_System_Global:Size_Auto(5, "w"),h - Admin_System_Global:Size_Auto(18, "h"), Color(Admin_Sys_Abs, Admin_Sys_Abs, Admin_Sys_Abs, Admin_Sys_Abs), TEXT_ALIGN_RIGHT)
end

for Admin_Sys_Count = 1 , Admin_Sys_CountTable do
     local Admin_Sys_Frame_BT, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", Admin_Sys_Frame_Cmd ), 0, 0.05

     Admin_Sys_Frame_BT:SetSize( Admin_System_Global:Size_Auto(130, "w"), Admin_System_Global:Size_Auto(25, "h") )
     Admin_Sys_Frame_BT:SetText( "" )
     Admin_Sys_Frame_BT:SetIcon(Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Icon)
     Admin_Sys_Frame_BT:Center()
     local Admin_Sys_Count_Math_ = Admin_Sys_Count_Math
     local Admin_Sys_Count_MT_ = Admin_Sys_Count_MT
     local Admin_Sys_Frame_Anim = Derma_Anim("Admin_SysAnimLoad" ..Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Name, Admin_Sys_Frame_BT, function(pnl, anim, delta, data)
     pnl:SetPos(Admin_Sys_AnimQuad(delta, 0, Admin_Sys_Count_Math_ * Admin_System_Global:Size_Auto(140, "w") + Admin_System_Global:Size_Auto(10, "w")), Admin_Sys_AnimQuad(delta, 0, Admin_Sys_Count_MT_ * Admin_System_Global:Size_Auto(60, "h") + Admin_System_Global:Size_Auto(50, "h")))
     end)
	 Admin_Sys_Frame_Anim:Start(Admin_SysCountAnim + 1)
     Admin_Sys_Frame_BT.Think = function(self)
     if Admin_Sys_Frame_Anim:Active() then
          Admin_Sys_Frame_Anim:Run()
     end
end
Admin_Sys_Frame_BT.Paint = function( self, w, h )
surface.SetDrawColor( Admin_Sys_Col )
surface.SetTexture( Admin_Sys_Gradient )
surface.DrawTexturedRect( 0, 0, w + 50 , h )
if self:IsHovered() then
     Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(3, "w"))
else
     Admin_Sys_Lerp = 0
end
draw.RoundedBox( 6, 2, 0, Admin_Sys_Lerp, 1, Color(192, 57, 43, 230) )
if Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Commands == "say " ..Admin_System_Global.Mode_Cmd then
     draw.DrawText(LocalPlayer():AdminStatusCheck() and "Admin Mode ✘" or "Admin Mode ✔", "Admin_Sys_Font_T3", w/2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(5, "h"), LocalPlayer():AdminStatusCheck() and Color(192, 57, 43) or Color(39, 174, 96), TEXT_ALIGN_CENTER )
     return
end
draw.DrawText(Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Name or "nil", "Admin_Sys_Font_T3", w/2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.CmdGeneralColorButText, TEXT_ALIGN_CENTER )
end
Admin_Sys_Frame_BT.DoClick = function()
if Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Commands == "wip" then
     LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["general_cmd_available"])
     return
end
if not Admin_System_Global.TicketLoad and Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Commands == Admin_System_Global.Ticket_Cmd then
     LocalPlayer():PrintMessage( HUD_PRINTTALK, "This feature is disabled by owner.")
     return
end

LocalPlayer():ConCommand( Admin_Sys_Cmd_GeneralTbl[Admin_Sys_Count].Commands )
if timer.Exists("Admin_Sys_Frame_Anim") then
     timer.Remove("Admin_Sys_Frame_Anim")
end
Admin_Sys_Frame_Cmd:Remove()
end

Admin_Sys_Count_Math = Admin_Sys_Count_Math + 1

if Admin_Sys_Count_Math >= Admin_Sys_TableMax then
Admin_Sys_Count_Math = 0
Admin_Sys_Count_MT = Admin_Sys_Count_MT + 1
end
end

Admin_Sys_Frame_Dimage:SetPos(Admin_Sys_Frame_Cmd:GetWide() - Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(5, "h"))
Admin_Sys_Frame_Dimage:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_Sys_Frame_Dimage:SetImage( "icon16/cross.png" )
function Admin_Sys_Frame_Dimage:Paint(w,h) end
Admin_Sys_Frame_Dimage.DoClick = function()
if timer.Exists("Admin_Sys_Frame_Anim") then
     timer.Remove("Admin_Sys_Frame_Anim")
end
Admin_Sys_Frame_Cmd:Remove()
end
end
net.Receive("Admin_Sys:General", Admin_Sys_General_Cmd)