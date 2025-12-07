----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/
if not Admin_System_Global.TicketLoad then return end

local Admin_Sys_TicketSending, Admin_Sys_FrameInfo = 0

local function Admin_Sys_Check_Frame(Admin_Sys_FrameComp, Admin_Sys_BoolOp)
     if Admin_Sys_BoolOp then	 
          net.Start("Admin_Sys:Remv_Tick")
          net.WriteBool(false)
          net.SendToServer()		  
     end	 
     if IsValid(Admin_Sys_FrameComp) then		  
          Admin_Sys_FrameComp:Remove()
     end	 
end

local function Admin_Sys_Frame_Comp(Admin_Sys_StringTitle)

local Admin_Sys_Frame = vgui.Create( "DFrame" )
local Admin_Sys_Dtext = vgui.Create( "DTextEntry", Admin_Sys_Frame ) 
local Admin_Sys_BT_1 = vgui.Create( "DButton", Admin_Sys_Frame  )
local Admin_Sys_Dimage = vgui.Create("DImageButton", Admin_Sys_Frame)
local Admin_Sys_Dimage_Back = vgui.Create("DImageButton", Admin_Sys_Frame)
local Admin_Sys_Number, Admin_Sys_StringText, Admin_Sys_CharCount = false, ""
local Admin_Sys_ColVal = Color(192, 57, 43)

Admin_Sys_Frame:SetTitle("")
Admin_Sys_Frame:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(200, "h"))
Admin_Sys_Frame:ShowCloseButton(false)
Admin_Sys_Frame:SetDraggable(true)
Admin_Sys_Frame:Center()
Admin_Sys_Frame:MakePopup()
function Admin_Sys_Frame:Init()
     self.startTime = SysTime()
end
Admin_Sys_Frame.Paint = function(self, w, h)
Derma_DrawBackgroundBlur(self, self.startTime)
surface.SetDrawColor( Admin_System_Global.CreatetickColorCompCtr.r, Admin_System_Global.CreatetickColorCompCtr.g, Admin_System_Global.CreatetickColorCompCtr.b )
surface.DrawOutlinedRect( 0, 0, w, h, 5 )

draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"),  Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(9, "w"), Admin_System_Global:Size_Auto(26, "h"), Admin_Sys_ColVal )
draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"), Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(25, "h"), Admin_System_Global.CreatetickColorComp) -- Top border
draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(30, "h"), w - Admin_System_Global:Size_Auto(10, "w"), h - Admin_System_Global:Size_Auto(36, "h"), Color(0,0,0,100) ) -- Background middle but
draw.RoundedBox(11, w - Admin_System_Global:Size_Auto(25, "w"), Admin_System_Global:Size_Auto(7, "h"), Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"), Color(0,0,0,100) )
draw.RoundedBox(11, Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(7, "h"), Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"), Color(0,0,0,100) )

draw.DrawText(Admin_System_Global.lang["title"] .. "" .. Admin_Sys_StringTitle,"Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(6, "h"),Admin_System_Global.CreatetickColorCompTitle,TEXT_ALIGN_CENTER)
draw.DrawText(Admin_System_Global.lang["reason"],"Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(45, "h"),Admin_System_Global.CreatetickColorCompTitle,TEXT_ALIGN_CENTER)

Admin_Sys_CharCount = Admin_System_Global.CharMax

if Admin_Sys_Number and Admin_Sys_Number > 0 then
     Admin_Sys_CharCount = Admin_System_Global.CharMax - Admin_Sys_Number
     Admin_Sys_ColVal = Color(39, 174, 96)
end

if Admin_Sys_CharCount < 0 then
     Admin_Sys_CharCount = 0
elseif Admin_Sys_CharCount >= Admin_System_Global.CharMax then
     Admin_Sys_ColVal = Color(192, 57, 43)
end

draw.DrawText(Admin_System_Global.lang["character"].. "" .. Admin_Sys_CharCount,"Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(125, "h"), Admin_System_Global.CreatetickColorCompTextChar, TEXT_ALIGN_CENTER)
end

Admin_Sys_Dtext:SetPos(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(80, "h"))
Admin_Sys_Dtext:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(25, "h"))
Admin_Sys_Dtext:SetText(Admin_System_Global.lang["complaint"])
Admin_Sys_Dtext:SetFont("Admin_Sys_Font_T4")
Admin_Sys_Dtext.MaxCaractere = Admin_System_Global.CharMax
Admin_Sys_Dtext.OnGetFocus = function()
    if Admin_Sys_Dtext:GetText() == Admin_System_Global.lang["complaint"] then
        Admin_Sys_Dtext:SetTextColor(Color(0, 0, 0, 255))
        Admin_Sys_Dtext:SetText("")
    end
end
Admin_Sys_Dtext.OnTextChanged = function(self)
    Admin_Sys_StringText = self:GetValue()
    Admin_Sys_Number = string.len(Admin_Sys_StringText)
	
    if Admin_Sys_Number > self.MaxCaractere then
        self:SetText(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
        self:SetValue(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
    else
        self.Admin_Sys_ODTextVal = Admin_Sys_StringText
    end
end

Admin_Sys_BT_1:SetPos(Admin_System_Global:Size_Auto(90, "w"), Admin_System_Global:Size_Auto(157, "h"))
Admin_Sys_BT_1:SetSize(Admin_System_Global:Size_Auto(100, "w"), Admin_System_Global:Size_Auto(25, "h"))
Admin_Sys_BT_1:SetText("")
Admin_Sys_BT_1.Paint = function(self, w, h)
  draw.RoundedBox( 1, Admin_System_Global:Size_Auto(2, "w"), 1, w, h, Admin_System_Global.CreatetickColorCompValid )
   draw.DrawText(Admin_System_Global.lang["validate"], "Admin_Sys_Font_T4", w / 2, Admin_System_Global:Size_Auto(2, "h"), Admin_System_Global.CreatetickColorCompText, TEXT_ALIGN_CENTER)
end
Admin_Sys_BT_1.DoClick = function()
if Admin_Sys_CharCount >= Admin_System_Global.CharMax then
     return
end

net.Start("Admin_Sys:Gen_Tick")
net.WriteString(Admin_Sys_StringTitle)
net.WriteString(Admin_Sys_StringText)
net.SendToServer()

Admin_Sys_TicketSending = Admin_Sys_TicketSending + 1
timer.Simple(0.1, function()
Admin_Sys_Check_Frame(Admin_Sys_Frame, true)
end)
end

Admin_Sys_Dimage:SetPos(Admin_System_Global:Size_Auto(257, "w"), Admin_System_Global:Size_Auto(10, "h"))
Admin_Sys_Dimage:SetSize(Admin_System_Global:Size_Auto(13, "w"), Admin_System_Global:Size_Auto(13, "h"))
Admin_Sys_Dimage:SetImage("icon16/cross.png")
function Admin_Sys_Dimage:Paint(w, h)
end
Admin_Sys_Dimage.DoClick = function()
timer.Simple(0.1, function()
Admin_Sys_Check_Frame(Admin_Sys_Frame, true)
end)
end

Admin_Sys_Dimage_Back:SetPos(Admin_System_Global:Size_Auto(10, "w"), Admin_System_Global:Size_Auto(10, "h"))
Admin_Sys_Dimage_Back:SetSize(Admin_System_Global:Size_Auto(13, "w"), Admin_System_Global:Size_Auto(13, "h"))
Admin_Sys_Dimage_Back:SetImage("icon16/arrow_left.png")
function Admin_Sys_Dimage_Back:Paint(w, h)
end
Admin_Sys_Dimage_Back.DoClick = function()
LocalPlayer():ConCommand( Admin_System_Global.Ticket_Cmd)
Admin_Sys_Frame:Remove()
end
end

net.Receive("Admin_Sys:Crea_Tick", function()
if IsValid(Admin_Sys_FrameInfo) then return end

Admin_Sys_FrameInfo = vgui.Create("DFrame")
local Admin_Sys_FrameInfo_Scroll = vgui.Create("DScrollPanel", Admin_Sys_FrameInfo)
local Admin_Sys_FrameInfo_Dimage = vgui.Create("DImageButton", Admin_Sys_FrameInfo)

Admin_Sys_FrameInfo:SetTitle("")
Admin_Sys_FrameInfo:ShowCloseButton(false)
Admin_Sys_FrameInfo:SetSize(Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(415, "h"))
Admin_Sys_FrameInfo:MakePopup()
Admin_Sys_FrameInfo:Center()
function Admin_Sys_FrameInfo:Init()
     self.startTime = SysTime()
end
Admin_Sys_FrameInfo.Paint = function(self, w, h)
Derma_DrawBackgroundBlur(self, self.startTime)
surface.SetDrawColor( Admin_System_Global.CreatetickColorCtr.r, Admin_System_Global.CreatetickColorCtr.g, Admin_System_Global.CreatetickColorCtr.b )
surface.DrawOutlinedRect( 0, 0, w, h, 5 )

draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"),  Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(33, "h"), Admin_System_Global.CreatetickColorInfos)
draw.RoundedBox(1, Admin_System_Global:Size_Auto(4, "w"), Admin_System_Global:Size_Auto(4, "h"), w - Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(25, "h"), Admin_System_Global.CreatetickColor) -- Top border
draw.RoundedBox(1, Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(37, "h"), w - Admin_System_Global:Size_Auto(10, "w"), h - Admin_System_Global:Size_Auto(41, "h"), Admin_System_Global.CreatetickColorBackground ) -- Background middle but
draw.RoundedBox(11, w - Admin_System_Global:Size_Auto(27, "w"), Admin_System_Global:Size_Auto(6, "h"), Admin_System_Global:Size_Auto(20, "w"), Admin_System_Global:Size_Auto(20, "h"), Color(0,0,0,100) )
draw.DrawText(Admin_System_Global.lang["creation"],"Admin_Sys_Font_T4",w / 2, Admin_System_Global:Size_Auto(5, "h"), Admin_System_Global.CreatetickColorTitle, TEXT_ALIGN_CENTER)
draw.DrawText("• " ..Admin_System_Global.lang["category"].. " •","Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(92, "h"), Color(255,255,255), TEXT_ALIGN_CENTER)
draw.RoundedBoxEx( 6, Admin_System_Global:Size_Auto(70, "w"), Admin_System_Global:Size_Auto(37, "h"), w -Admin_System_Global:Size_Auto(140, "w"), Admin_System_Global:Size_Auto(38, "h"), Admin_System_Global.CreatetickColorInfos, false, false, true, true )
draw.DrawText("Ticket(s) envoyé(s) : " ..Admin_Sys_TicketSending,"Admin_Sys_Font_T6",w / 2, Admin_System_Global:Size_Auto(37, "h"), Color(255,255,255), TEXT_ALIGN_CENTER)
draw.DrawText("Joueur(s) en ligne : " ..#player.GetAll(),"Admin_Sys_Font_T6",w / 2, Admin_System_Global:Size_Auto(55, "h"), Color(255,255,255), TEXT_ALIGN_CENTER)
end

Admin_Sys_FrameInfo_Scroll:SetSize(Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(257, "h"))
Admin_Sys_FrameInfo_Scroll:SetPos(-Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(130, "h"))
local Admin_Sys_FrameInfo_Vbar = Admin_Sys_FrameInfo_Scroll:GetVBar()
Admin_Sys_FrameInfo_Vbar:SetSize(0, 0)
function Admin_Sys_FrameInfo_Vbar.btnUp:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Up)
end
function Admin_Sys_FrameInfo_Vbar.btnDown:Paint(w, h)
    draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Down)
end
function Admin_Sys_FrameInfo_Vbar.btnGrip:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar)
end

Admin_Sys_FrameInfo_Dimage:SetPos(Admin_System_Global:Size_Auto(275, "w"), Admin_System_Global:Size_Auto(8, "h"))
Admin_Sys_FrameInfo_Dimage:SetSize(Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(16, "h"))
Admin_Sys_FrameInfo_Dimage:SetImage("icon16/cross.png")
function Admin_Sys_FrameInfo_Dimage:Paint(w, h)
end
Admin_Sys_FrameInfo_Dimage.DoClick = function()
    Admin_Sys_Check_Frame(Admin_Sys_FrameInfo, true)
end

for i = 1, #Admin_System_Global.Gen_Ticket do
local Admin_Sys_FrameInfo_BTGen, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", Admin_Sys_FrameInfo_Scroll), 0, 0.05
Admin_Sys_FrameInfo_BTGen:SetSize( Admin_System_Global:Size_Auto(210, "w"), Admin_System_Global:Size_Auto(30, "h") )
Admin_Sys_FrameInfo_BTGen:SetPos( Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(40, "h") * i-Admin_System_Global:Size_Auto(40, "h") )
Admin_Sys_FrameInfo_BTGen:SetText("")
Admin_Sys_FrameInfo_BTGen.Paint = function(self, w, h)
draw.RoundedBox( 3, 0, 0, w, h, Admin_System_Global.CreatetickColorBut )
if self:IsHovered() then
     Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - Admin_System_Global:Size_Auto(4, "w"))
else
     Admin_Sys_Lerp = 0
end

draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), 0, Admin_Sys_Lerp, 1, Color(	41, 128, 185) )
draw.DrawText(Admin_System_Global.Gen_Ticket[i].NameButton, "Admin_Sys_Font_T4", w/2 , 4, Admin_System_Global.CreatetickColorText, TEXT_ALIGN_CENTER)
end
Admin_Sys_FrameInfo_BTGen.DoClick = function()
local Admin_Sys_Bool = false
for _, numbplayer in pairs(ents.FindByClass( "player" )) do
     if IsValid(numbplayer) and numbplayer:IsPlayer() and Admin_System_Global.General_Permission[numbplayer:GetUserGroup()] then
          Admin_Sys_Bool = true
     end
end
if not Admin_Sys_Bool then
     chat.AddText(Color(255,0,0), Admin_System_Global.Ticket_NoText)
     Admin_Sys_Check_Frame(Admin_Sys_FrameInfo, true)
     return
end
if Admin_System_Global.Gen_Ticket[i].WebLink == "" then
     if (Admin_System_Global.Gen_Ticket[i].Complementary) then
          Admin_Sys_Frame_Comp(Admin_System_Global.Gen_Ticket[i].NameButton)
          Admin_Sys_Check_Frame(Admin_Sys_FrameInfo, false)
     else
          net.Start("Admin_Sys:Gen_Tick")
          net.WriteString(Admin_System_Global.Gen_Ticket[i].NameButton)
          net.WriteString("")
          net.SendToServer()
          Admin_Sys_TicketSending = Admin_Sys_TicketSending + 1
          Admin_Sys_Check_Frame(Admin_Sys_FrameInfo, true)
     end
else
     gui.OpenURL(Admin_System_Global.Gen_Ticket[i].WebLink)
     Admin_Sys_Check_Frame(Admin_Sys_FrameInfo, true)
end
end
end
end)