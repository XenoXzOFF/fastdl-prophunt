local Admin_Syst_Chat, Admin_Sys_Tick_RichText, Admin_SysSvTbl, Admin_Sys_Tick_ChatGbl = nil, nil, {}, nil
  
local function Admin_SysHistory(Admin_Sys_Tick_RichText, Admin_Sys_Tick_RichBool)
     if IsValid(Admin_Sys_Tick_RichText) and istable(Admin_SysSvTbl) and #Admin_SysSvTbl >= 1 then
          Admin_Sys_Tick_RichText:SetText("")
          Admin_Sys_Tick_RichText:InsertColorChange( 255, 255, 255, 255 )
          Admin_Sys_Tick_RichText:AppendText(Admin_System_Global.lang["chat_welc"])
          if not Admin_Sys_Tick_RichBool then
               Admin_Sys_Tick_RichText:InsertColorChange( 255, 177, 66, 255 )
          end 
          for i = 1, #Admin_SysSvTbl do
               Admin_Sys_Tick_RichText:AppendText( (not Admin_Sys_Tick_RichBool and Admin_System_Global.lang["chat_bck"] or "\n ") ..Admin_SysSvTbl[i].nom.. "["..Admin_SysSvTbl[i].grp.. "] - " ..((isnumber(tonumber(Admin_SysSvTbl[i].heure)) and Admin_System_Global:TradTime( string.NiceTime( os.time() - Admin_SysSvTbl[i].heure ))) or "").. " :\n" ..Admin_SysSvTbl[i].mssg)
          end

          Admin_Sys_Tick_RichText:InsertColorChange( 255, 255, 255, 255 )
          timer.Simple(0.1,function()
          if IsValid(Admin_Sys_Tick_RichText) then
               Admin_Sys_Tick_RichText:GotoTextEnd()
          end
          end)
     end 
end

local function Admin_SysLoadHistory(Admin_Sys_Tick_RichText, Admin_Sys_StringText)
     if IsValid(Admin_Sys_Tick_RichText) then
          table.insert(Admin_SysSvTbl, {nom = "Commande Chat : " ..LocalPlayer():Nick(), heure = os.time(), grp = LocalPlayer():GetUserGroup(), mssg = Admin_Sys_StringText})

          Admin_Sys_Tick_RichText:AppendText("\nCommande Chat : " ..LocalPlayer():Nick().. "["..LocalPlayer():GetUserGroup().. "] :\n" ..Admin_Sys_StringText)
          Admin_Sys_Tick_RichText:GotoTextEnd()
     end
end
 
local function Admin_SysReload(Admin_Sys_Tick_RichText, Admin_Sys_StringText, Admin_Syst_ChatDtext)
     if IsValid(Admin_Sys_Tick_RichText) then
          if not Admin_Sys_StringText or string.len(Admin_Sys_StringText) <= 1 then
               LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["chat_toosh"])
               return
          end
          Admin_Syst_ChatDtext:SetText(Admin_Sys_Tick_ChatGbl.. " : " ..Admin_System_Global.lang["chat_dentry"])
		  if Admin_Sys_Tick_ChatGbl ~= Admin_System_Global.lang["chat_title"] and string.Trim( Admin_Sys_StringText ) != "" then
               LocalPlayer():ConCommand( "say " ..Admin_Sys_StringText )
			   Admin_SysLoadHistory(Admin_Sys_Tick_RichText, Admin_Sys_StringText)
               return
          end
          net.Start("Admin_Sys:ChatAdmin")
          net.WriteString(Admin_Sys_StringText)
          net.SendToServer()
     end
end

local function Admin_Syst_ChatFunc() 
local Admin_Sys_Tbl, Admin_Sys_Int = {}, net.ReadUInt(8)
for i = 1, Admin_Sys_Int do
Admin_Sys_Tbl[i] = net.ReadString()
end
local Admin_Sys_Ent = net.ReadEntity()

if not IsValid(Admin_Syst_Chat) and Admin_Sys_Tbl[1] then
          table.insert(Admin_SysSvTbl, {nom = Admin_Sys_Tbl[1], heure = Admin_Sys_Tbl[3], grp = Admin_Sys_Tbl[2], mssg = Admin_Sys_Tbl[4]})
		  return
end
if IsValid(Admin_Syst_Chat) then
     if IsValid(Admin_Sys_Tick_RichText) then
	 Admin_SysHistory(Admin_Sys_Tick_RichText, true)
	  
          if Admin_Sys_Tbl[1] then
               table.insert(Admin_SysSvTbl, {nom = Admin_Sys_Tbl[1], heure = Admin_Sys_Tbl[3], grp = Admin_Sys_Tbl[2], mssg = Admin_Sys_Tbl[4]})
          end		  
		  if Admin_Sys_Tbl[4] then 
          Admin_Sys_Tick_RichText:AppendText("\n" ..Admin_Sys_Tbl[1].. "["..Admin_Sys_Tbl[2].. "] :\n" ..Admin_Sys_Tbl[4])
		  end
		  Admin_Sys_Tick_RichText:GotoTextEnd()
     end
     return
end
Admin_Sys_Tick_ChatGbl = Admin_System_Global.lang["chat_title"]

Admin_Syst_Chat = vgui.Create("DFrame")
Admin_Sys_Tick_RichText = vgui.Create("RichText",Admin_Syst_Chat)
local Admin_Syst_ChatDtext, Admin_Sys_StringText = vgui.Create( "DTextEntry", Admin_Syst_Chat )
local Admin_Syst_ChatDComb = vgui.Create( "DImageButton", Admin_Syst_Chat )
local Admin_Syst_ChatDComb_a = vgui.Create( "DImageButton", Admin_Syst_Chat )
local Admin_Syst_ChatFrm = vgui.Create("DImageButton", Admin_Syst_Chat)
local Admin_Syst_ChatBT, Admin_Syst_ChatBTb = vgui.Create("DImageButton", Admin_Syst_Chat )
local Admin_Syst_ChatV, Admin_Sys_Lerp, Admin_Sys_Lerp_An = vgui.Create("DButton", Admin_Syst_Chat), 0, 0.05

local Admin_Sys_Count, Admin_Sys_CurTime = 0, 0

Admin_Syst_Chat:SetSize(Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(190, "h"))
Admin_Syst_Chat:SetTitle("") 
Admin_Syst_Chat:ShowCloseButton(false)
Admin_Syst_Chat:Center()
Admin_Syst_Chat:MakePopup()
Admin_Syst_Chat:SetSizable( true )
Admin_Syst_Chat:SetMinWidth( 200 )
Admin_Syst_Chat:SetMinHeight( 100 )
Admin_Syst_Chat.Paint = function(self, w, h)
Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 150 ), 8)
draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94) )
if CurTime() > Admin_Sys_CurTime then
   Admin_Sys_Count = 0
   local Admin_SysFindClass = ents.FindByClass("player")
   for _, v in ipairs(Admin_SysFindClass) do
      if not Admin_System_Global.General_Permission[v:GetUserGroup()] then continue end
      Admin_Sys_Count = Admin_Sys_Count + 1
   end
   Admin_Sys_CurTime = CurTime() + 5
end

draw.DrawText(Admin_Sys_Tick_ChatGbl.. " - En ligne : " ..Admin_Sys_Count,"Admin_Sys_Font_T1",w / 2, Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
end
 
Admin_Sys_Tick_RichText:SetPos(Admin_System_Global:Size_Auto(5, "w"),Admin_System_Global:Size_Auto(30, "h"))
Admin_Sys_Tick_RichText:SetSize(0,0)
Admin_Sys_Tick_RichText:InsertColorChange( 255, 255, 255, 255 )
Admin_Sys_Tick_RichText:SetVerticalScrollbarEnabled(true)
Admin_Sys_Tick_RichText.Think = function()
local x, y = Admin_Syst_Chat:GetSize()
Admin_Sys_Tick_RichText:SetSize(x -10, y - 65)
end 
Admin_Sys_Tick_RichText:GetChildren()[1].Paint = function( self, w, h )
  draw.RoundedBox(6, 0, 0, w-Admin_System_Global:Size_Auto(1, "w"), h, Admin_System_Global.TicketScrollRichText)
end 
Admin_Sys_Tick_RichText:GetChildren()[2] .Paint = function( self, w, h )
  draw.RoundedBox(6, 0, 0, w-Admin_System_Global:Size_Auto(1, "w"), h, Color(0,0,0,50) )
end
function Admin_Sys_Tick_RichText:PerformLayout()
  self:SetFontInternal( "Admin_Sys_Font_T3" )
end 
Admin_Sys_Tick_RichText:AppendText(Admin_System_Global.lang["chat_welc"])

Admin_Syst_ChatDtext:SetSize(0, 0)
Admin_Syst_ChatDtext:SetPos(0, 0)
Admin_Syst_ChatDtext:SetText(Admin_Sys_Tick_ChatGbl.. " : " ..Admin_System_Global.lang["chat_dentry"])
Admin_Syst_ChatDtext:SetFont("Admin_Sys_Font_T2")
Admin_Syst_ChatDtext.MaxCaractere = 150  
Admin_Syst_ChatDtext.Think = function()
local x, y = Admin_Syst_Chat:GetSize()
Admin_Syst_ChatDtext:SetPos(Admin_System_Global:Size_Auto(10, "w"), y - 31)
Admin_Syst_ChatDtext:SetSize(x - 120, Admin_System_Global:Size_Auto(25, "h"))
end 
Admin_Syst_ChatDtext.OnGetFocus = function()
    if Admin_Syst_ChatDtext:GetText() == Admin_Sys_Tick_ChatGbl.. " : " ..Admin_System_Global.lang["chat_dentry"] then
        Admin_Syst_ChatDtext:SetTextColor(Color(0, 0, 0, 255))
        Admin_Syst_ChatDtext:SetText("")
    end
end  
Admin_Syst_ChatDtext.OnTextChanged = function(self)
    Admin_Sys_StringText = self:GetValue()
    local Admin_Sys_Number = string.len(Admin_Sys_StringText)	
    if Admin_Sys_Number > self.MaxCaractere then
        self:SetText(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
        self:SetValue(self.Admin_Sys_ODTextVal or Admin_System_Global.lang["complaint"])
    else
        self.Admin_Sys_ODTextVal = Admin_Sys_StringText
    end
end
Admin_Syst_ChatDtext.OnEnter = function()
Admin_SysReload(Admin_Sys_Tick_RichText, Admin_Sys_StringText, Admin_Syst_ChatDtext)
end

Admin_Syst_ChatDComb:SetPos(0, 0)
Admin_Syst_ChatDComb:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"))
Admin_Syst_ChatDComb:SetImage("icon16/comments.png")
Admin_Syst_ChatDComb.Think = function()
local x, y = Admin_Syst_Chat:GetSize()
Admin_Syst_ChatDComb:SetPos(x - 43, Admin_System_Global:Size_Auto(5, "h"))
end
function Admin_Syst_ChatDComb:Paint(w, h) end
Admin_Syst_ChatDComb.DoClick = function()
local Admin_SysPos_Derma = DermaMenu()

local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["chat_title"], function()
Admin_Sys_Tick_ChatGbl = Admin_System_Global.lang["chat_title"]
Admin_Syst_ChatDtext:SetText(Admin_Sys_Tick_ChatGbl.. " : " ..Admin_System_Global.lang["chat_dentry"])
end)
Admin_SysPos_Option:SetIcon("icon16/user_gray.png")

local Admin_SysPos_Option_ = Admin_SysPos_Derma:AddOption("Commande Chat (!admin ect..)", function()
Admin_Sys_Tick_ChatGbl = "Commande Chat (!admin ect..)"
Admin_Syst_ChatDtext:SetText(Admin_Sys_Tick_ChatGbl.. " : " ..Admin_System_Global.lang["chat_dentry"])
end)
Admin_SysPos_Option_:SetIcon("icon16/application_xp_terminal.png")

Admin_SysPos_Derma:Open()
end
  
Admin_Syst_ChatDComb_a:SetPos(30, 5)
Admin_Syst_ChatDComb_a:SetSize(Admin_System_Global:Size_Auto(16, "w"), Admin_System_Global:Size_Auto(16, "h"))
Admin_Syst_ChatDComb_a:SetImage("icon16/cog.png")
function Admin_Syst_ChatDComb_a:Paint(w, h) end
Admin_Syst_ChatDComb_a.DoClick = function()
local Admin_SysPos_Derma = DermaMenu()

local Admin_SysPos_Option = Admin_SysPos_Derma:AddOption("Clear Chat", function()
Admin_SysSvTbl = {}
Admin_Sys_Tick_RichText:SetText("")
Admin_Sys_Tick_RichText:InsertColorChange( 255, 255, 255, 255 )
end)
Admin_SysPos_Option:SetIcon("icon16/cog.png")

Admin_SysPos_Derma:Open()
end

Admin_Syst_ChatFrm:SetPos(0, 0)
Admin_Syst_ChatFrm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(19, "h"))
Admin_Syst_ChatFrm:SetImage("icon16/cross.png")
Admin_Syst_ChatFrm.Think = function()
local x, y = Admin_Syst_Chat:GetSize()
Admin_Syst_ChatFrm:SetPos(x - 20, Admin_System_Global:Size_Auto(4, "h"))
end
function Admin_Syst_ChatFrm:Paint(w, h) end
Admin_Syst_ChatFrm.DoClick = function()
     Admin_Syst_Chat:Remove()
end

Admin_Syst_ChatV:SetPos( 0, 0)
Admin_Syst_ChatV:SetSize( Admin_System_Global:Size_Auto(95, "w"), Admin_System_Global:Size_Auto(22, "h") )
Admin_Syst_ChatV:SetText( "" ) 
Admin_Syst_ChatV:SetIcon("icon16/tick.png")
Admin_Syst_ChatV.Think = function()
local x, y = Admin_Syst_Chat:GetSize()
Admin_Syst_ChatV:SetPos(x - 100, y - 30)
end
function Admin_Syst_ChatV:Paint(w, h)
     draw.RoundedBox( 3, 0, 0, w, h, Color(52,73,94) )
     if self:IsHovered() then
          Admin_Sys_Lerp = Lerp(Admin_Sys_Lerp_An, Admin_Sys_Lerp, w - 3)
     else
          Admin_Sys_Lerp = 0
     end
     draw.RoundedBox( 6, 2, 0, Admin_Sys_Lerp, 1, Color(192, 57, 43) )
     draw.DrawText(Admin_System_Global.lang["chat_send"], "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(5, "w"), Admin_System_Global:Size_Auto(2, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Syst_ChatV.DoClick = function()
Admin_SysReload(Admin_Sys_Tick_RichText, Admin_Sys_StringText, Admin_Syst_ChatDtext)
end

Admin_Syst_ChatBT:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(5, "h"))
Admin_Syst_ChatBT:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_Syst_ChatBT:SetImage( "icon16/layers.png" )
Admin_Syst_ChatBT.DoClick = function()
Admin_Syst_Chat:SetAlpha(50)
Admin_Syst_ChatBT:SetImage( "icon16/monitor.png" )
Admin_Syst_Chat:SetMouseInputEnabled(false)
Admin_Syst_Chat:SetKeyboardInputEnabled(false)
gui.EnableScreenClicker(false)

timer.Simple(1,function()
if not IsValid(Admin_Syst_Chat) then return end
local x, y = Admin_Syst_Chat:GetPos()
Admin_Syst_ChatBTb = vgui.Create( "DFrame" )
Admin_Syst_ChatBTb:SetTitle( "" )
Admin_Syst_ChatBTb:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "w"))
Admin_Syst_ChatBTb:SetMouseInputEnabled(true)
Admin_Syst_ChatBTb:ShowCloseButton(false)
Admin_Syst_ChatBTb:SetPos(x, y)
Admin_Syst_ChatBTb.Think = function()
local x, y = Admin_Syst_Chat:GetSize()
Admin_Syst_ChatBTb:SetSize(x, y)
if Admin_Syst_ChatBTb:IsHovered() then

     if IsValid(Admin_Syst_Chat) then
          Admin_Syst_Chat:SetAlpha(255)
          Admin_Syst_Chat:SetMouseInputEnabled(true)
          Admin_Syst_Chat:SetKeyboardInputEnabled(true)
          gui.EnableScreenClicker(true)
          Admin_Syst_ChatBT:SetImage( "icon16/layers.png" )
     end
     Admin_Syst_ChatBTb:Remove()
end
end
Admin_Syst_ChatBTb.Paint = function( self, w, h ) end
end)
end

Admin_SysHistory(Admin_Sys_Tick_RichText)
end  
net.Receive("Admin_Sys:ChatAdmin", Admin_Syst_ChatFunc)