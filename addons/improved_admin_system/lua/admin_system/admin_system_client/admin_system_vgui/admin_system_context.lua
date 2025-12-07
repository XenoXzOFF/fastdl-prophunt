----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/
if not Admin_System_Global.Active_ContextMenu then return end

local Admin_System_Context_Frame_1, Admin_System_Context_Frame_2, Admin_Sys_TblOld, Admin_Sys_Tick_Scroll
local Admin_Sys_CountJob, Admin_Sys_Categorie, Admin_Sys_CountVal = Admin_Sys_CountJob or {}, Admin_Sys_Categorie or {}, 0
local Admin_System_ContextMenu, Admin_System_Text_Val, Admin_System_Engine = false, Admin_System_Global.lang["contextmenu_amount"], engine.ActiveGamemode()

function Admin_System_Global:Admin_Sys_CHide(Admin_Visible)
     if Admin_Visible then
          if IsValid(Admin_System_Context_Frame_1) and Admin_System_Context_Frame_1:IsHovered() then
               Admin_System_Context_Frame_1:SetVisible(false)
          end
          if IsValid(Admin_System_Context_Frame_2) and Admin_System_Context_Frame_2:IsHovered() then
               Admin_System_Context_Frame_2:SetVisible(false)
          end
     else
          timer.Simple(2.5,function()
          if IsValid(Admin_System_Context_Frame_1) and not Admin_System_Context_Frame_1:IsVisible() and not Admin_System_Context_Frame_1:IsHovered() then
               Admin_System_Context_Frame_1:SetVisible(true)
          end
          if IsValid(Admin_System_Context_Frame_2) and not Admin_System_Context_Frame_2:IsVisible() and not Admin_System_Context_Frame_2:IsHovered() then
               Admin_System_Context_Frame_2:SetVisible(true)
          end
          end)
     end
end

local function Admin_Sys_LoadCat(tbl, panel)
if Admin_Sys_TblOld ~= tbl then
     for _, v in pairs(Admin_Sys_Categorie) do
          if not IsValid(v) then continue end

          v:SetVisible(false)
          v = nil
     end
     Admin_Sys_Categorie = {}
end
Admin_Sys_TblOld = tbl

if IsValid(Admin_Sys_Tick_Scroll) then
     Admin_Sys_Tick_Scroll:GetCanvas():Clear()
end
if not Admin_System_Global.General_Permission[LocalPlayer():GetUserGroup()] and (tbl == Admin_SysContextMenuV2) then return end

Admin_Sys_Tick_Scroll = vgui.Create( "DScrollPanel", panel)
local Admin_Count_Nb_Tbl = #Admin_System_Global.ContextMenu_TblFunc[tbl]
local Admin_Count_Max = 2
local Admin_Math_DV = math.ceil(Admin_Count_Nb_Tbl / Admin_Count_Max)
local Admin_Count_Local = 0
local Admin_Count_LocalMT = Admin_Math_DV - Admin_Math_DV

Admin_Sys_Tick_Scroll:SetSize( Admin_System_Global:Size_Auto(333, "w"), Admin_System_Global:Size_Auto(130, "h") )
Admin_Sys_Tick_Scroll:SetPos( Admin_System_Global:Size_Auto(15, "w"), Admin_System_Global:Size_Auto(50, "h") )
local Admin_Sys_Vbar = Admin_Sys_Tick_Scroll:GetVBar()
Admin_Sys_Vbar:SetSize( Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(7, "h") )
Admin_Sys_Vbar.Paint = function( self, w, h )
draw.RoundedBox(6, 0, 0, w, h, Color(255,255,255,15))
end
Admin_Sys_Vbar.btnUp.Paint = function( self, w, h )
draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollUp)
end
Admin_Sys_Vbar.btnDown.Paint = function( self, w, h )
draw.RoundedBox(6, 0, 0, w, h, Admin_System_Global.TicketScrollDown)
end
Admin_Sys_Vbar.btnGrip.Paint = function( self, w, h )
draw.RoundedBox(2, 0, 0, w, h, Admin_System_Global.TicketScrollBar)
end

for i = 1 , Admin_Count_Nb_Tbl do
if not Admin_System_Global.ContextMenu_TblFunc[tbl][i].Name or not Admin_System_Global.ContextMenu_TblFunc[tbl][i].Icon or not isfunction(Admin_System_Global.ContextMenu_TblFunc[tbl][i].Func) then continue end
if Admin_System_Global.ContextMenu_TblFunc[tbl][i].OnlyForMayor and not LocalPlayer():isMayor() then continue end
if Admin_System_Global.ContextMenu_TblFunc[tbl][i].OnlyForAdmin and not Admin_System_Global.General_Permission[LocalPlayer():GetUserGroup()] then continue end

local Admin_Button_Gen = vgui.Create( "DButton", Admin_Sys_Tick_Scroll )
Admin_Button_Gen:SetImage( Admin_System_Global.ContextMenu_TblFunc[tbl][i].Icon )
Admin_Button_Gen:SetText( "" )
Admin_Button_Gen:SetPos( Admin_Count_Local * Admin_System_Global:Size_Auto(175, "w"), Admin_Count_LocalMT * Admin_System_Global:Size_Auto(45, "h") + Admin_System_Global:Size_Auto(10, "h") )
Admin_Button_Gen:SetSize( Admin_System_Global:Size_Auto(150, "w"), Admin_System_Global:Size_Auto(30, "h") )
Admin_Button_Gen.Paint = function( self, w, h )
draw.RoundedBox( 8, 0, 0, w, h, Admin_System_Global.ContextButton )
draw.DrawText( Admin_System_Global.ContextMenu_TblFunc[tbl][i].Name or "...", "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(9, "w"), Admin_System_Global:Size_Auto(6, "h"), Admin_System_Global.ContextTextButton, TEXT_ALIGN_CENTER )
end
Admin_Button_Gen.DoClick = Admin_System_Global.ContextMenu_TblFunc[tbl][i].Func
Admin_Count_Local = Admin_Count_Local + 1
if Admin_Count_Local >= Admin_Count_Max then
     Admin_Count_Local = 0
     Admin_Count_LocalMT = Admin_Count_LocalMT + 1
end
table.insert(Admin_Sys_Categorie, Admin_Button_Gen)
end
end

local function Admin_SysCountJob_Func(tbl)
     Admin_Sys_CountJob = {tbl = tbl}
	 
     for g,v in pairs(Admin_Sys_CountJob) do
          Admin_Sys_CountVal = 0
          local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
          for k, p in ipairs(Admin_Sys_FindClass_Ply) do
               if v[team.GetName(p:Team())] then
                    Admin_Sys_CountVal = Admin_Sys_CountVal + 1
               end
          end
     end

     return Admin_Sys_CountVal
end

local function Admin_System_ContextMenu_G()
local Admin_System_Ply = LocalPlayer()
if Admin_System_Global.ContextMenu_BlackList[team.GetName(Admin_System_Ply:Team())] or (IsValid(Admin_System_Ply:GetActiveWeapon()) and Admin_System_Global.ContextMenu_WeaponBackList[Admin_System_Ply:GetActiveWeapon():GetClass()]) or not Admin_System_Ply:Alive() or Admin_System_Ply:InVehicle() then return end

if IsValid(Admin_System_Context_Frame_1) then
Admin_System_Context_Frame_1:Remove()
end
if IsValid(Admin_System_Context_Frame_2) then
Admin_System_Context_Frame_2:Remove()
end

Admin_System_Context_Frame_1 = vgui.Create( "DFrame" )
Admin_System_Context_Frame_2 = vgui.Create( "DFrame" )	
if Admin_System_Global.ContextRightHide then
Admin_System_Context_Frame_1:Hide()
end
if Admin_System_Global.ContextLeftHide then
Admin_System_Context_Frame_2:Hide()
end

local Admin_Categorie_1 = vgui.Create( "DButton", Admin_System_Context_Frame_1 )
local Admin_Categorie_2 = vgui.Create( "DButton", Admin_System_Context_Frame_1 )
local Admin_Icon = vgui.Create( "DModelPanel", Admin_System_Context_Frame_2  )
local Admin_Job = team.GetName(Admin_System_Ply:Team())
local Admin_Nom = Admin_System_Ply:GetName()

timer.Simple(0.1,function()
if IsValid(Admin_System_Context_Frame_1) then
     Admin_System_Context_Frame_1:SetKeyboardInputEnabled(false)
end
if IsValid(Admin_System_Context_Frame_2) then
     Admin_System_Context_Frame_2:SetKeyboardInputEnabled(false)
end
end)

local Admin_SysCountk, Admin_SysContextMenuV1, Admin_SysContextMenuV2 = 0
for k, v in pairs(Admin_System_Global.ContextMenu_TblFunc) do
     Admin_SysCountk = Admin_SysCountk + 1
     if Admin_SysCountk <= 1 then
          Admin_SysContextMenuV1 = k
     else
          Admin_SysContextMenuV2 = k
     end
end 

if not Admin_Sys_TblOld then
     Admin_Sys_LoadCat(Admin_SysContextMenuV1, Admin_System_Context_Frame_1)
else
     Admin_Sys_LoadCat(Admin_Sys_TblOld, Admin_System_Context_Frame_1)
end

Admin_System_Context_Frame_2:SetSize( Admin_System_Global:Size_Auto(400, "w"), Admin_System_Global:Size_Auto(200, "h") )
Admin_System_Context_Frame_2:SetPos(Admin_System_Global.ContextLeftPos == "gauche" and 1 or ScrW() - Admin_System_Global:Size_Auto(351, "w"), ScrH() - Admin_System_Global:Size_Auto(200, "h") )
Admin_System_Context_Frame_2:SetTitle( "" )
Admin_System_Context_Frame_2:MakePopup()
Admin_System_Context_Frame_2:ShowCloseButton(false)
Admin_System_Context_Frame_2:SetDraggable(false)
Admin_System_Context_Frame_2.Paint = function( self, w, h )
Admin_System_Global:Gui_Blur(self, 3, Color( 0, 0, 0, 170 ), 3)

draw.RoundedBox( 0, 0, 0, w, Admin_System_Global:Size_Auto(20, "h"), Admin_System_Global.ColorContextLeft )
draw.SimpleText(Admin_System_Global.Title,"Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(10, "h"),  Color(255,255,255,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
draw.WordBox( 8, Admin_System_Global:Size_Auto(175, "w"), Admin_System_Global:Size_Auto(20, "h"), Admin_System_Global.lang["zoneadmin_name"].. "" ..Admin_Nom, "Admin_Sys_Font_T1", Color(0,69,175,0), Color(255,255,255,255) )
draw.WordBox( 8, Admin_System_Global:Size_Auto(175, "w"), Admin_System_Global:Size_Auto(90, "h"), Admin_System_Global.lang["contextmenu_job"].. "" ..Admin_Job, "Admin_Sys_Font_T1", Color(0,69,175,0), Color(255,255,255,255) )

if Admin_System_Engine == "darkrp" then
     local Admin_Argent = string.Comma(Admin_System_Ply:getDarkRPVar("money")) or 0
     draw.WordBox( 8, Admin_System_Global:Size_Auto(175, "w"), Admin_System_Global:Size_Auto(55, "h"), Admin_System_Global.lang["hudmoney"].. "" ..Admin_Argent.. "" ..Admin_System_Global.lang["remb_moneysymb"], "Admin_Sys_Font_T1", Color(0,69,175,0), Color(255,255,255,255) )
end

draw.WordBox( 8, Admin_System_Global:Size_Auto(175, "w"), Admin_System_Global:Size_Auto(125, "h"), Admin_System_Global.lang["contextmenu_copsonline"].. "" ..Admin_SysCountJob_Func(Admin_System_Global.ContextMenu_CountPolice), "Admin_Sys_Font_T1", Color(0,69,175,0), Color(255,255,255,255) )
draw.WordBox( 8, Admin_System_Global:Size_Auto(175, "w"), Admin_System_Global:Size_Auto(160, "h"), Admin_System_Global.lang["contextmenu_mediconlne"].. "" ..Admin_SysCountJob_Func(Admin_System_Global.ContextMenu_CountMedic), "Admin_Sys_Font_T1", Color(0,69,175,0), Color(255,255,255,255) )
end

Admin_Icon:SetSize( Admin_System_Global:Size_Auto(150, "w"), Admin_System_Global:Size_Auto(135, "h") )
Admin_Icon:SetPos( Admin_System_Global:Size_Auto(5, "w") , Admin_System_Global:Size_Auto(40, "h"))
Admin_Icon:SetModel( Admin_System_Ply:GetModel()  )
Admin_Icon:SetAmbientLight( Color( 255, 0, 0, 255 ) )
if Admin_System_Ply:GetModel() ~= "models/error.mdl" and Admin_Icon.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) ~= nil then  
	 function Admin_Icon:LayoutEntity( ent )
          ent:SetSequence( ent:LookupSequence( "idle_all_scared" ) )
          Admin_Icon:RunAnimation()
          return
     end
	 
     local Admin_Pos_Eye = Admin_Icon.Entity:GetBonePosition( Admin_Icon.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )   
	 Admin_Pos_Eye:Add( Vector( 0, 0, -3 ) )
     Admin_Icon:SetLookAt( Admin_Pos_Eye )
     Admin_Icon:SetCamPos( Admin_Pos_Eye-Vector( -20, 0, 0 ) )
     Admin_Icon.Entity:SetEyeTarget( Admin_Pos_Eye-Vector( -12, 0, 0 ) ) 
end
local Admin_Icon_B = baseclass.Get("DModelPanel")
Admin_Icon.Paint = function(self,w,h)
Admin_Icon_B.Paint(self, w, h)
end

Admin_System_Context_Frame_1:SetSize( Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(200, "h") )
Admin_System_Context_Frame_1:SetPos(Admin_System_Global.ContextRightPos == "droite" and ScrW() - Admin_System_Global:Size_Auto(351, "w") or 1, ScrH() - Admin_System_Global:Size_Auto(200, "h") )
Admin_System_Context_Frame_1:SetTitle( "" )
Admin_System_Context_Frame_1:ShowCloseButton(false)
Admin_System_Context_Frame_1:SetDraggable(false)
Admin_System_Context_Frame_1:MakePopup()
Admin_System_Context_Frame_1.Paint = function( self, w, h )
Admin_System_Global:Gui_Blur(self, 3, Color( 0, 0, 0, 100 ), 3)
draw.RoundedBox( 0, 0, 0, w, Admin_System_Global:Size_Auto(20, "h"), Admin_System_Global.ContextRight )
draw.RoundedBoxEx( 8, Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(20, "h"), w-Admin_System_Global:Size_Auto(35, "w"), Admin_System_Global:Size_Auto(37, "h"), Admin_System_Global.ContextBackButtonRight, false, false, true, true )
if table.Count(Admin_Sys_Categorie) <= 0 then
     draw.SimpleText(Admin_System_Global.lang["contextmenu_noadmin"],"Admin_Sys_Font_T1" , w/2, Admin_System_Global:Size_Auto(125, "h"),  Color(255,255,0,250), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end
draw.SimpleText("Action rapide" ,"Admin_Sys_Font_T1" , w/2, Admin_System_Global:Size_Auto(10, "h"), Admin_System_Global.ContextTitleRight, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

Admin_Categorie_1:SetText( "" )
Admin_Categorie_1:SetPos( Admin_System_Global:Size_Auto(195, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Categorie_1:SetSize( Admin_System_Global:Size_Auto(125, "w"), Admin_System_Global:Size_Auto(22, "h") )
Admin_Categorie_1.Paint = function( self, w, h )
if Admin_Sys_TblOld == Admin_SysContextMenuV2 then
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(3, "w"), 0, w-Admin_System_Global:Size_Auto(4, "w"), h, Admin_System_Global.ContextActionAdminHoverRight )
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(2, "w"), 1, w-Admin_System_Global:Size_Auto(2, "w"), h, Admin_System_Global.ContextActionAdminButtonRight )
     draw.DrawText( "➔ " ..Admin_SysContextMenuV2, "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(2, "h"), Admin_System_Global.ColorTextAdminRight, TEXT_ALIGN_CENTER )
else
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(3, "w"), 0, w-Admin_System_Global:Size_Auto(4, "w"), h, Admin_System_Global.ContextActionAdminHoverRight_1  )
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(1, "h"), w-Admin_System_Global:Size_Auto(2, "w"), h, Admin_System_Global.ContextActionAdminButtonRight )
     draw.DrawText( Admin_SysContextMenuV2, "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(2, "h"), Admin_System_Global.ColorTextAdminRight, TEXT_ALIGN_CENTER )
end
end
Admin_Categorie_1.DoClick = function()
Admin_Sys_LoadCat(Admin_SysContextMenuV2, Admin_System_Context_Frame_1)
end

Admin_Categorie_2:SetText( "" )
Admin_Categorie_2:SetPos( Admin_System_Global:Size_Auto(35, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Categorie_2:SetSize( Admin_System_Global:Size_Auto(125, "w"), Admin_System_Global:Size_Auto(22, "h") )
Admin_Categorie_2.Paint = function( self, w, h )
if Admin_Sys_TblOld == Admin_SysContextMenuV1 then
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(3, "w"), 0, w-Admin_System_Global:Size_Auto(4, "w"), h, Admin_System_Global.ContextActionPlayerHoverRight  )
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(2, "w"), 1, w-Admin_System_Global:Size_Auto(2, "w"), h, Admin_System_Global.ContextActionPlayerButtonRight )
     draw.DrawText( "➔ " ..Admin_SysContextMenuV1, "Admin_Sys_Font_T1", w/2 , 2, Admin_System_Global.ContextTextPlayerRight, TEXT_ALIGN_CENTER )
else
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(3, "w"), 0, w-Admin_System_Global:Size_Auto(4, "w"), h, Admin_System_Global.ContextActionPlayerHover_1Right  )
     draw.RoundedBox( 8, Admin_System_Global:Size_Auto(2, "w"), 1, w-Admin_System_Global:Size_Auto(2, "w"), h, Admin_System_Global.ContextActionPlayerButtonRight )
     draw.DrawText( Admin_SysContextMenuV1, "Admin_Sys_Font_T1", w/2 , 2, Admin_System_Global.ContextTextPlayerRight, TEXT_ALIGN_CENTER )
end
end

Admin_Categorie_2.DoClick = function()
Admin_Sys_LoadCat(Admin_SysContextMenuV1, Admin_System_Context_Frame_1)
end
end

function Admin_System_Global:ContextMenu_Func(Admin_Sys_Bool)
if Admin_System_ContextMenu then return end
Admin_System_ContextMenu = true

local Admin_System_ContextFunc_Frame = vgui.Create( "DFrame" )
local Admin_System_ContextFunc_DText = vgui.Create( "DTextEntry", Admin_System_ContextFunc_Frame ) 
local Admin_System_ContextFunc_DBut = vgui.Create( "DButton", Admin_System_ContextFunc_Frame  )
local Admin_System_ContextFunc_DBut_1 = vgui.Create("DButton", Admin_System_ContextFunc_Frame )

Admin_System_ContextFunc_Frame:SetTitle( "" )
Admin_System_ContextFunc_Frame:SetSize( Admin_System_Global:Size_Auto(285, "w"), Admin_System_Global:Size_Auto(150, "h") )
Admin_System_ContextFunc_Frame:SetPos(ScrW()/ 2- Admin_System_Global:Size_Auto(160, "w"),  ScrH() / 2 )
Admin_System_ContextFunc_Frame:MakePopup()
Admin_System_ContextFunc_Frame:Center()
Admin_System_ContextFunc_Frame:SetTitle("")
Admin_System_ContextFunc_Frame:ShowCloseButton(false)
Admin_System_ContextFunc_Frame:SetDraggable(true)
function Admin_System_ContextFunc_Frame:Init()
     self.startTime = SysTime()
end
Admin_System_ContextFunc_Frame.Paint = function( self, w, h )
Derma_DrawBackgroundBlur(self, self.startTime)
surface.SetDrawColor( 52,73,94 )
surface.DrawOutlinedRect( 0, 0, w, h, Admin_System_Global:Size_Auto(5, "h") )
draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"),  Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(9, "w"), Admin_System_Global:Size_Auto(26, "h"), Color(0,0,0,100) )
draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"), Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(25, "h"), Color(44, 62, 80)) -- Top border
draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(30, "h"), w - Admin_System_Global:Size_Auto(10, "w"), h - Admin_System_Global:Size_Auto(36, "h"), Color(0,0,0,100) ) -- Background middle but
draw.RoundedBox(11, w - Admin_System_Global:Size_Auto(25, "w"), Admin_System_Global:Size_Auto(6, "h"), Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"), Color(0,0,0,100) )
draw.DrawText( Admin_System_Global.lang["contextmenu_number"], "Admin_Sys_Font_T4", Admin_System_Global:Size_Auto(142, "w"),Admin_System_Global:Size_Auto(35, "h"), Color( 255, 255, 255, 250 ), TEXT_ALIGN_CENTER )
if not Admin_Sys_Bool then
draw.DrawText( Admin_System_Global.lang["contextmenu_dropmoneyground"], "Admin_Sys_Font_T4", Admin_System_Global:Size_Auto(140, "w"),Admin_System_Global:Size_Auto(6, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
else
draw.DrawText( Admin_System_Global.lang["contextmenu_givemoneytarget"], "Admin_Sys_Font_T4", Admin_System_Global:Size_Auto(143, "w"),Admin_System_Global:Size_Auto(6, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end
end

Admin_System_ContextFunc_DText:SetPos(Admin_System_Global:Size_Auto(50, "w"), Admin_System_Global:Size_Auto(68, "h"))
Admin_System_ContextFunc_DText:SetSize(Admin_System_Global:Size_Auto(185, "w"), Admin_System_Global:Size_Auto(25, "h"))
Admin_System_ContextFunc_DText:SetText( Admin_System_Text_Val )
Admin_System_ContextFunc_DText.MaxCaractere = 7
Admin_System_ContextFunc_DText:SetFont("Admin_Sys_Font_T4")
Admin_System_ContextFunc_DText.OnGetFocus = function()
if Admin_System_ContextFunc_DText:GetText() == Admin_System_Text_Val then
     Admin_System_ContextFunc_DText:SetTextColor(Color(0,0,0,255))
     Admin_System_ContextFunc_DText:SetFont("Admin_Sys_Font_T4")
     Admin_System_ContextFunc_DText:SetText("")
end
end
Admin_System_ContextFunc_DText.OnTextChanged = function( self )
local Admin_Text = self:GetValue()
local Admin_Nombre = string.len(Admin_Text)
local Admin_Convert = tonumber( Admin_Text, 10 )
if not isnumber( Admin_Convert ) then
     self:SetText("")
     self:SetValue(self:GetValue() and "")
end
if Admin_Nombre > self.MaxCaractere then
     self:SetText(self.OldText)
     self:SetValue(self.OldText)
else
     self.OldText = Admin_Text
end
end

Admin_System_ContextFunc_DBut:SetPos( Admin_System_Global:Size_Auto(90, "w"), Admin_System_Global:Size_Auto(110, "h"))
Admin_System_ContextFunc_DBut:SetSize( Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_System_ContextFunc_DBut:SetText( "" )
Admin_System_ContextFunc_DBut.Paint = function( self, w, h )
draw.RoundedBox( 1, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(1, "h"), w, h, Color(52,73,94) )
draw.DrawText( Admin_System_Global.lang["validate"], "Admin_Sys_Font_T4", w/2 + Admin_System_Global:Size_Auto(3, "w"), Admin_System_Global:Size_Auto(3, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end
Admin_System_ContextFunc_DBut.DoClick = function() 
if string.len(Admin_System_ContextFunc_DText:GetValue()) <= 0 or Admin_System_ContextFunc_DText:GetValue() == Admin_System_Text_Val then
chat.AddText(Color( 255, 0, 0 ), "[", "Admin System", "] : ", Color( 255, 255, 255 ), "Veuillez inclure un nombre !" ) 
return 
end
LocalPlayer():ConCommand( (not Admin_Sys_Bool and "say /dropmoney " or "say /give ")  ..Admin_System_ContextFunc_DText:GetValue() )
Admin_System_ContextMenu = false
Admin_System_ContextFunc_Frame:Remove()
end

Admin_System_ContextFunc_DBut_1:SetPos(Admin_System_Global:Size_Auto(257, "w"), Admin_System_Global:Size_Auto(5, "h"))
Admin_System_ContextFunc_DBut_1:SetSize(Admin_System_Global:Size_Auto(22, "w"), Admin_System_Global:Size_Auto(22, "h"))
Admin_System_ContextFunc_DBut_1:SetImage("icon16/cross.png")
function Admin_System_ContextFunc_DBut_1:Paint(w, h)
end
Admin_System_ContextFunc_DBut_1.DoClick = function()
Admin_System_ContextMenu = false
Admin_System_ContextFunc_Frame:Remove()
end
end

hook.Add("ContextMenuOpen", "Admin_System_ContextMenu_Defaut", function()
if Admin_System_Global.Cacher_ContextDefaut then
    if not Admin_System_Global.WhiteList_ContextDefaut[LocalPlayer():GetUserGroup()] then return false end
end
end)

hook.Add( "OnContextMenuOpen", "Admin_System_ContextMenu_OP", function()
Admin_System_ContextMenu_G()
end)

hook.Add( "OnContextMenuClose", "Admin_System_ContextMenu_CL", function()
if IsValid(Admin_System_Context_Frame_1) then
     Admin_System_Context_Frame_1:Remove()
end
if IsValid(Admin_System_Context_Frame_2) then
     Admin_System_Context_Frame_2:Remove()
end

CloseDermaMenus()
end)