local Admin_Sys_Service, Admin_Mod_Frame, Admin_Mod_Frame_2, Admin_Sys_Count, Admin_SysRefreshT = nil, nil, nil, 0, "AdminSys_RefreshOnlineAdmin"

local function Admin_SysRefreshOnlineAd(Admin_Sys_Service_ScrollBar)
     local Admin_SysRefreshTbl = {}
     Admin_Sys_Service_ScrollBar:GetCanvas():Clear()
     local Admin_SysFindClass = ents.FindByClass("player")

     Admin_Sys_Count = 0
     for _, v in ipairs(Admin_SysFindClass) do
          if not Admin_System_Global.General_Permission[v:GetUserGroup()] then continue end
          Admin_Sys_Count = Admin_Sys_Count + 1

          local Admin_Sys_Service_Dlabel = vgui.Create("DLabel", Admin_Sys_Service_ScrollBar)
          Admin_Sys_Service_Dlabel:SetSize( Admin_System_Global:Size_Auto(203, "w"), Admin_System_Global:Size_Auto(37, "h") )
          Admin_Sys_Service_Dlabel:SetPos( Admin_System_Global:Size_Auto(70, "w"), Admin_System_Global:Size_Auto(50, "h") * Admin_Sys_Count - Admin_System_Global:Size_Auto(48, "h") )
          Admin_Sys_Service_Dlabel:SetText("")
          Admin_Sys_Service_Dlabel.RefreshPly = v
          Admin_Sys_Service_Dlabel.Think = function()
          if not IsValid(v) then
               Admin_Sys_Service_Dlabel:Remove()
               Admin_SysRefreshOnlineAd(Admin_Sys_Service_ScrollBar)
          end
     end
     Admin_Sys_Service_Dlabel.Paint = function(self,w,h)
     draw.RoundedBox( 3, 0, 0, w, h, Color(52,73,94) )
     draw.DrawText(v:Nick() or "Hors Ligne", "Admin_Sys_Font_T1", w/2, 1, Color(255,255,255, 250), TEXT_ALIGN_CENTER)
     draw.DrawText(v:AdminStatusCheck() and "✔ En Service" or "✘ Hors Service", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(18, "h"), v:AdminStatusCheck() and Color(0,175,0, 250) or Color(255,0,0, 250), TEXT_ALIGN_CENTER)
end
table.insert(Admin_SysRefreshTbl, {panel = Admin_Sys_Service_Dlabel})
end
end

local function Admin_Syst_Online()
if IsValid(Admin_Sys_Service) then return end
Admin_Sys_Service = vgui.Create("DFrame")
local Admin_Sys_Service_ScrollBar = vgui.Create( "DScrollPanel", Admin_Sys_Service)
local Admin_Sys_Service_Frm = vgui.Create("DImageButton", Admin_Sys_Service)
Admin_SysRefreshOnlineAd(Admin_Sys_Service_ScrollBar)

Admin_Sys_Service:SetTitle("")
Admin_Sys_Service:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(350, "h"))
Admin_Sys_Service:SetDraggable(true)
Admin_Sys_Service:ShowCloseButton(false)
Admin_Sys_Service:Center()
Admin_Sys_Service:MakePopup()
timer.Create(Admin_SysRefreshT, 8, 0, function()
Admin_SysRefreshOnlineAd(Admin_Sys_Service_ScrollBar)
end)
Admin_Sys_Service.Paint = function(self, w, h)
Admin_System_Global:Gui_Blur(self, Admin_System_Global:Size_Auto(1, "w"), Color( 0, 0, 0, 150 ), 8)
draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94) )
draw.DrawText("Administrateur en service" ,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(4, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
if Admin_Sys_Count <= 0 then
     draw.DrawText("Aucun Administrateur en ligne" ,"Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(150, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
end
draw.DrawText("Refresh dans : " ..math.Round(timer.TimeLeft( Admin_SysRefreshT ),1),"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(27, "h"),Color(255, 255, 250), TEXT_ALIGN_CENTER)
draw.DrawText("Administrateur en ligne : " ..Admin_Sys_Count,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(43, "h"),Color(255, 255, 250), TEXT_ALIGN_CENTER)
end

Admin_Sys_Service_ScrollBar:SetSize(Admin_System_Global:Size_Auto(290, "w"), Admin_System_Global:Size_Auto(265, "h"))
Admin_Sys_Service_ScrollBar:SetPos(-Admin_System_Global:Size_Auto(50, "w"), Admin_System_Global:Size_Auto(65, "h"))
local Admin_Sys_Service_Vbar = Admin_Sys_Service_ScrollBar:GetVBar()
Admin_Sys_Service_Vbar:SetSize(Admin_System_Global:Size_Auto(12, "w"), Admin_System_Global:Size_Auto(7, "h"))
Admin_Sys_Service_Vbar.Paint = function( self, w, h )
draw.RoundedBox(6, 0, 0, w, h, Color(255,255,255,15))
end
Admin_Sys_Service_Vbar.btnUp.Paint = function( self, w, h )
draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
end
Admin_Sys_Service_Vbar.btnDown.Paint = function( self, w, h )
draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
end
Admin_Sys_Service_Vbar.btnGrip.Paint = function( self, w, h )
draw.RoundedBox(2, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
end

Admin_Sys_Service_Frm:SetPos(Admin_System_Global:Size_Auto(230, "w"), Admin_System_Global:Size_Auto(4, "h"))
Admin_Sys_Service_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
Admin_Sys_Service_Frm:SetImage("icon16/cross.png")
function Admin_Sys_Service_Frm:Paint(w, h) end
Admin_Sys_Service_Frm.DoClick = function()
Admin_Sys_Service:Remove()
if timer.Exists(Admin_SysRefreshT) then
timer.Remove(Admin_SysRefreshT)
end
end 

local Admin_SysPos_Frame_BT_Sv1, Admin_SysPos_FrameB = vgui.Create("DImageButton", Admin_Sys_Service )
Admin_SysPos_Frame_BT_Sv1:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(4, "h"))
Admin_SysPos_Frame_BT_Sv1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
Admin_SysPos_Frame_BT_Sv1.DoClick = function()
Admin_Sys_Service:SetAlpha(50)
Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/monitor.png" )
Admin_Sys_Service:SetMouseInputEnabled(false)
Admin_Sys_Service:SetKeyboardInputEnabled(false)
gui.EnableScreenClicker(false)
timer.Simple(1,function()
if not IsValid(Admin_Sys_Service) then return end
local x, y = Admin_Sys_Service:GetPos()
Admin_SysPos_FrameB = vgui.Create( "DFrame" )
Admin_SysPos_FrameB:SetTitle( "" )
Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
Admin_SysPos_FrameB:SetMouseInputEnabled(true)
Admin_SysPos_FrameB:ShowCloseButton(false)
Admin_SysPos_FrameB:SetPos(x, y)
Admin_SysPos_FrameB.Think = function()
if Admin_SysPos_FrameB:IsHovered() then
     if IsValid(Admin_Sys_Service) then
          Admin_Sys_Service:SetAlpha(255)
          Admin_Sys_Service:SetMouseInputEnabled(true)
          Admin_Sys_Service:SetKeyboardInputEnabled(true)
          gui.EnableScreenClicker(true)
          Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
     end
     Admin_SysPos_FrameB:Remove()
end
end
Admin_SysPos_FrameB.Paint = function( self, w, h ) end
end)
end

end
net.Receive("Admin_Sys:Service", Admin_Syst_Online)

local function Admin_Sys_AdminMod_ChxFunc()
if IsValid(Admin_Mod_Frame) then return end
local Admin_Sys_Ply = LocalPlayer()

Admin_Mod_Frame = vgui.Create("DFrame")
Admin_Mod_Frame_2 = vgui.Create("DFrame")
local Admin_Mod_Frame_Frm = vgui.Create("DImageButton", Admin_Mod_Frame)
local Admin_Mod_Frame_BT_C = vgui.Create("DButton", Admin_Mod_Frame )
local Admin_Mod_Frame_BT = vgui.Create("DButton", Admin_Mod_Frame )
local Admin_Mod_Frame_BT_1 = vgui.Create("DButton", Admin_Mod_Frame )
local Admin_Mod_Frame_BT_2 = vgui.Create("DButton", Admin_Mod_Frame )
local Admin_SysPos_Frame_BT_Sv1 = vgui.Create("DImageButton", Admin_Mod_Frame )
local Admin_Sys_Gradient, Admin_Sys_Col = surface.GetTextureID( "models/props_combine/com_shield001a" ), Color(52,73,94)
local Admin_Sys_Gradient_ = surface.GetTextureID( "gui/gradient" )

Admin_Mod_Frame:SetTitle("")
Admin_Mod_Frame:ShowCloseButton(false)
Admin_Mod_Frame:SetDraggable( true )
Admin_Mod_Frame:SetSize(Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(120, "h"))
Admin_Mod_Frame:SetPos(ScrW() / 2 - Admin_System_Global:Size_Auto(225, "w"), ScrH() / 2 - Admin_System_Global:Size_Auto(60, "h"))
Admin_Mod_Frame:MakePopup() 
Admin_Mod_Frame.Paint = function(self, w, h)
Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 150 ), 5)
draw.RoundedBoxEx(5, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94), true, true, false, false)
surface.SetDrawColor( Admin_Sys_Col )
surface.SetTexture( Admin_Sys_Gradient )
surface.DrawTexturedRect( 0, h/2 + 10, w, 1 )
draw.DrawText("Admin Configuration" ,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
end

Admin_Mod_Frame_2:SetTitle("")
Admin_Mod_Frame_2:SetPos(0, 0)
Admin_Mod_Frame_2:SetSize(Admin_System_Global:Size_Auto(330, "w"), Admin_System_Global:Size_Auto(24, "h"))
Admin_Mod_Frame_2:ShowCloseButton(false)
Admin_Mod_Frame_2:SetDraggable( false )
Admin_Mod_Frame_2:MakePopup()
Admin_Mod_Frame_2.Think = function()
local t, u = Admin_Mod_Frame:GetPos()
Admin_Mod_Frame_2:SetPos(t + 10, u + Admin_System_Global:Size_Auto(122, "h"))
end
Admin_Mod_Frame_2.Paint = function(self, w, h)
Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 5)
draw.RoundedBoxEx(5, 0, 0, w, 1, Color(255, 255, 255, 150), true, true, true, true)
draw.DrawText("Status :" ,"Admin_Sys_Font_T1", 27, Admin_System_Global:Size_Auto(4, "h"), Color(255, 255, 250),TEXT_ALIGN_CENTER)
draw.DrawText( Admin_Sys_Ply:GetNoDraw() and "Cloak : ON ✔" or "Cloak : OFF ✘" ,"Admin_Sys_Font_T1",55, Admin_System_Global:Size_Auto(4, "h"), Admin_Sys_Ply:GetNoDraw() and Color(236, 240, 241) or Color(231, 76, 60),TEXT_ALIGN_LEFT)
draw.DrawText("- " ..((Admin_System_Global.SysGodModeStatus and "Godmod : ON ✔") or "Godmod : OFF ✘").. " -" ,"Admin_Sys_Font_T1",135, Admin_System_Global:Size_Auto(4, "h"), Admin_System_Global.SysGodModeStatus and Color(236, 240, 241) or Color(231, 76, 60),TEXT_ALIGN_LEFT)
draw.DrawText((Admin_Sys_Ply:GetMoveType() == MOVETYPE_NOCLIP) and "Noclip : ON ✔" or "Noclip : OFF ✘" ,"Admin_Sys_Font_T1",245, Admin_System_Global:Size_Auto(4, "h"), (Admin_Sys_Ply:GetMoveType() == MOVETYPE_NOCLIP) and Color(236, 240, 241) or Color(231, 76, 60),TEXT_ALIGN_LEFT)
end

local Admin_Sys_Lerp, Admin_Sys_Lerp_An = 0, 0.05
Admin_Mod_Frame_BT_C:SetPos( Admin_System_Global:Size_Auto(75, "w"), Admin_System_Global:Size_Auto(35, "h") )
Admin_Mod_Frame_BT_C:SetSize( Admin_System_Global:Size_Auto(215, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Mod_Frame_BT_C:SetText( "" )
Admin_Mod_Frame_BT_C:SetIcon("icon16/eye.png")
Admin_Mod_Frame_BT_C.Paint = function( self, w, h )
surface.SetDrawColor( Admin_Sys_Col )
surface.SetTexture( Admin_Sys_Gradient_ )
surface.DrawTexturedRect( 0, 0, w + 40, h )
if self:IsHovered() then
     Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(4, "w"))
else
     Admin_Sys_Lerp = 0
end
draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp, 1, Color(	41, 128, 185) )
draw.DrawText(Admin_Sys_Ply:AdminStatusCheck() and "Désactiver Mode Admin" or "Activer Mode Admin", "Admin_Sys_Font_T1", w/2+5, 4, Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Mod_Frame_BT_C.DoClick = function()
LocalPlayer():ConCommand( Admin_System_Global.Mode_Cmd )
end

local Admin_SysPos_FrameB
Admin_SysPos_Frame_BT_Sv1:SetPos(7,4)
Admin_SysPos_Frame_BT_Sv1:SetSize(17,17)
Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
Admin_SysPos_Frame_BT_Sv1.DoClick = function()

Admin_Mod_Frame:SetAlpha(50)
Admin_Mod_Frame_2:SetAlpha(50)
Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/monitor.png" )
Admin_Mod_Frame:SetMouseInputEnabled(false)
Admin_Mod_Frame:SetKeyboardInputEnabled(false)
Admin_Mod_Frame_2:SetMouseInputEnabled(false)
Admin_Mod_Frame_2:SetKeyboardInputEnabled(false)
gui.EnableScreenClicker(false)

timer.Simple(1,function()
if not IsValid(Admin_Mod_Frame) or not IsValid(Admin_Mod_Frame_2) then return end
local x, y = Admin_Mod_Frame:GetPos()
Admin_SysPos_FrameB = vgui.Create( "DFrame" )
Admin_SysPos_FrameB:SetTitle( "" )
Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
Admin_SysPos_FrameB:SetMouseInputEnabled(true)
Admin_SysPos_FrameB:ShowCloseButton(false)
Admin_SysPos_FrameB:SetPos(x, y)
Admin_SysPos_FrameB.Think = function()
if Admin_SysPos_FrameB:IsHovered() then
     if IsValid(Admin_Mod_Frame) then
          Admin_Mod_Frame:SetAlpha(255)
          Admin_Mod_Frame:SetMouseInputEnabled(true)
          Admin_Mod_Frame:SetKeyboardInputEnabled(true)
		  Admin_Mod_Frame_2:SetAlpha(255)
		  Admin_Mod_Frame_2:SetMouseInputEnabled(true)
		  Admin_Mod_Frame_2:SetKeyboardInputEnabled(true)
          gui.EnableScreenClicker(true)
          Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
     end
     Admin_SysPos_FrameB:Remove()
end
end
Admin_SysPos_FrameB.Paint = function( self, w, h ) end
end)
end

local Admin_Sys_Lerp_, Admin_Sys_Lerp_An_ = 0, 0.05
Admin_Mod_Frame_BT:SetPos( Admin_System_Global:Size_Auto(10, "w"), Admin_System_Global:Size_Auto(85, "h") )
Admin_Mod_Frame_BT:SetSize(Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Mod_Frame_BT:SetText( "" )
Admin_Mod_Frame_BT:SetIcon("icon16/shape_group.png")
Admin_Mod_Frame_BT.Paint = function( self, w, h )
surface.SetDrawColor( Admin_Sys_Col )
surface.SetTexture( Admin_Sys_Gradient_ )
surface.DrawTexturedRect( 0, 0, w + 40, h )

if self:IsHovered() then
     Admin_Sys_Lerp_ = Lerp(Admin_Sys_Lerp_An_, Admin_Sys_Lerp_, w - Admin_System_Global:Size_Auto(4, "w"))
else
     Admin_Sys_Lerp_ = 0
end

draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp_, 1, Color(	41, 128, 185) )
draw.DrawText("Cloak", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Mod_Frame_BT.DoClick = function()
LocalPlayer():ConCommand( Admin_System_Global.Mode_AddCmd_Cloak )
end

local Admin_Sys_Lerp_x, Admin_Sys_Lerp_An_x = 0, 0.05
Admin_Mod_Frame_BT_1:SetPos( Admin_System_Global:Size_Auto(125, "w"), Admin_System_Global:Size_Auto(85, "h") )
Admin_Mod_Frame_BT_1:SetSize( Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Mod_Frame_BT_1:SetText( "" )
Admin_Mod_Frame_BT_1:SetIcon("icon16/shield.png")
Admin_Mod_Frame_BT_1.Paint = function( self, w, h )
surface.SetDrawColor( Admin_Sys_Col )
surface.SetTexture( Admin_Sys_Gradient_ )
surface.DrawTexturedRect( 0, 0, w + 40, h )

if self:IsHovered() then
     Admin_Sys_Lerp_x = Lerp(Admin_Sys_Lerp_An_x, Admin_Sys_Lerp_x, w - Admin_System_Global:Size_Auto(4, "w"))
else
     Admin_Sys_Lerp_x = 0
end

draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp_x, 1, Color(	41, 128, 185) )
draw.DrawText("Godmod", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Mod_Frame_BT_1.DoClick = function()
LocalPlayer():ConCommand( Admin_System_Global.Mode_AddCmd_GodMod )
end

local Admin_Sys_Lerp_y, Admin_Sys_Lerp_An_y = 0, 0.05
Admin_Mod_Frame_BT_2:SetPos( Admin_System_Global:Size_Auto(240, "w"), Admin_System_Global:Size_Auto(85, "h") )
Admin_Mod_Frame_BT_2:SetSize( Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Mod_Frame_BT_2:SetText( "" )
Admin_Mod_Frame_BT_2:SetIcon("icon16/cog.png")
Admin_Mod_Frame_BT_2.Paint = function( self, w, h )
surface.SetDrawColor( Admin_Sys_Col )
surface.SetTexture( Admin_Sys_Gradient_ )
surface.DrawTexturedRect( 0, 0, w + 40, h )

if self:IsHovered() then
     Admin_Sys_Lerp_y = Lerp(Admin_Sys_Lerp_An_y, Admin_Sys_Lerp_y, w - Admin_System_Global:Size_Auto(4, "w"))
else
     Admin_Sys_Lerp_y = 0
end
draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp_y, 1, Color(	41, 128, 185) )
draw.DrawText("Noclip", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Mod_Frame_BT_2.DoClick = function()
LocalPlayer():ConCommand( Admin_System_Global.Mode_AddCmd_NoClip )
end

Admin_Mod_Frame_Frm:SetPos(Admin_System_Global:Size_Auto(330, "w"), Admin_System_Global:Size_Auto(5, "h"))
Admin_Mod_Frame_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
Admin_Mod_Frame_Frm:SetImage("icon16/cross.png")
function Admin_Mod_Frame_Frm:Paint(w, h)
end
Admin_Mod_Frame_Frm.DoClick = function()
if IsValid(Admin_Mod_Frame) then
     Admin_Mod_Frame:Remove()
end

if IsValid(Admin_Mod_Frame_2) then
     Admin_Mod_Frame_2:Remove()
end
end
end
net.Receive("Admin_Sys:AdminMod", Admin_Sys_AdminMod_ChxFunc)