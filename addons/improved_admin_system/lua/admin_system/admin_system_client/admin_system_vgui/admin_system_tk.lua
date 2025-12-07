----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/
if not Admin_System_Global.TicketLoad then return end

local Admin_Sys_Table_Tick, Admin_Sys_Tick_Visible, Admin_Sys_Frame_Notification  = {}, false
local Admin_Sys_Waiting = Admin_System_Global.lang["ticket_wait"]

local Admin_Sys_Table_BT = Admin_Sys_Table_BT or {
     [1] = {Admin_Sys_String = Admin_System_Global.lang["ticket_teleporto"],  Admin_Sys_Func = function(Admin_Sys_Ply)
     local Admin_SysPos_Derma = DermaMenu()

     local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption("Téléporter vers le joueur", function()
     net.Start("Admin_Sys:TP_Reset")
     net.WriteUInt( 3, 4 )
     net.WriteEntity(Admin_Sys_Ply)
     net.SendToServer()
     end)

     Admin_SysPos_Option:SetIcon("icon16/group.png")
     local Admin_SysPos_Sub, Admin_SysPos_Parent = Admin_SysPos_Derma:AddSubMenu("Téléporter vers le(s) véhicule(s) du joueur")
     Admin_SysPos_Parent:SetIcon("icon16/car.png")

     local Admin_Sys_FindClass_Veh, Admin_Sys_Valide, Admin_SysPos_Option_1 = ents.FindByClass("prop_vehicle_jeep"), false, nil
     for _, v in ipairs(Admin_Sys_FindClass_Veh) do
	 local Admin_Sys_v, Admin_Sys_x = v:CPPIGetOwner() or nil
	 
          if IsValid(Admin_Sys_v) and (Admin_Sys_v == Admin_Sys_Ply) then
               local c = v:GetVehicleClass()
               local t = list.Get( "Vehicles" )[ c ]

               Admin_SysPos_Option_1 = Admin_SysPos_Sub:AddOption("Nom du véhicule : " ..(istable(t) and t.Name or c or "Nom Inconnu").. "- Distance : " ..math.Round( LocalPlayer():GetPos():Distance( v:GetPos() ) ).. "m", function()
               net.Start("Admin_Sys:TP_Reset")
               net.WriteUInt( 3, 4 )
               net.WriteEntity(v)
               net.SendToServer()
               end)
			   
			   Admin_Sys_Valide = true
               Admin_SysPos_Option_1:SetIcon("icon16/arrow_right.png")
          end
     end
     if not Admin_Sys_Valide then
          Admin_SysPos_Option_1 = Admin_SysPos_Sub:AddOption("Aucun véhicule")
     end
 
     Admin_SysPos_Derma:Open()
     end},

     [2] = {Admin_Sys_String = Admin_System_Global.lang["ticket_ret"],  Admin_Sys_Func = function(Admin_Sys_Ply)
     net.Start("Admin_Sys:TP_Reset")
     net.WriteUInt( 1, 4 )
     net.WriteEntity(Admin_Sys_Ply)
     net.SendToServer()
     end},

     [3] = {Admin_Sys_String = Admin_System_Global.lang["ticket_notif"],  Admin_Sys_Func = function(Admin_Sys_Ply)
     local Admin_Sys_DermaMenu = DermaMenu()

     for i = 1, #Admin_System_Global.Notif_Gen do
          local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption( Admin_System_Global.Notif_Gen[i].Name_Notification, function()
          net.Start("Admin_Sys:Mssg")
          net.WriteEntity(Admin_Sys_Ply)
          net.WriteUInt( i, 8 )
          net.SendToServer()
          end)
     end
     Admin_Sys_DermaMenu:Open()
     end},

     [4] = {Admin_Sys_String = Admin_System_Global.lang["ticket_tpzone"],  Admin_Sys_Func = function(Admin_Sys_Ply)
     net.Start("Admin_Sys:ZNAdmin")
     net.WriteBool(true)
     net.WriteEntity(Admin_Sys_Ply) -- Target
     net.WriteUInt( 1, 4 )
     net.SendToServer()
     end},

     [5] = {Admin_Sys_String = Admin_System_Global.lang["ticket_tpatrj"],  Admin_Sys_Func = function(Admin_Sys_Ply)
     local Admin_Sys_DermaMenu = DermaMenu()
     local Admin_Sys_Table_Derma = {}

     if #player.GetAll() <= 1 then
          LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_teleportnotif"] )
          return
     end
     for _, player in ipairs(ents.FindByClass( "player" )) do
          if player == LocalPlayer() then continue end
          Admin_Sys_TeleportTable = {
               Admin_Sys_Ply = player,
               Admin_Sys_Name = player:Nick()
          }
          table.insert(Admin_Sys_Table_Derma, Admin_Sys_TeleportTable)
     end

     local Admin_Sys_SortTable = function( x, z )
     return x.Admin_Sys_Name > z.Admin_Sys_Name
end
table.sort( Admin_Sys_Table_Derma, Admin_Sys_SortTable )
for _, v in pairs(Admin_Sys_Table_Derma) do
     if v.Admin_Sys_Ply == Admin_Sys_Ply then v.Admin_Sys_Name = v.Admin_Sys_Name.. "" ..Admin_System_Global.lang["ticket_creatorown"] end

     local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption( v.Admin_Sys_Name, function()
     net.Start("Admin_Sys:ZNAdmin")
     net.WriteBool(false)
     net.WriteEntity(v.Admin_Sys_Ply) --- Target
     net.WriteUInt( 2, 4 )
     net.WriteEntity(Admin_Sys_Ply) --- Creator of Ticket
     net.SendToServer()

     Admin_Sys_DermaMenu:Remove()
     end)
end

Admin_Sys_DermaMenu:Open()
end},

[6] = {Admin_Sys_String = Admin_System_Global.lang["ticket_respawn"],  Admin_Sys_Func = function(Admin_Sys_Ply)
local Admin_Sys_DermaMenu = DermaMenu()
local Admin_Sys_Table_Derma = {}
for _, player in pairs(ents.FindByClass( "player" )) do
     if player == LocalPlayer() or player:Alive() then continue end
     Admin_Sys_TeleportTable = {
          Admin_Sys_Ply = player,
          Admin_Sys_Name = player:Nick()
     }

     table.insert(Admin_Sys_Table_Derma, Admin_Sys_TeleportTable)
end

if #Admin_Sys_Table_Derma <= 0 then
     LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_respawnnotif"] )
     return
end

local Admin_Sys_SortTable = function( x, z )
return x.Admin_Sys_Name > z.Admin_Sys_Name
end

table.sort( Admin_Sys_Table_Derma, Admin_Sys_SortTable )

for _, v in pairs(Admin_Sys_Table_Derma) do
     if not v.Admin_Sys_Ply:IsPlayer() or v.Admin_Sys_Ply:Alive() then continue end
     if v.Admin_Sys_Ply == Admin_Sys_Ply then v.Admin_Sys_Name = v.Admin_Sys_Name.. "" ..Admin_System_Global.lang["ticket_creatorown"] else v.Admin_Sys_Name = v.Admin_Sys_Name.. "" ..Admin_System_Global.lang["huddeath"] end

     local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption( v.Admin_Sys_Name, function()
     net.Start("Admin_Sys:Action")
     net.WriteUInt( 5, 4 )
     net.WriteEntity(v.Admin_Sys_Ply)
     net.WriteBool(false)
     net.SendToServer()

     Admin_Sys_DermaMenu:Remove()
     end)
end

Admin_Sys_DermaMenu:Open()
end},

[7] = {Admin_Sys_String = Admin_System_Global.lang["ticket_spec"],  Admin_Sys_Func = function(Admin_Sys_Ply)
net.Start("FSpectateTarget")
net.WriteEntity(Admin_Sys_Ply)
net.SendToServer()
end},

[8] = {Admin_Sys_String = Admin_System_Global.lang["ticket_copy"],  Admin_Sys_Func = function(Admin_Sys_Ply)
local Admin_Sys_DermaMenu = DermaMenu()

local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption( Admin_System_Global.lang["ticket_copysteam"], function()
SetClipboardText( Admin_Sys_Ply:SteamID() )
LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
end)
local Admin_Sys_AddOption_1 = Admin_Sys_DermaMenu:AddOption( Admin_System_Global.lang["ticket_copynom"], function()
SetClipboardText( Admin_Sys_Ply:Nick() )
LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copynom_t"] )
end)

Admin_Sys_DermaMenu:Open()
end}
}

net.Receive("Admin_Sys:Remv_Tick",function()
local Admin_Sys_Ent = net.ReadEntity()

for _, v in pairs(Admin_Sys_Table_Tick) do
     if (v.PlayerAT == Admin_Sys_Ent) then
          if IsValid(v) then
               v:Remove()
          end
     end
end
end)

net.Receive("Admin_Sys:Notif", function()
local Admin_Sys_String = net.ReadString()

Admin_System_Global:Notification( Admin_Sys_String )
end)

net.Receive("Admin_Sys:Take_Tick",function()
local Admin_Sys_TblTake, Admin_Sys_Int = {}, 2
for i = 1, Admin_Sys_Int do
     Admin_Sys_TblTake[i] = net.ReadEntity()
end

if not IsValid(Admin_Sys_TblTake[1]) or not IsValid(Admin_Sys_TblTake[2]) then
     return
end

for _, v in pairs(Admin_Sys_Table_Tick) do
     if (v.PlayerAT == Admin_Sys_TblTake[2]) then
          if (v.Admin_Sys_Waiting_Val ~= Admin_Sys_Waiting and v.Admin_Sys_Waiting_Val ~= Admin_Sys_TblTake[1]:UserID()) then
              Admin_Sys_TblTake[2]:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_notif"] .. "" ..Admin_Sys_TblTake[1]:Nick())
          end

          v.Admin_Sys_Waiting_Val = Admin_Sys_TblTake[1]:UserID()
          v.Admin_Sys_Col_Wait = Color(41, 128, 185)
     end
end
end)

local function Admin_Sys_ReturnIDtoName(id, panel)
     if not IsValid(panel) then
          return ""
     end

     local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
     for _, v in ipairs(Admin_Sys_FindClass_Ply) do
          if (panel.Admin_Sys_Waiting_Val == v:UserID()) then
               return v:Nick()
          end
     end

     return Admin_System_Global.lang["ticket_disco"]
end

local function Admin_Sys_Status(Admin_Sys_Admin, Admin_Sys_Bool, Admin_Sys_Ply, Admin_Sys_Frame)
     if not IsValid(Admin_Sys_Ply) then
          if IsValid(Admin_Sys_Frame) then
               Admin_Sys_Frame:Remove()
          end
          return false, Admin_Sys_Admin:PrintMessage(HUD_PRINTTALK, Admin_System_Global.lang["ticket_disco"])
     end

     if not Admin_Sys_Bool then
          for _, v in pairs(Admin_Sys_Table_Tick) do  
               if (v.Admin_Sys_Waiting_Val == Admin_Sys_Admin:UserID() and v.PlayerAT == Admin_Sys_Ply) then
                    return true
               end
          end   
		  return false, Admin_Sys_Admin:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_taking_charge"] )
     end
	 
	 if not Admin_System_Global.Ticket_TakePerm and Admin_System_Global.General_Permission[Admin_Sys_Admin:GetUserGroup()] or Admin_Sys_Admin:AdminStatusCheck() then
          return true
     end

     return false, Admin_Sys_Admin:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_modeadmin_notif"] )
end

local function Admin_Sys_LoadText(Admin_Sys_Ent, Admin_Sys_Txt)
for _, ck in pairs(Admin_Sys_Table_Tick) do

     if (ck.PlayerAT == Admin_Sys_Ent) then
	 
          ck:GetChildren()[6]:AppendText("\n".. Admin_Sys_Txt)
          ck:GetChildren()[6]:GotoTextEnd()

          if Admin_System_Global.Ticket_Delai ~= 0 then
               if timer.Exists("Admin_Sys_Tick_Delay"..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64())) then
                    timer.Remove("Admin_Sys_Tick_Delay"..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64()))
               end
               timer.Create("Admin_Sys_Tick_Delay"..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64()),Admin_System_Global.Ticket_Delai,1,function()
               if IsValid(ck) then
                    net.Start("Admin_Sys:TP_Reset")
                    net.WriteUInt( 2, 4 )
                    net.WriteEntity(Admin_Sys_Ent)
                    net.SendToServer()
                    ck:Remove()
               end
               end)
          end
		  
          return true
     end
end

return false
end

local function Admin_Sys_Ticket_Pos_H(Admin_Sys_Val, Admin_Sys_Type)
     local Admin_Sys_Number, Admin_Sys_Numb = 0

     if Admin_Sys_Type == "ticket" then
          if Admin_System_Global.Ticket_PosRdm_H == "haut" then
               Admin_Sys_Numb = not Admin_System_Global.Admin_System_AutoRdm and 285 or Admin_System_Global:Size_Auto(285, "h")
               Admin_Sys_Number = Admin_Sys_Numb + (Admin_System_Global:Size_Auto(180, "h") * (Admin_Sys_Val - 1))
          elseif Admin_System_Global.Ticket_PosRdm_H == "milieu" then
               Admin_Sys_Numb = not Admin_System_Global.Admin_System_AutoRdm and 60 or Admin_System_Global:Size_Auto(60, "h")
               Admin_Sys_Number = ScrH() / 2 - Admin_Sys_Numb + (Admin_System_Global:Size_Auto(180, "h") * Admin_Sys_Val)
          end
     else
          if Admin_System_Global.Ticket_PosRdm_H == "haut" then
               Admin_Sys_Numb = not Admin_System_Global.Admin_System_AutoRdm and 20 or Admin_System_Global:Size_Auto(20, "h")
               Admin_Sys_Number =  Admin_Sys_Numb
          elseif Admin_System_Global.Ticket_PosRdm_H == "milieu" then
               Admin_Sys_Numb = not Admin_System_Global.Admin_System_AutoRdm and 140 or Admin_System_Global:Size_Auto(140, "h")
               Admin_Sys_Number = ScrH() / 2 - Admin_Sys_Numb
          end
     end

     return math.Round(Admin_Sys_Number)
end

local function Admin_Sys_Ticket_Pos_W(Admin_Sys_Type)
     if Admin_Sys_Type == "ticket" then

          if Admin_System_Global.Ticket_PosRdm_W == "droite" then
               Admin_Sys_Number = ScrW() - Admin_System_Global:Size_Auto(305, "w") - Admin_System_Global:Size_Auto(10, "w")
          elseif Admin_System_Global.Ticket_PosRdm_W == "gauche" then
               Admin_Sys_Number = not Admin_System_Global.Admin_System_AutoRdm and 5 or Admin_System_Global:Size_Auto(5, "w")
          end
     else
          if Admin_System_Global.Ticket_PosRdm_W == "droite" then
               Admin_Sys_Number = ScrW() - Admin_System_Global:Size_Auto(45, "w")
          elseif Admin_System_Global.Ticket_PosRdm_W == "gauche" then
               Admin_Sys_Number = -Admin_System_Global:Size_Auto(160, "w")
          end
     end

     return math.Round(Admin_Sys_Number)
end

local function Admin_Sys_RemoveTick(Admin_Sys_Ent, Admin_Sys_Titre)
     net.Start("Admin_Sys:Remv_Tick")
     net.WriteEntity(Admin_Sys_Ent)
     net.WriteBool(true)
     net.WriteString(Admin_Sys_Titre)
     net.SendToServer()
end

local function Admin_Sys_Notification_Func()
surface.PlaySound( Admin_System_Global.Notif_Son )
if IsValid(Admin_Sys_Frame_Notification) then
     return
end

Admin_Sys_Frame_Notification = vgui.Create( "DFrame" )
local Admin_Sys_Notification_BT = vgui.Create("DImageButton",Admin_Sys_Frame_Notification)
local Admin_Sys_Notification_BT_1 = vgui.Create("DImageButton",Admin_Sys_Frame_Notification)
local Admin_Sys_Notification_Count, Admin_Sys_Notification_Hover = 0, false
local Admin_Sys_Notification_String, Admin_Sys_Notification_W = "..", Admin_System_Global.Ticket_PosRdm_W == "gauche" and Admin_System_Global:Size_Auto(25, "w") or Admin_System_Global:Size_Auto(175, "w")

Admin_Sys_Frame_Notification:SetSize(  Admin_System_Global:Size_Auto(200, "w"), Admin_System_Global:Size_Auto(27, "h") )
Admin_Sys_Frame_Notification:SetPos(Admin_System_Global.Ticket_PosRdm_W == "gauche" and - Admin_System_Global:Size_Auto(190, "w") or ScrW() - Admin_System_Global:Size_Auto(70, "w"), Admin_Sys_Ticket_Pos_H(nil, "notif"))
Admin_Sys_Frame_Notification:MoveTo(Admin_Sys_Ticket_Pos_W(nil), Admin_Sys_Ticket_Pos_H(nil, "notif"), 0.3, 0,1, function() end)
Admin_Sys_Frame_Notification:SetTitle( "" )
Admin_Sys_Frame_Notification:SetDraggable(true)
Admin_Sys_Frame_Notification:ShowCloseButton(false)
Admin_Sys_Frame_Notification.Paint = function( self, w, h )
local Admin_Sys_Math_Abs = math.abs(math.sin(CurTime() * 5) * 192)
local Admin_Sys_Color_Cur = Color(Admin_Sys_Math_Abs, 57, 43)

if self:IsHovered() and not Admin_Sys_Notification_Hover then

     self:MoveTo(Admin_System_Global.Ticket_PosRdm_W == "gauche" and Admin_System_Global:Size_Auto(10, "w") or ScrW() - Admin_System_Global:Size_Auto(215, "w"), Admin_Sys_Ticket_Pos_H(nil, "notif") + Admin_System_Global:Size_Auto(40, "h"), 0.3, 0,1,function()
     Admin_Sys_Notification_String = Admin_System_Global.lang["ticket_modeadmin_att"]
     Admin_Sys_Notification_W = Admin_System_Global.Ticket_PosRdm_W == "gauche" and Admin_System_Global:Size_Auto(82, "w") or Admin_System_Global:Size_Auto(117, "w")
     end)

     Admin_Sys_Notification_Hover = true
end

Admin_Sys_Notification_Count = #Admin_Sys_Table_Tick or 0
if (Admin_Sys_Notification_Count <= 0) then
     Admin_Sys_Tick_Visible = false
     Admin_Sys_Frame_Notification:Remove()
end

draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Admin_System_Global.NotifTick )
draw.RoundedBox( 4, Admin_System_Global.Ticket_PosRdm_W == "gauche" and w - Admin_System_Global:Size_Auto(8, "w") or 1, 1, Admin_System_Global:Size_Auto(7, "h"), Admin_System_Global:Size_Auto(23, "h"), Admin_Sys_Color_Cur)
draw.DrawText( Admin_Sys_Notification_String ..Admin_Sys_Notification_Count, "Admin_Sys_Font_T1", w- Admin_System_Global:Size_Auto(Admin_Sys_Notification_W, "w") , Admin_System_Global:Size_Auto(4, "h"), Admin_System_Global.NotifTickText, TEXT_ALIGN_CENTER )
end

Admin_Sys_Notification_BT:SetPos(Admin_System_Global.Ticket_PosRdm_W == "gauche" and Admin_System_Global:Size_Auto(2, "w") or Admin_System_Global:Size_Auto(180, "w"),Admin_System_Global:Size_Auto(4, "h"))
Admin_Sys_Notification_BT:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_Sys_Notification_BT:SetImage( "icon16/cross.png" )
function Admin_Sys_Notification_BT:Paint(w,h) end
Admin_Sys_Notification_BT.DoClick = function()
Admin_Sys_Frame_Notification:MoveTo(Admin_System_Global.Ticket_PosRdm_W == "gauche" and -Admin_System_Global:Size_Auto(160, "w") or ScrW() - Admin_System_Global:Size_Auto(45, "w"), Admin_Sys_Ticket_Pos_H(nil, "notif"), 0.3, 0,1, function()
     Admin_Sys_Notification_String = "+ "
     Admin_Sys_Notification_W = Admin_System_Global.Ticket_PosRdm_W == "gauche" and Admin_System_Global:Size_Auto(25, "w") or Admin_System_Global:Size_Auto(175, "w")
     
	 Admin_Sys_Notification_Hover = false     
	 gui.EnableScreenClicker(false)
     end)
end

Admin_Sys_Notification_BT_1:SetPos(Admin_System_Global.Ticket_PosRdm_W == "gauche" and Admin_System_Global:Size_Auto(24, "w") or Admin_System_Global:Size_Auto(159, "w"), Admin_System_Global:Size_Auto(4, "h"))
Admin_Sys_Notification_BT_1:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
Admin_Sys_Notification_BT_1:SetImage("icon16/add.png")
function Admin_Sys_Notification_BT_1:Paint(w, h) end
Admin_Sys_Notification_BT_1.DoClick = function()
local Admin_Sys_Derma = DermaMenu()

local Admin_Sys_Option = Admin_Sys_Derma:AddOption(Admin_System_Global.lang["ticket_modeadmin_afftick"], function()

for i = 1, #Admin_Sys_Table_Tick do
     if i > Admin_System_Global.Ticket_TicketVisible  then
          break
     end
     Admin_Sys_Table_Tick[i]:SetVisible(true)
end
Admin_Sys_Tick_Visible = true
end)

local Admin_Sys_AddOption_1 = Admin_Sys_Derma:AddOption(Admin_System_Global.lang["ticket_modeadmin_cachtick"], function()
for i = 1, #Admin_Sys_Table_Tick do
     Admin_Sys_Table_Tick[i]:SetVisible(false)
end
end)

Admin_Sys_Tick_Visible = false
Admin_Sys_Derma:Open()
end

timer.Simple(0.000001, function()
Admin_Sys_Notification_String = "+ "
end)
end

local function Admin_Sys_Admin_Restrict(Admin_Sys_TblRes, Admin_Sys_Ent)
if Admin_Sys_LoadText(Admin_Sys_Ent, Admin_Sys_TblRes[2]) then
     return
end

if Admin_System_Global.Notif_Bool then
     Admin_Sys_Notification_Func()
else
     surface.PlaySound( Admin_System_Global.Notif_Son )
end

local Admin_Sys_Tick_Frame = vgui.Create("DFrame")
local Admin_Sys_Tick_Scroll = vgui.Create( "DScrollPanel", Admin_Sys_Tick_Frame)
local Admin_Sys_Tick_RichText = vgui.Create("RichText",Admin_Sys_Tick_Frame)
local Admin_Sys_Tick_Dimage = vgui.Create("DImageButton",Admin_Sys_Tick_Frame)
local Admin_Sys_Tick_Dimage_1 = vgui.Create("DImageButton",Admin_Sys_Tick_Frame)
local Admin_Sys_Tick_BT = vgui.Create("DButton",Admin_Sys_Tick_Frame)
local Admin_Sys_Tick_BT_1 = vgui.Create("DButton",Admin_Sys_Tick_Frame)

Admin_Sys_Tick_Frame:SetTitle("")
Admin_Sys_Tick_Frame:SetPos(ScrW() / 2,0)
Admin_Sys_Tick_Frame:SetSize(Admin_System_Global:Size_Auto(300, "w"),Admin_System_Global:Size_Auto(145, "h"))
Admin_Sys_Tick_Frame:ShowCloseButton(false)
Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val = Admin_System_Global.lang["ticket_wait"]
Admin_Sys_Tick_Frame.Admin_Sys_Col_Wait = Color(192, 57, 43)
Admin_Sys_Tick_Frame.PlayerAT = Admin_Sys_Ent
timer.Simple(0.000001,function()
for i = 1, #Admin_Sys_Table_Tick do
     if Admin_System_Global.Notif_Bool then
          if not Admin_Sys_Tick_Visible then
               if IsValid(Admin_Sys_Tick_Frame) then
                    Admin_Sys_Tick_Frame:SetVisible(false)
                    break
               end
          else
               if i > Admin_System_Global.Ticket_TicketVisible then
                    Admin_Sys_Table_Tick[i]:SetVisible(false)
               else
                    Admin_Sys_Table_Tick[i]:SetVisible(true)
               end
          end
     else
          if i > Admin_System_Global.Ticket_TicketVisible then
               Admin_Sys_Table_Tick[i]:SetVisible(false)
          else
               Admin_Sys_Table_Tick[i]:SetVisible(true)
          end
     end
end
end)
function Admin_Sys_Tick_Frame:Paint(w, h)
     Admin_System_Global:Gui_Blur(self, Admin_System_Global:Size_Auto(1, "w"), Color( 0, 0, 0, 150 ), 6)
     draw.RoundedBoxEx( 5, 0, 0, w, h/2 - Admin_System_Global:Size_Auto(53, "h"), 	Admin_System_Global.TicketBorder, true, true, false, false )
     draw.DrawText(Admin_System_Global.lang["ticket_tick"].. "" ..((IsValid(Admin_Sys_Ent) and Admin_Sys_Ent:Nick()) or "Déconnecté"), "Admin_Sys_Font_T3", w/2, Admin_System_Global:Size_Auto(3, "h"), Admin_System_Global.TicketText, TEXT_ALIGN_CENTER )

     if self.Admin_Sys_Waiting_Val == Admin_Sys_Waiting then
          draw.SimpleTextOutlined(self.Admin_Sys_Waiting_Val ..Admin_System_Global:Admin_Sys_TicketDot(), "Admin_Sys_Font_T3", Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(90, "h"), Admin_System_Global.TicketText, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, self.Admin_Sys_Col_Wait)
     else
          draw.SimpleTextOutlined(Admin_System_Global.lang["ticket_notif_taking_charge"], "Admin_Sys_Font_T3", Admin_System_Global:Size_Auto(30, "w"), Admin_System_Global:Size_Auto(80, "h"), Admin_System_Global.TicketText, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 0.8, self.Admin_Sys_Col_Wait)
          draw.SimpleTextOutlined(not Admin_System_Global.Ticket_CachePCharge and Admin_Sys_ReturnIDtoName(self.Admin_Sys_Waiting_Val, self) or Admin_System_Global.Ticket_CachePCharge_Text, "Admin_Sys_Font_T3", Admin_System_Global:Size_Auto(90, "w"), Admin_System_Global:Size_Auto(105, "h"), Admin_System_Global.TicketText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 0.8, self.Admin_Sys_Col_Wait)
     end
     if IsValid(Admin_Sys_Ent) and timer.Exists("Admin_Sys_Tick_Delay"..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64())) then
          draw.DrawText("(" ..math.Round(timer.TimeLeft( "Admin_Sys_Tick_Delay" ..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64()))).. ")", "Admin_Sys_Font_T3", Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(2, "h"), Admin_System_Global.TicketText, TEXT_ALIGN_LEFT )
     end
end
Admin_Sys_Tick_Frame:MoveTo(Admin_Sys_Ticket_Pos_W("ticket"), Admin_Sys_Ticket_Pos_H(#Admin_Sys_Table_Tick, "ticket"), 0.3, 0,1, function() end)
table.insert(Admin_Sys_Table_Tick, Admin_Sys_Tick_Frame)
function Admin_Sys_Tick_Frame:OnRemove()
     for i = 1, #Admin_Sys_Table_Tick do
          if (Admin_Sys_Table_Tick[i] == self) then
               table.remove( Admin_Sys_Table_Tick, i )
          end
     end

     if IsValid(Admin_Sys_Ent) and Admin_Sys_Ent:IsPlayer() and timer.Exists("Admin_Sys_Tick_Delay" ..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64())) then
          timer.Remove("Admin_Sys_Tick_Delay" ..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64()))
     end

     timer.Simple(0.2,function()
     for i = 1, #Admin_Sys_Table_Tick do
          Admin_Sys_Table_Tick[i]:MoveTo( Admin_Sys_Ticket_Pos_W("ticket"), Admin_Sys_Ticket_Pos_H(i, "ticket") - Admin_System_Global:Size_Auto(180, "h"), 0.1, 0, 1, function() end)

          if Admin_System_Global.Notif_Bool then
               if not Admin_Sys_Tick_Visible then
                    if IsValid(Admin_Sys_Tick_Frame) then
                         Admin_Sys_Tick_Frame:SetVisible(false)
                         break
                    end
               else
                    if i > Admin_System_Global.Ticket_TicketVisible then
                         Admin_Sys_Table_Tick[i]:SetVisible(false)
                    else
                         Admin_Sys_Table_Tick[i]:SetVisible(true)
                    end
               end
          else
               if i > Admin_System_Global.Ticket_TicketVisible then
                    Admin_Sys_Table_Tick[i]:SetVisible(false)
               else
                    Admin_Sys_Table_Tick[i]:SetVisible(true)
               end
          end
     end
     end)
end

Admin_Sys_Tick_Scroll:SetPos( Admin_System_Global:Size_Auto(178, "w"), Admin_System_Global:Size_Auto(26, "h") )
Admin_Sys_Tick_Scroll:SetSize( Admin_System_Global:Size_Auto(120, "w"), Admin_System_Global:Size_Auto(113, "h") )
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

Admin_Sys_Tick_RichText:SetPos(Admin_System_Global:Size_Auto(5, "w"),Admin_System_Global:Size_Auto(25, "h"))
Admin_Sys_Tick_RichText:SetSize(Admin_System_Global:Size_Auto(185, "w"),Admin_System_Global:Size_Auto(47, "h"))
Admin_Sys_Tick_RichText:InsertColorChange( 255, 255, 255, 255 )
Admin_Sys_Tick_RichText:SetVerticalScrollbarEnabled(true)
local Admin_Sys_RichText_Children = Admin_Sys_Tick_RichText:GetChildren()[1] 
local Admin_Sys_RichText_Children_1 = Admin_Sys_Tick_RichText:GetChildren()[2] 
Admin_Sys_RichText_Children.Paint = function( self, w, h )
  draw.RoundedBox(6, 0, 0, w-Admin_System_Global:Size_Auto(1, "w"), h, Admin_System_Global.TicketScrollRichText)
end
Admin_Sys_RichText_Children_1.Paint = function( self, w, h )
  draw.RoundedBox(6, 0, 0, w-Admin_System_Global:Size_Auto(1, "w"), h, Color(0,0,0,15) )
end
function Admin_Sys_Tick_RichText:PerformLayout()
  self:SetFontInternal( "Admin_Sys_Font_T3" )
end
Admin_Sys_Tick_RichText:AppendText(Admin_Sys_TblRes[2])
for i = 1, #Admin_Sys_Table_BT do
     local Admin_Sys_Table_GenBT, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", Admin_Sys_Tick_Scroll), 0, 0.05
     Admin_Sys_Table_GenBT:SetPos(Admin_System_Global:Size_Auto(15, "w"), Admin_System_Global:Size_Auto(25, "h") * i - Admin_System_Global:Size_Auto(25, "h") )
     Admin_Sys_Table_GenBT:SetSize(Admin_System_Global:Size_Auto(95, "w"),Admin_System_Global:Size_Auto(18, "h"))
     Admin_Sys_Table_GenBT:SetText("")
     Admin_Sys_Table_GenBT.Paint = function(self,w,h)
     draw.RoundedBox( 3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Admin_System_Global.TicketBut )

     if self:IsHovered() then
          Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - 3)
     else
          Admin_Sys_Lerp = 0
     end

     draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp, 1, Color(192, 57, 43) )
     draw.DrawText(Admin_Sys_Table_BT[i].Admin_Sys_String, "Admin_Sys_Font_T2", w/2, 2, Admin_System_Global.TicketButText, TEXT_ALIGN_CENTER)
end
Admin_Sys_Table_GenBT.DoClick = function()
if not (i == 7 or i == 8 or i == 3) then
     if not Admin_Sys_Status(LocalPlayer(), false, Admin_Sys_Ent, Admin_Sys_Tick_Frame) then
          return
     end
end

Admin_Sys_Table_BT[i].Admin_Sys_Func(Admin_Sys_Ent)
surface.PlaySound("buttons/button24.wav")
end
end

local Admin_Sys_Lerp_, Admin_Sys_Lerp_An_ = 0, 0.05
Admin_Sys_Tick_BT:SetPos(Admin_System_Global:Size_Auto(98, "w"), Admin_System_Global:Size_Auto(123, "h"))
Admin_Sys_Tick_BT:SetSize(Admin_System_Global:Size_Auto(90, "w"), Admin_System_Global:Size_Auto(18, "h")) 
Admin_Sys_Tick_BT:SetText("")
Admin_Sys_Tick_BT.Paint = function(self, w, h)
draw.RoundedBox( 3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Admin_System_Global.Ticket_ColPrdrTick )

if self:IsHovered() then
     Admin_Sys_Lerp_ = Lerp(Admin_Sys_Lerp_An_, Admin_Sys_Lerp_, w - 3)
else
     Admin_Sys_Lerp_ = 0
end

draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp_, 1, Color(192, 57, 43) )
draw.DrawText(Admin_System_Global.lang["ticket_prd"],"Admin_Sys_Font_T2",w / 2, Admin_System_Global:Size_Auto(2, "h"),Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
end
Admin_Sys_Tick_BT.DoClick = function()
if not Admin_Sys_Status(LocalPlayer(), true, Admin_Sys_Ent, Admin_Sys_Tick_Frame) then
     return
end
if Admin_System_Global.Ticket_AntiPCharge and (Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val ~= LocalPlayer():UserID() and Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val ~= Admin_Sys_Waiting) then
     LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_tickdj"])
     return
end
if (Admin_Sys_Tick_Frame.Admin_Sys_Waiting_Val == LocalPlayer():UserID()) then
     LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_prisdj"])
     return
end

net.Start("Admin_Sys:Take_Tick")
net.WriteEntity(Admin_Sys_Ent)
net.SendToServer()
end

local Admin_Sys_Lerp_x, Admin_Sys_Lerp_An_x = 0, 0.05
Admin_Sys_Tick_BT_1:SetPos(Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(123, "h"))
Admin_Sys_Tick_BT_1:SetSize(Admin_System_Global:Size_Auto(90, "w"), Admin_System_Global:Size_Auto(18, "h"))
Admin_Sys_Tick_BT_1:SetText("")
Admin_Sys_Tick_BT_1.Paint = function(self,w,h)
draw.RoundedBox( 3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Admin_System_Global.Ticket_ColTickReso )
if self:IsHovered() then
  Admin_Sys_Lerp_x = Lerp(Admin_Sys_Lerp_An_x, Admin_Sys_Lerp_x, w - 3)
else
  Admin_Sys_Lerp_x = 0
end

draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp_x, 1, Color(192, 57, 43) )
draw.DrawText(Admin_System_Global.lang["ticket_reso"], "Admin_Sys_Font_T2", w/2, Admin_System_Global:Size_Auto(2, "h"), Color(255,255,255, 255), TEXT_ALIGN_CENTER)
end
Admin_Sys_Tick_BT_1.DoClick = function()
if not IsValid(Admin_Sys_Ent) then
     Admin_Sys_Tick_Frame:Remove()
     return
end

if not Admin_Sys_Status(LocalPlayer(), false, Admin_Sys_Ent, Admin_Sys_Tick_Frame) then
     return
end

local Admin_Sys_DermaMenu = DermaMenu()

local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_resotp"], function()
net.Start("Admin_Sys:TP_Reset")
net.WriteUInt( 2, 4 )
net.WriteEntity(Admin_Sys_Ent)
net.SendToServer()

timer.Simple(0.1, function()
Admin_Sys_RemoveTick(Admin_Sys_Ent, Admin_Sys_TblRes[1])
end)
end)

local Admin_Sys_AddOption_1 = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_resonotp"],function()
net.Start("Admin_Sys:TP_Reset")
net.WriteUInt( 1, 4 )
net.WriteEntity(Admin_Sys_Ent)
net.SendToServer()

timer.Simple(0.1, function()
Admin_Sys_RemoveTick(Admin_Sys_Ent, Admin_Sys_TblRes[1])
end)
end)

Admin_Sys_DermaMenu:Open()
end

Admin_Sys_Tick_Dimage_1:SetPos(Admin_System_Global:Size_Auto(265, "w"), Admin_System_Global:Size_Auto(3, "h"))
Admin_Sys_Tick_Dimage_1:SetSize(Admin_System_Global:Size_Auto(13, "w"), Admin_System_Global:Size_Auto(13, "h"))
Admin_Sys_Tick_Dimage_1:SetImage("icon16/shield.png")	
Admin_Sys_Tick_Dimage_1:SetTooltip( Admin_System_Global.lang["ticket_enabadmin"] )
Admin_Sys_Tick_Dimage_1.Think = function()
if not LocalPlayer():AdminStatusCheck() then
     Admin_Sys_Tick_Dimage_1:SetImage("icon16/shield_add.png")
else
     Admin_Sys_Tick_Dimage_1:SetImage("icon16/shield_delete.png")
end
end
Admin_Sys_Tick_Dimage_1.DoClick = function()
local Admin_Sys_DermaMenu = DermaMenu()

local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption(not LocalPlayer():AdminStatusCheck() and Admin_System_Global.lang["ticket_activadmin"] or Admin_System_Global.lang["ticket_desactadmin"],function()
net.Start("Admin_Sys:Cmd_Status")
net.SendToServer()
end)

if LocalPlayer():AdminStatusCheck() then
     local Admin_Sys_AddOption_Choice = Admin_Sys_DermaMenu:AddOption(Admin_System_Global.lang["ticket_choice"], function() end)
     local Admin_Sys_AddOption_Sub, Admin_Sys_AddOption_Parent = Admin_Sys_AddOption_Choice:AddSubMenu(Admin_System_Global.lang["ticket_addpos"])

     local Admin_Sys_AddOption_Choice_1 = Admin_Sys_AddOption_Sub:AddOption(LocalPlayer():GetMoveType() ~= MOVETYPE_NOCLIP and Admin_System_Global.lang["ticket_actnoclip"] or Admin_System_Global.lang["ticket_desactnoclip"], function()
     LocalPlayer():ConCommand(Admin_System_Global.Mode_AddCmd_NoClip)
     end)
     local Admin_Sys_AddOption_Choice_2 = Admin_Sys_AddOption_Sub:AddOption(not LocalPlayer():GetNoDraw() and Admin_System_Global.lang["ticket_actcloak"] or Admin_System_Global.lang["ticket_desactcloak"], function()
	 LocalPlayer():ConCommand(Admin_System_Global.Mode_AddCmd_Cloak)
     end)
     local Admin_Sys_AddOption_Choice_3 = Admin_Sys_AddOption_Sub:AddOption(not Admin_System_Global.SysGodModeStatus and Admin_System_Global.lang["ticket_actgodmode"] or Admin_System_Global.lang["ticket_desactgodmode"], function()
     LocalPlayer():ConCommand(Admin_System_Global.Mode_AddCmd_GodMod)
     end)
end

Admin_Sys_DermaMenu:Open()
end

Admin_Sys_Tick_Dimage:SetPos(Admin_System_Global:Size_Auto(282, "w"), Admin_System_Global:Size_Auto(2, "h"))
Admin_Sys_Tick_Dimage:SetSize(Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(16, "h"))
Admin_Sys_Tick_Dimage:SetImage("icon16/cross.png")		
Admin_Sys_Tick_Dimage.DoClick = function()
local Admin_Sys_DermaMenu = DermaMenu()

local Admin_Sys_AddOption = Admin_Sys_DermaMenu:AddOption( Admin_System_Global.lang["ticket_frmtick"], function()
net.Start("Admin_Sys:TP_Reset")
net.WriteUInt( 2, 4 )
net.WriteEntity(Admin_Sys_Ent)
net.SendToServer()

Admin_Sys_Tick_Frame:Remove()
end)

Admin_Sys_DermaMenu:Open()
end

if Admin_System_Global.Ticket_Delai ~= 0 then
timer.Create("Admin_Sys_Tick_Delay" ..((Admin_Sys_Ent:IsBot() and Admin_Sys_Ent:Nick()) or Admin_Sys_Ent:SteamID64()), Admin_System_Global.Ticket_Delai, 1, function()
        if IsValid(Admin_Sys_Tick_Frame) then
		
         net.Start("Admin_Sys:TP_Reset")
         net.WriteUInt( 2, 4 )
         net.WriteEntity(Admin_Sys_Ent)
         net.SendToServer()
		 
         Admin_Sys_Tick_Frame:Remove()
        end
    end)
end
end
 
net.Receive("Admin_Sys:Gen_Tick", function()
local Admin_Sys_Ent = net.ReadEntity()
local Admin_Sys_Int = net.ReadUInt(8)
if not IsValid(Admin_Sys_Ent) or not Admin_Sys_Ent:IsPlayer() then
     return
end

local Admin_Sys_Tbl = {}
for i = 1, Admin_Sys_Int do
     Admin_Sys_Tbl[i] = net.ReadString()
end

Admin_Sys_Tbl[2] = Admin_Sys_Tbl[2] ~= "" and Admin_System_Global.lang["net_ticket_title"].. "" ..Admin_Sys_Tbl[1].. "\n" ..Admin_Sys_Tbl[2] or Admin_System_Global.lang["net_ticket_title"].. "" ..Admin_Sys_Tbl[1]
Admin_Sys_Admin_Restrict(Admin_Sys_Tbl, Admin_Sys_Ent)
end)