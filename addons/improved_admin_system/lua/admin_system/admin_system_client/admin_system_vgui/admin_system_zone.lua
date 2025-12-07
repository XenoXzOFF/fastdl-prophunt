	----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/
local Admin_SysPos_Table, Admin_SysPos_Save, Admin_SysPos_ScrollBar, Admin_Pos_Load_W, Admin_Pos_Load_H
local Admin_Sys_Tbl, Admin_SysPos_Zone_DefautVal, Admin_SysPos_Frame, Admin_SysPos_Ply = {}, false, nil, nil

local function Admin_SysPos_RefreshPos(Admin_SysPos_ScrollBar, Admin_Sys_Tbl)
     Admin_SysPos_Table = Admin_SysPos_Table or {}
     for i = 1, #Admin_SysPos_Table do
          Admin_SysPos_Table[i].Admin_SysPos_Frame_BT_3:Remove()
          Admin_SysPos_Table[i].Admin_SysPos_Frame_BT_Dl:Remove()
     end

     timer.Simple(0.1,function()
     local Admin_Pos = Admin_System_Global:Size_Auto(5, "w")
     if #Admin_Sys_Tbl > 3 then Admin_Pos = 1 end

for i = 1, #Admin_Sys_Tbl do

local Admin_SysPos_Frame_BT_Dl = vgui.Create("DLabel", Admin_SysPos_ScrollBar)
Admin_SysPos_Frame_BT_Dl:SetPos(Admin_Pos, Admin_System_Global:Size_Auto(35, "h") * i -Admin_System_Global:Size_Auto(35, "h") )
Admin_SysPos_Frame_BT_Dl:SetSize(Admin_System_Global:Size_Auto(265, "w"), Admin_System_Global:Size_Auto(25, "h"))
Admin_SysPos_Frame_BT_Dl:SetText("")
Admin_SysPos_Frame_BT_Dl.Paint = function(self,w,h)
draw.RoundedBox( 6, 1, 1, w, h, Color(52,73,94, 240) )
draw.DrawText(Admin_System_Global.lang["zoneadmin_name"].. "" ..Admin_Sys_Tbl[i].Central_NomZone, "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(4, "h"), Color(255,255,255, 280), TEXT_ALIGN_LEFT)
end

local Admin_SysPos_Frame_BT_3 = vgui.Create( "DButton", Admin_SysPos_ScrollBar)
Admin_SysPos_Frame_BT_3:SetPos(Admin_System_Global:Size_Auto(243, "w"), 5 + Admin_System_Global:Size_Auto(35, "h") * i -Admin_System_Global:Size_Auto(35, "h") )
Admin_SysPos_Frame_BT_3:SetSize(Admin_System_Global:Size_Auto(25, "w"), Admin_System_Global:Size_Auto(16, "h"))
Admin_SysPos_Frame_BT_3:SetText("")
Admin_SysPos_Frame_BT_3:SetIcon("icon16/cog.png")
Admin_SysPos_Frame_BT_3.Paint = function(self, w, h)
if self:IsHovered() then
     draw.RoundedBox( 2, Admin_System_Global:Size_Auto(22, "w"), 0, w, h,  Color(192, 57, 43, 255))
end
end
Admin_SysPos_Frame_BT_3:SetTooltip(Admin_System_Global.lang["zoneadmin_pos"].. "" ..tostring(Admin_Sys_Tbl[i].Central_PlayerPOS))
Admin_SysPos_Frame_BT_3.DoClick = function()
local Admin_SysPos_Derma = DermaMenu()

local Admin_SysPos_Optionb = Admin_SysPos_Derma:AddOption("Supprimer la zone administrateur", function()
net.Start("Admin_Sys:Manage_Pos")
net.WriteString("")
net.WriteBool(false)
net.WriteUInt( i, 4 )
net.SendToServer()

LocalPlayer():PrintMessage( HUD_PRINTTALK, "La zone administrateur a été supprimée !" )
end)
Admin_SysPos_Optionb:SetIcon("icon16/exclamation.png")
Admin_SysPos_Derma:Open()
end
table.insert(Admin_SysPos_Table, {Admin_SysPos_Frame_BT_3 = Admin_SysPos_Frame_BT_3, Admin_SysPos_Frame_BT_Dl = Admin_SysPos_Frame_BT_Dl})

end
end)
end

local function Admin_Sys_Frame_ZoneAdmin()
local Admin_NombreValue, Admin_MaxCaractereDtext, Admin_TextValue, Admin_CaractCount, Admin_Sys_Int = false, 20, "", 0, net.ReadUInt(8)
Admin_Sys_Tbl, Admin_SysPos_Save, Admin_Pos_Load_W, Admin_Pos_Load_H = {}, Admin_System_Global.lang["zoneadmin_loading"], Admin_System_Global:Size_Auto(45, "w"), Admin_System_Global:Size_Auto(30, "h")
  
for i = 1, Admin_Sys_Int do
Admin_Sys_Tbl[i] = {Central_NomZone = net.ReadString(), Central_PlayerPOS = net.ReadVector()}
end

timer.Simple(0.3,function()
if not IsValid(Admin_SysPos_ScrollBar) then return end
Admin_SysPos_RefreshPos(Admin_SysPos_ScrollBar, Admin_Sys_Tbl)

if #Admin_Sys_Tbl < 1 then
     Admin_SysPos_Save = Admin_System_Global.lang["zoneadmin_noposesave"]
     Admin_Pos_Load_W = Admin_System_Global:Size_Auto(140, "w")
     Admin_Pos_Load_H = Admin_System_Global:Size_Auto(200, "h")
else
     Admin_SysPos_Save = ""
end
end)
if IsValid(Admin_SysPos_Frame) then return end

Admin_SysPos_Frame = vgui.Create( "DFrame" )
local Admin_SysPos_Frame_BT = vgui.Create( "DButton", Admin_SysPos_Frame  )
local Admin_SysPos_Dtext = vgui.Create( "DTextEntry", Admin_SysPos_Frame )
local Admin_SysPos_Frame_BT_2 = vgui.Create("DImageButton", Admin_SysPos_Frame )
local Admin_SysPos_Frame_BT_3 = vgui.Create("DImageButton", Admin_SysPos_Frame )
local Admin_SysPos_Check = vgui.Create( "DCheckBoxLabel", Admin_SysPos_Frame)
Admin_SysPos_ScrollBar = vgui.Create( "DScrollPanel", Admin_SysPos_Frame)

Admin_SysPos_Frame:SetTitle( "" )
Admin_SysPos_Frame:SetSize( Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
Admin_SysPos_Frame:ShowCloseButton(false)
Admin_SysPos_Frame:SetDraggable(true)
Admin_SysPos_Frame:Center()
Admin_SysPos_Frame:MakePopup() 
Admin_SysPos_Frame.Paint = function( self, w, h )

Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 8)
draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
draw.DrawText( Admin_System_Global.lang["zoneadmin_managezone"], "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(4, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Admin_System_Global.lang["zoneadmin_namedtext"], "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(55, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Admin_SysPos_Save, "Admin_Sys_Font_T1", Admin_Pos_Load_W, Admin_Pos_Load_H, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
Admin_CaractCount = Admin_MaxCaractereDtext

if Admin_NombreValue and Admin_NombreValue > 0 then
     Admin_CaractCount = Admin_MaxCaractereDtext - Admin_NombreValue
end
if Admin_CaractCount == -1 then
     Admin_CaractCount = 0
end
draw.DrawText(Admin_System_Global.lang["zoneadmin_remainingcharacter"].. "" .. Admin_CaractCount,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(110, "h"),Color(0, 175, 0, 250),TEXT_ALIGN_CENTER)
end

Admin_SysPos_Dtext:SetPos(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(80, "h"))
Admin_SysPos_Dtext:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(25, "h"))
Admin_SysPos_Dtext:SetFont( "Admin_Sys_Font_T1" )
Admin_SysPos_Dtext:SetText( Admin_System_Global.lang["zoneadmin_namezoneind"] )
Admin_SysPos_Dtext.MaxCaractere = Admin_MaxCaractereDtext
Admin_SysPos_Dtext:SetTextColor(Color(255,0,0,250))
Admin_SysPos_Dtext.OnGetFocus = function() 
if Admin_SysPos_Dtext:GetText() == Admin_System_Global.lang["zoneadmin_namezoneind"] then
  Admin_SysPos_Dtext:SetTextColor(Color(255,0,0,250))
  Admin_SysPos_Dtext:SetText("")
end
end
Admin_SysPos_Dtext.OnTextChanged = function(self)
Admin_TextValue = self:GetValue()
Admin_NombreValue = string.len(Admin_TextValue)

if Admin_NombreValue > self.MaxCaractere then
     self:SetText(self.Admin_Sys_ODTextVal)
     self:SetValue(self.Admin_Sys_ODTextVal)
else
     self.Admin_Sys_ODTextVal = Admin_TextValue
end
end

Admin_SysPos_ScrollBar:SetSize( Admin_System_Global:Size_Auto(275, "w"), Admin_System_Global:Size_Auto(125, "h") )
Admin_SysPos_ScrollBar:SetPos( 1, Admin_System_Global:Size_Auto(175, "h") )
local Admin_SysPos_ScrollBar_Vbar = Admin_SysPos_ScrollBar:GetVBar()
Admin_SysPos_ScrollBar_Vbar:SetSize( Admin_System_Global:Size_Auto(5, "w"), 0 )
function Admin_SysPos_ScrollBar_Vbar.btnUp:Paint( w, h )
  draw.RoundedBox(6, 0, 0, w, h, Color(52,73,94))
end
function Admin_SysPos_ScrollBar_Vbar.btnDown:Paint( w, h )
  draw.RoundedBox(6, 0, 0, w, h, Color(52,73,94))
end
function Admin_SysPos_ScrollBar_Vbar.btnGrip:Paint( w, h )
  draw.RoundedBox(3, 0, 0, w, h, Color(52,73,94))
end

local Admin_Sys_Lerp, Admin_Sys_Lerp_An = 0, 0.05
Admin_SysPos_Frame_BT:SetPos( Admin_System_Global:Size_Auto(65, "w"), Admin_System_Global:Size_Auto(135, "h"))
Admin_SysPos_Frame_BT:SetSize( Admin_System_Global:Size_Auto(150, "w"), Admin_System_Global:Size_Auto(22, "h") )
Admin_SysPos_Frame_BT:SetText( "" )
Admin_SysPos_Frame_BT:SetIcon("icon16/add.png")
Admin_SysPos_Frame_BT.Paint = function( self, w, h )
draw.RoundedBox( 3, 0, 0, w, h, Color(52,73,94) )
if self:IsHovered() then
     Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(3, "w"))
else
     Admin_Sys_Lerp = 0
end
draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp, 1, Color(192, 57, 43) )
draw.DrawText(Admin_System_Global.lang["zoneadmin_addnwpos"], "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(7, "w"), 1, Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_SysPos_Frame_BT.DoClick = function()
local Admin_Sys_Val = Admin_SysPos_Dtext:GetValue()
if Admin_Sys_Val == "" or Admin_Sys_Val == " " or Admin_Sys_Val == Admin_System_Global.lang["zoneadmin_namezoneind"] then chat.AddText(Color(255,0,0), "Veuillez indiquer un nom de zone admin") return end
local Admin_SysPos_Derma = DermaMenu()
local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["zoneadmin_addnmpos"], function()
    net.Start("Admin_Sys:Manage_Pos")
    net.WriteString(Admin_Sys_Val)
    net.WriteBool(true) 
	net.WriteUInt( 0, 4 )
    net.SendToServer()
end)
Admin_SysPos_Option:SetIcon("icon16/user_red.png")
if #player.GetAll() > 1 then
     local Admin_SysPos_Sub, Admin_SysPos_Parent = Admin_SysPos_Derma:AddSubMenu(Admin_System_Global.lang["zoneadmin_addotherpos"])
     Admin_SysPos_Parent:SetIcon("icon16/group.png")

     local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
     for _, v in ipairs(Admin_Sys_FindClass_Ply) do
          if v == LocalPlayer() then continue end

          local Admin_SysPos_Option_1 = Admin_SysPos_Sub:AddOption(v:Nick(), function()
          net.Start("Admin_Sys:Manage_Pos")
          net.WriteString(Admin_Sys_Val)
          net.WriteBool(true)
          net.WriteUInt( 0, 4 )
          net.WriteEntity(v)
          net.SendToServer()
          end)
          Admin_SysPos_Option_1:SetIcon("icon16/add.png")
     end
end
Admin_SysPos_Derma:Open()
end

Admin_SysPos_Check:SetPos( Admin_System_Global:Size_Auto(125, "w"), Admin_System_Global:Size_Auto(30, "h") )	
Admin_SysPos_Check:SetFont( "Admin_Sys_Font_T1" )
Admin_SysPos_Check:SetText( Admin_System_Global.lang["zoneadmin_view"] )		
Admin_SysPos_Check:SetTooltip( Admin_System_Global.lang["zoneadmin_viewtooltip"] )
Admin_SysPos_Check:SetTextColor( Color(255, 0, 0) )
Admin_SysPos_Check:SetValue(Admin_SysPos_Zone_DefautVal)
Admin_SysPos_Check.OnChange = function( self, val )
if val  then
     Admin_SysPos_Ply = LocalPlayer()
     Admin_SysPos_Zone_DefautVal = true
else
     Admin_SysPos_Ply = nil
     Admin_SysPos_Zone_DefautVal = false
end
end
Admin_SysPos_Check:SizeToContents()	

local Admin_SysPos_FrameB
Admin_SysPos_Frame_BT_2:SetPos(Admin_System_Global:Size_Auto(260, "w"),Admin_System_Global:Size_Auto(5, "h"))
Admin_SysPos_Frame_BT_2:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_SysPos_Frame_BT_2:SetImage( "icon16/cross.png" )
function Admin_SysPos_Frame_BT_2:Paint(w,h) end
Admin_SysPos_Frame_BT_2.DoClick = function()
  Admin_SysPos_Frame:Remove()
end
Admin_SysPos_Frame_BT_3:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(4, "h"))
Admin_SysPos_Frame_BT_3:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_SysPos_Frame_BT_3:SetImage( "icon16/layers.png" )
function Admin_SysPos_Frame_BT_2:Paint(w,h) end
Admin_SysPos_Frame_BT_3.DoClick = function()

Admin_SysPos_Frame:SetAlpha(50)
Admin_SysPos_Frame_BT_3:SetImage( "icon16/monitor.png" )
Admin_SysPos_Frame:SetMouseInputEnabled(false)
Admin_SysPos_Frame:SetKeyboardInputEnabled(false)
gui.EnableScreenClicker(false)

timer.Simple(1,function()
if not IsValid(Admin_SysPos_Frame) then return end
local x, y = Admin_SysPos_Frame:GetPos()
Admin_SysPos_FrameB = vgui.Create( "DFrame" )
Admin_SysPos_FrameB:SetTitle( "" )
Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "w"))
Admin_SysPos_FrameB:SetMouseInputEnabled(true)
Admin_SysPos_FrameB:ShowCloseButton(false)
Admin_SysPos_FrameB:SetPos(x, y)
Admin_SysPos_FrameB.Think = function()
if Admin_SysPos_FrameB:IsHovered() then

     if IsValid(Admin_SysPos_Frame) then
          Admin_SysPos_Frame:SetAlpha(255)
          Admin_SysPos_Frame:SetMouseInputEnabled(true)
          Admin_SysPos_Frame:SetKeyboardInputEnabled(true)
          gui.EnableScreenClicker(true)
          Admin_SysPos_Frame_BT_3:SetImage( "icon16/layers.png" )
     end
     Admin_SysPos_FrameB:Remove()
end
end
Admin_SysPos_FrameB.Paint = function( self, w, h ) end
end)
end
end
net.Receive("Admin_Sys:ReloadZone", Admin_Sys_Frame_ZoneAdmin)
  
hook.Add("HUDPaint", "Admin_SystemInfo_HUD_ZoneAdmin", function()
if Admin_SysPos_Zone_DefautVal and LocalPlayer() == Admin_SysPos_Ply then
     for i = 1, #Admin_Sys_Tbl do
          local Admin_Sys_ToScreen = Admin_Sys_Tbl[i].Central_PlayerPOS:ToScreen()
          draw.SimpleTextOutlined(  "Distance : " ..math.Round( LocalPlayer():GetPos():Distance( Admin_Sys_Tbl[i].Central_PlayerPOS ) ), "Admin_Sys_Font_T1",  Admin_Sys_ToScreen.x,  Admin_Sys_ToScreen.y, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
          draw.SimpleTextOutlined(  "Zone Admin : " ..Admin_Sys_Tbl[i].Central_NomZone, "Admin_Sys_Font_T1",  Admin_Sys_ToScreen.x,  Admin_Sys_ToScreen.y - 20, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
     end
end
end)