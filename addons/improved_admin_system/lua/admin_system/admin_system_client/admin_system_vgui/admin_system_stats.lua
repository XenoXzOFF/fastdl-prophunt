----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/
local Admin_Sys_Frame_Stats, Admin_Sys_FrameRatingSec, Admin_SysCT, Admin_SysCR = nil, nil, 0, 0
local Admin_Sys_g, Admin_Sys_gn, Admin_SysJsonStatsTbl, Admin_SysJsonRateTbl = Admin_Sys_g or {}, 0.7, nil, nil
local Admin_Sys_LoadDataFrame, Admin_SysV, Admin_SysN, Admin_SysColorA = nil, 0, 0, Color( 255, 0, 0, 150 )
local Admin_SysLoadRate, Admin_SysLoadStat, Admin_SysfdStat, Admin_SysSafeRmvStuck, Admin_SysDataRdiDel = "...", "...", "STEAM", "ImprovedSys_SafeRemoveifStuck", "ImprovedSys_SysTimerDataRdi"

local function Admin_Sys_UpdateDlist(Admin_Sys_F)
     for a, v in pairs(Admin_Sys_F:GetLines()) do
          for b, l in pairs(v.Columns) do
               l:SetTextColor(Color(236, 240, 241))
               l:SetFont("Admin_Sys_Font_T1")
          end
     end
end

local function Admin_SysAddList(Admin_Sys_T, Admin_Sys_Td, Admin_Sys_P)
     for d, v in pairs(Admin_Sys_T) do
          Admin_Sys_P:AddLine(v.Central_Admin, Admin_System_Global.lang["stats_indiq_i"].. "" ..Admin_System_Global:TradTime(string.NiceTime(os.time() - v.Central_Horodatage)), v.Central_NumbTicket, d and Admin_Sys_Td[d] and string.find( tostring(d), Admin_SysfdStat ) and Admin_Sys_Td[d].Admin_Sys_N.. "/5" or Admin_Sys_Td and Admin_Sys_Td[v.Central_SteamID] and Admin_Sys_Td[v.Central_SteamID].Admin_Sys_N .."/5" or "-/5", v.Central_G or v.Central_Grp or "Inconnu", not isnumber(d) and d or v.Central_SteamID or "Inconnu" )
     end
     local Admin_SysMaxVal, Admin_SysLines = 6, 0
     for nb, _ in pairs(Admin_Sys_P:GetLines()) do
          Admin_SysLines = nb
     end
     for i = 1, Admin_SysMaxVal + 1 do
          if i > Admin_SysLines and i <= Admin_SysMaxVal + 1 then
               Admin_Sys_P:AddLine("⁃","⁃","⁃","⁃","⁃","⁃")
          end
     end
end

local function Admin_Sys_LerpAnim(Admin_System_Val, Admin_System_MaxVal, Admin_System_Nom)
     local Admin_System_Val = Admin_System_Val or 100
     local Admin_System_MaxVal = Admin_System_MaxVal or 100
     Admin_Sys_g[Admin_System_Nom] = Admin_Sys_g[Admin_System_Nom] or {
          oldhp = Admin_System_Val,
          newhp = Admin_System_Val,
          start = 0
     }

     local Admin_Sys_SmHp = Lerp( ( SysTime() - Admin_Sys_g[Admin_System_Nom].start ) / Admin_Sys_gn, Admin_Sys_g[Admin_System_Nom].oldhp, Admin_Sys_g[Admin_System_Nom].newhp )
     if Admin_Sys_g[Admin_System_Nom].newhp != Admin_System_Val then
          if ( Admin_Sys_SmHp != Admin_System_Val ) then
               Admin_Sys_g[Admin_System_Nom].newhp = Admin_Sys_SmHp
          end
          Admin_Sys_g[Admin_System_Nom].oldhp = Admin_Sys_g[Admin_System_Nom].newhp
          Admin_Sys_g[Admin_System_Nom].start = SysTime()
          Admin_Sys_g[Admin_System_Nom].newhp = Admin_System_Val
     end

     return math.Round(math.max( 0, Admin_Sys_SmHp ) / Admin_System_MaxVal * 100)
end

local function Admin_Sys_UpdateValue()
     if timer.Exists(Admin_SysDataRdiDel) then
          timer.Remove(Admin_SysDataRdiDel)
     end
     if timer.Exists(Admin_SysSafeRmvStuck) then
          timer.Remove(Admin_SysSafeRmvStuck)
     end
     Admin_SysLoadPr = 0
     Admin_SysN = 0
     Admin_SysV = 0
     Admin_SysCR = 0
     Admin_SysCT = 0
     Admin_Sys_g = {}
end

local function Admin_Syst_StatsSec_Func(Admin_Syst_RTPrimary, Admin_Syst_ValPly, Admin_Syst_ValTbl, Admin_Syst_ValNg, Admin_Syst_ValST)
if IsValid(Admin_Sys_FrameRatingSec) then return end

Admin_Syst_RTPrimary:Center()
local y, g = Admin_Syst_RTPrimary:GetPos()
local Admin_SysCount = 0
Admin_Syst_RTPrimary:SetPos( y - Admin_System_Global:Size_Auto(170, "w"), g )

Admin_Sys_FrameRatingSec = vgui.Create("DFrame")
local Admin_Sys_Rating_Frm = vgui.Create("DImageButton", Admin_Sys_FrameRatingSec)
local Admin_Sys_FrameInfo_Scroll = vgui.Create("DScrollPanel", Admin_Sys_FrameRatingSec)

Admin_Sys_FrameRatingSec:SetTitle("")
Admin_Sys_FrameRatingSec:ShowCloseButton(false)
Admin_Sys_FrameRatingSec:SetSize(Admin_System_Global:Size_Auto(350, "w"), Admin_System_Global:Size_Auto(250, "h"))
Admin_Sys_FrameRatingSec:SetPos(0, 0)
Admin_Sys_FrameRatingSec:MakePopup()
Admin_Sys_FrameRatingSec.Think = function()
if IsValid(Admin_Syst_RTPrimary) then
     local x, y = Admin_Syst_RTPrimary:GetPos()
     Admin_Sys_FrameRatingSec:SetPos(x + Admin_System_Global:Size_Auto(380, "w"), y + Admin_System_Global:Size_Auto(45, "h"))
end
end
Admin_Sys_FrameRatingSec.Paint = function(self, w, h)
Admin_System_Global:Gui_Blur(self, Admin_System_Global:Size_Auto(1, "w"), Color( 0, 0, 0, 150 ), 8)

draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94) )
draw.DrawText(Admin_System_Global.lang["stats_titlesp"], "Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(5, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
draw.DrawText(Admin_System_Global.lang["stats_adminsp"].. "" ..Admin_Syst_ValPly, "Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(28, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
draw.DrawText(Admin_System_Global.lang["stats_moynsp"].. "" ..Admin_Syst_ValNg.. "" ..Admin_System_Global.lang["stats_moynspav"].. "" ..Admin_SysCount, "Admin_Sys_Font_T1",w / 2,Admin_System_Global:Size_Auto(45, "h"),Color(255, 255, 250),TEXT_ALIGN_CENTER)
if not Admin_Syst_ValTbl then
     draw.DrawText(Admin_System_Global.lang["stats_noratesave"], "Admin_Sys_Font_T4",w / 2,Admin_System_Global:Size_Auto(140, "h"),Color(46, 204, 113),TEXT_ALIGN_CENTER)
end
end

Admin_Sys_Rating_Frm:SetPos(Admin_System_Global:Size_Auto(330, "w"), Admin_System_Global:Size_Auto(4, "h"))
Admin_Sys_Rating_Frm:SetSize(Admin_System_Global:Size_Auto(17, "w"), Admin_System_Global:Size_Auto(17, "h"))
Admin_Sys_Rating_Frm:SetImage("icon16/cross.png")
function Admin_Sys_Rating_Frm:Paint(w, h) end
Admin_Sys_Rating_Frm.DoClick = function()
Admin_Syst_RTPrimary:Center()
Admin_Sys_FrameRatingSec:Remove() 
end 

Admin_Sys_FrameInfo_Scroll:SetSize(Admin_System_Global:Size_Auto(355, "w"), Admin_System_Global:Size_Auto(155, "h"))
Admin_Sys_FrameInfo_Scroll:SetPos(Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(75, "h"))
local Admin_Sys_FrameInfo_Vbar = Admin_Sys_FrameInfo_Scroll:GetVBar()
Admin_Sys_FrameInfo_Vbar:SetSize(0, 0)
function Admin_Sys_FrameInfo_Vbar.btnUp:Paint(w, h)
     draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Up)
end
function Admin_Sys_FrameInfo_Vbar.btnDown:Paint(w, h)
     draw.RoundedBox(0, 0, 0, w, h, Admin_System_Global.CreatetickScrollBar_Down)
end
function Admin_Sys_FrameInfo_Vbar.btnGrip:Paint(w, h)
     draw.RoundedBox(8, 0, 0, w, h, Color(255,255,255))
end

if Admin_Syst_ValTbl then
for k, v in pairs(Admin_Syst_ValTbl) do
if istable(v) then
Admin_SysCount = Admin_SysCount + 1

local Admin_Sys_Service_Dlabel = vgui.Create("DLabel", Admin_Sys_FrameInfo_Scroll)
Admin_Sys_Service_Dlabel:SetPos(1, Admin_System_Global:Size_Auto(45, "h") * Admin_SysCount -Admin_System_Global:Size_Auto(45, "h") )
Admin_Sys_Service_Dlabel:SetSize(Admin_System_Global:Size_Auto(347, "w"), Admin_System_Global:Size_Auto(40, "h"))
Admin_Sys_Service_Dlabel:SetText("")
Admin_Sys_Service_Dlabel.Paint = function(self,w,h)
draw.RoundedBox( 6, 1, 1, w, h, Color(52,73,94, 240) )
draw.DrawText(Admin_System_Global.lang["stats_ratecat"].. "" ..v.Central_R.. "/5" or "-/5", "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(40, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER)
draw.DrawText(Admin_System_Global.lang["stats_rateplycat"].. "" ..v.Central_P, "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(130, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 250), TEXT_ALIGN_CENTER)
draw.DrawText(v.Central_C, "Admin_Sys_Font_T1", Admin_System_Global:Size_Auto(7, "w"), Admin_System_Global:Size_Auto(20, "h"), Color(255,255,255, 250), TEXT_ALIGN_LEFT)
end

if v.Central_R then
     for i = 1, v.Central_R do
          local Admin_Sys_Rating_Stars = vgui.Create("DImageButton", Admin_Sys_FrameInfo_Scroll)
          Admin_Sys_Rating_Stars:SetSize(Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(8, "h"))
          Admin_Sys_Rating_Stars:SetPos(Admin_System_Global:Size_Auto(195, "w") + i * (1 + Admin_System_Global:Size_Auto(13, "w")), Admin_System_Global:Size_Auto(4, "h") + Admin_System_Global:Size_Auto(45, "h") * Admin_SysCount - Admin_System_Global:Size_Auto(45, "h"))
          Admin_Sys_Rating_Stars:SetImage("icon16/star.png")
          function Admin_Sys_Rating_Stars:Paint(w, h) end
      end
end

local Admin_Sys_BT_1 = vgui.Create( "DButton", Admin_Sys_FrameInfo_Scroll)
Admin_Sys_BT_1:SetPos(Admin_System_Global:Size_Auto(321, "w"), Admin_System_Global:Size_Auto(45, "h") * Admin_SysCount - Admin_System_Global:Size_Auto(45, "h") + Admin_System_Global:Size_Auto(13, "h") )
Admin_Sys_BT_1:SetSize(Admin_System_Global:Size_Auto(25, "w"), Admin_System_Global:Size_Auto(16, "h"))
Admin_Sys_BT_1:SetText("")
Admin_Sys_BT_1:SetIcon("icon16/cog.png") 
Admin_Sys_BT_1.Paint = function(self, w, h)
if self:IsHovered() then
draw.RoundedBox( 2, Admin_System_Global:Size_Auto(22, "w"), 0, w, h,  Color(192, 57, 43, 255))
end
end
Admin_Sys_BT_1.DoClick = function()
local Admin_SysPos_Derma = DermaMenu()
local Admin_SysPos_Optiona = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copysteam"], function()
SetClipboardText( k )
LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
end)

Admin_SysPos_Optiona:SetIcon("icon16/cut_red.png")

local Admin_SysPos_Optionb = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copynom"], function()
SetClipboardText( v.Central_P )
LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
end)

Admin_SysPos_Optionb:SetIcon("icon16/cut.png")

if Admin_System_Global.RateAdminDelete[LocalPlayer():GetUserGroup()] then
Admin_SysPos_Derma:AddSpacer()
local Admin_SysPos_Optionc = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["stats_deleterate"], function()
net.Start("Admin_Sys:DeleteRate")
net.WriteString(k)
net.WriteString(Admin_Syst_ValST)
net.SendToServer()
if IsValid(Admin_Sys_Frame_Stats) then
     Admin_Sys_Frame_Stats:Remove()
end
if IsValid(Admin_Sys_FrameRatingSec) then
     Admin_Sys_FrameRatingSec:Remove()
end
end)
Admin_SysPos_Optionc:SetIcon("icon16/exclamation.png")
end

Admin_SysPos_Derma:Open()
end
end
end 
end
end

local function Admin_Sys_Stats_Func(Admin_Sys_Json, Admin_Sys_Jsonv)
if IsValid(Admin_Sys_Frame_Stats) then return end

Admin_Sys_Frame_Stats = vgui.Create( "DFrame" )
local Admin_Sys_Frame_Stats_Dlist = vgui.Create( "DListView", Admin_Sys_Frame_Stats )
local Admin_Sys_Frame_Stats_Dtext = vgui.Create( "DTextEntry", Admin_Sys_Frame_Stats )
local Admin_Sys_Frame_Stats_BT = vgui.Create( "DButton", Admin_Sys_Frame_Stats  )
local Admin_Sys_Frame_Stats_BT_1 = vgui.Create("DImageButton", Admin_Sys_Frame_Stats )
local Admin_Sys_Frame_Stats_BT_2 = vgui.Create("DButton", Admin_Sys_Frame_Stats )
local Admin_SysPos_Frame_BT_Sv1, Admin_SysPos_FrameB = vgui.Create("DImageButton", Admin_Sys_Frame_Stats )

Admin_Sys_Frame_Stats:SetTitle( "" )
Admin_Sys_Frame_Stats:SetSize( Admin_System_Global:Size_Auto(370, "w"), Admin_System_Global:Size_Auto(325, "h") )
Admin_Sys_Frame_Stats:ShowCloseButton(false)
Admin_Sys_Frame_Stats:SetDraggable(true)
Admin_Sys_Frame_Stats:Center()
Admin_Sys_Frame_Stats:MakePopup()
Admin_Sys_Frame_Stats.Paint = function( self, w, h )
Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 8)
draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
draw.DrawText( Admin_System_Global.lang["stats_cons"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(5, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Admin_System_Global.lang["stats_indiq"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(35, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Admin_System_Global.lang["stats_allratevw"], "Admin_Sys_Font_T1", w/2,Admin_System_Global:Size_Auto(140, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end

Admin_Sys_Frame_Stats_Dtext:SetPos(Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(65, "h"))
Admin_Sys_Frame_Stats_Dtext:SetSize(Admin_System_Global:Size_Auto(250, "w"), Admin_System_Global:Size_Auto(25, "h"))
Admin_Sys_Frame_Stats_Dtext:SetFont( "Admin_Sys_Font_T1" )
Admin_Sys_Frame_Stats_Dtext:SetText( Admin_System_Global.lang["stats_indiq_text"] )
Admin_Sys_Frame_Stats_Dtext:SetTextColor(Color(255,0,0,250))
Admin_Sys_Frame_Stats_Dtext.OnGetFocus = function()
if Admin_Sys_Frame_Stats_Dtext:GetText() == Admin_System_Global.lang["stats_indiq_text"] then
     Admin_Sys_Frame_Stats_Dtext:SetTextColor(Color(255,0,0,250))
     Admin_Sys_Frame_Stats_Dtext:SetText("")
end
end

Admin_Sys_Frame_Stats_Dlist:Clear()
Admin_SysAddList(Admin_Sys_Json, Admin_Sys_Jsonv, Admin_Sys_Frame_Stats_Dlist)
local Admin_SysMaxVal, Admin_SysLines = 6, 0
for nb, _ in pairs(Admin_Sys_Frame_Stats_Dlist:GetLines()) do
     Admin_SysLines = nb
end
for i = 1, Admin_SysMaxVal + 1 do
     if i > Admin_SysLines and i <= Admin_SysMaxVal + 1 then
          Admin_Sys_Frame_Stats_Dlist:AddLine("⁃","⁃","⁃","⁃","⁃","⁃")
     end
end


Admin_Sys_Frame_Stats_Dlist:SetPos(Admin_System_Global:Size_Auto(3, "w"), Admin_System_Global:Size_Auto(163, "h"))
Admin_Sys_Frame_Stats_Dlist:SetSize(Admin_System_Global:Size_Auto(363, "w"), Admin_System_Global:Size_Auto(145, "h"))
Admin_Sys_Frame_Stats_Dlist:AddColumn("Admin(s)"):SetWidth(Admin_System_Global:Size_Auto(70, "w"))
Admin_Sys_Frame_Stats_Dlist:AddColumn("Connexion(s)"):SetWidth(Admin_System_Global:Size_Auto(95, "w"))
Admin_Sys_Frame_Stats_Dlist:AddColumn("Ticket(s)")
Admin_Sys_Frame_Stats_Dlist:AddColumn(Admin_System_Global.lang["stats_ratelist"]):SetWidth(Admin_System_Global:Size_Auto(50, "w"))
Admin_Sys_Frame_Stats_Dlist:AddColumn(Admin_System_Global.lang["stats_rategrp"])
Admin_Sys_Frame_Stats_Dlist:AddColumn("SteamID")
Admin_Sys_Frame_Stats_Dlist:SetMultiSelect(false)
function Admin_Sys_Frame_Stats_Dlist:Paint(w, h)
     draw.RoundedBox( 6, 0, 3, w, h, Color( 255, 255, 255, 100 ) )
end
Admin_Sys_Frame_Stats_Dlist.OnRowSelected = function( panel, rowIndex, row )
if row:GetValue(1) =="⁃" then return end
local Admin_SysPos_Derma = DermaMenu()

local Admin_SysPos_Optiona = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copysteam"], function()
SetClipboardText( row:GetValue(6) )
LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
end)
Admin_SysPos_Optiona:SetIcon("icon16/cut_red.png")

local Admin_SysPos_Optionb = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["ticket_copynom"], function()
SetClipboardText( row:GetValue(1) )
LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"] )
end)
Admin_SysPos_Optionb:SetIcon("icon16/cut.png")

Admin_SysPos_Derma:AddSpacer()

local Admin_SysPos_Optionc = Admin_SysPos_Derma:AddOption(Admin_System_Global.lang["stats_viewratecom"], function()
if IsValid(Admin_Sys_FrameRatingSec) then
     Admin_Sys_FrameRatingSec:Remove()
end
Admin_Syst_StatsSec_Func(Admin_Sys_Frame_Stats, row:GetValue(1), Admin_Sys_Jsonv[row:GetValue(6)], row:GetValue(4), row:GetValue(6))
end)
Admin_SysPos_Optionc:SetIcon("icon16/table_sort.png")

Admin_SysPos_Derma:Open()
end

Admin_SysPos_Frame_BT_Sv1:SetPos(Admin_System_Global:Size_Auto(7, "w"),Admin_System_Global:Size_Auto(4, "h"))
Admin_SysPos_Frame_BT_Sv1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
function Admin_SysPos_Frame_BT_Sv1:Paint(w,h) end
Admin_SysPos_Frame_BT_Sv1.DoClick = function()
Admin_Sys_Frame_Stats:SetAlpha(50)
Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/monitor.png" )
Admin_Sys_Frame_Stats:SetMouseInputEnabled(false)
Admin_Sys_Frame_Stats:SetKeyboardInputEnabled(false)
if IsValid(Admin_Sys_FrameRatingSec) then
Admin_Sys_FrameRatingSec:SetAlpha(50)
Admin_Sys_FrameRatingSec:SetMouseInputEnabled(false)
Admin_Sys_FrameRatingSec:SetKeyboardInputEnabled(false)
end
gui.EnableScreenClicker(false)
timer.Simple(1,function()
if not IsValid(Admin_Sys_Frame_Stats) then return end
local x, y = Admin_Sys_Frame_Stats:GetPos()
Admin_SysPos_FrameB = vgui.Create( "DFrame" )
Admin_SysPos_FrameB:SetTitle( "" )
Admin_SysPos_FrameB:SetSize(Admin_System_Global:Size_Auto(280, "w"), Admin_System_Global:Size_Auto(315, "h"))
Admin_SysPos_FrameB:SetMouseInputEnabled(true)
Admin_SysPos_FrameB:ShowCloseButton(false)
Admin_SysPos_FrameB:SetPos(x, y)
Admin_SysPos_FrameB.Think = function()
if Admin_SysPos_FrameB:IsHovered() then
     if IsValid(Admin_Sys_Frame_Stats) then
          Admin_Sys_Frame_Stats:SetAlpha(255)
          Admin_Sys_Frame_Stats:SetMouseInputEnabled(true)
          Admin_Sys_Frame_Stats:SetKeyboardInputEnabled(true)
		  if IsValid(Admin_Sys_FrameRatingSec) then
		  Admin_Sys_FrameRatingSec:SetAlpha(255)
		  Admin_Sys_FrameRatingSec:SetMouseInputEnabled(true)
		  Admin_Sys_FrameRatingSec:SetKeyboardInputEnabled(true)
		  end
          gui.EnableScreenClicker(true)
          Admin_SysPos_Frame_BT_Sv1:SetImage( "icon16/layers.png" )
     end
     Admin_SysPos_FrameB:Remove()
end
end
Admin_SysPos_FrameB.Paint = function( self, w, h ) end
end)
end

local Admin_Sys_Lerp_, Admin_Sys_Lerp_An_, Admin_SysScanSteamID = 0, 0.05, nil
Admin_Sys_Frame_Stats_BT:SetPos( Admin_System_Global:Size_Auto(60, "w"), Admin_System_Global:Size_Auto(105, "h"))
Admin_Sys_Frame_Stats_BT:SetSize( Admin_System_Global:Size_Auto(115, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Sys_Frame_Stats_BT:SetText( "" )
Admin_Sys_Frame_Stats_BT:SetIcon("icon16/zoom_in.png")
Admin_Sys_Frame_Stats_BT.Paint = function( self, w, h )
draw.RoundedBox( 3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Color(52,73,94) )
if self:IsHovered() then
     Admin_Sys_Lerp_ = Lerp(Admin_Sys_Lerp_An_, Admin_Sys_Lerp_, w - 4)
else
     Admin_Sys_Lerp_ = 0
end
draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp_, 1, Color(	41, 128, 185) )
draw.DrawText(Admin_System_Global.lang["stats_scan"], "Admin_Sys_Font_T1", w /2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Sys_Frame_Stats_BT.DoClick = function()
local Admin_Sys_Value = Admin_Sys_Frame_Stats_Dtext:GetValue()

if string.sub( Admin_Sys_Value, 1, 5 ) == Admin_SysfdStat and string.len(Admin_Sys_Value) > 0 and Admin_Sys_Value ~= "" and Admin_Sys_Value ~= " " then
     local Admin_Sys_FindClass_Ply = ents.FindByClass("player")

     if string.len(Admin_Sys_Value) <= 6 then
          LocalPlayer():ChatPrint( "Veuillez indiquer un SteamID !" )
          Admin_Sys_Frame_Stats_Dtext:SetText(Admin_System_Global.lang["stats_indiq_text"])
          return
     end
     if Admin_Sys_Json and (Admin_Sys_Json[Admin_Sys_Value] or Admin_Sys_Json[1]) then
          if (Admin_SysScanSteamID and Admin_SysScanSteamID == Admin_Sys_Value) then
               LocalPlayer():ChatPrint( "Ce SteamID a déjà été scanné !" )
               return
          end
          Admin_Sys_Frame_Stats_Dlist:Clear()

          local Admin_SysSqlite
          for k, v in pairs(Admin_Sys_Json) do
		  if (v.Central_SteamID == Admin_Sys_Value) then
                    Admin_SysSqlite = tonumber(k)
		       end
          end
               Admin_SysSqlite = isnumber(Admin_SysSqlite) and Admin_SysSqlite or Admin_Sys_Value

          Admin_Sys_Frame_Stats_Dlist:AddLine(Admin_Sys_Json[Admin_SysSqlite].Central_Admin, Admin_System_Global.lang["stats_indiq_i"].. "" ..Admin_System_Global:TradTime(string.NiceTime(os.time() - Admin_Sys_Json[Admin_SysSqlite].Central_Horodatage)), Admin_Sys_Json[Admin_SysSqlite].Central_NumbTicket or "aucun", string.find( tostring(d), Admin_SysfdStat ) and Admin_Sys_Jsonv[d] and Admin_Sys_Jsonv[d].Admin_Sys_N.. "/5" or Admin_Sys_Jsonv[Admin_Sys_Value] and Admin_Sys_Jsonv[Admin_Sys_Value].Admin_Sys_N.. "/5" or "-/5", Admin_Sys_Json[Admin_SysSqlite].Central_G or Admin_Sys_Json[Admin_SysSqlite].Central_Grp or "Inconnu", not isnumber(d) and d or Admin_Sys_Value or "Inconnu" )
          LocalPlayer():ChatPrint( Admin_System_Global.lang["stats_scan_text"].. "" ..Admin_Sys_Value.. "" ..Admin_System_Global.lang["stats_scan_trv"] )
          Admin_SysScanSteamID = Admin_Sys_Value
     else
          LocalPlayer():ChatPrint( Admin_System_Global.lang["stats_scannoval"] )
     end

     Admin_Sys_UpdateDlist(Admin_Sys_Frame_Stats_Dlist)
end
end

local Admin_Sys_Lerp_x, Admin_Sys_Lerp_An_x = 0, 0.05
Admin_Sys_Frame_Stats_BT_2:SetPos( Admin_System_Global:Size_Auto(195, "w"), Admin_System_Global:Size_Auto(105, "h"))
Admin_Sys_Frame_Stats_BT_2:SetSize( Admin_System_Global:Size_Auto(115, "w"), Admin_System_Global:Size_Auto(25, "h") )
Admin_Sys_Frame_Stats_BT_2:SetText( "" )
Admin_Sys_Frame_Stats_BT_2:SetIcon("icon16/chart_pie.png")
Admin_Sys_Frame_Stats_BT_2.Paint = function( self, w, h )
draw.RoundedBox( 3, Admin_System_Global:Size_Auto(0, "w"), Admin_System_Global:Size_Auto(0, "h"), w, h, Color(52,73,94) )
if self:IsHovered() then
     Admin_Sys_Lerp_x = Lerp(Admin_Sys_Lerp_An_x, Admin_Sys_Lerp_x, w - Admin_System_Global:Size_Auto(4, "w"))
else
     Admin_Sys_Lerp_x = 0
end
draw.RoundedBox( 6, Admin_System_Global:Size_Auto(2, "w"), Admin_System_Global:Size_Auto(0, "h"), Admin_Sys_Lerp_x, 1, Color(	41, 128, 185) )
draw.DrawText(Admin_System_Global.lang["stats_scan_aff"], "Admin_Sys_Font_T1", w/2 + Admin_System_Global:Size_Auto(8, "w"), Admin_System_Global:Size_Auto(3, "h"), Color(255,255,255, 280), TEXT_ALIGN_CENTER )
end
Admin_Sys_Frame_Stats_BT_2.DoClick = function()
local Admin_Sys_Value = Admin_Sys_Frame_Stats_Dtext:GetValue()

Admin_SysScanSteamID = nil
Admin_Sys_Frame_Stats_Dlist:Clear()
Admin_SysAddList(Admin_Sys_Json, Admin_Sys_Jsonv, Admin_Sys_Frame_Stats_Dlist)
Admin_Sys_UpdateDlist(Admin_Sys_Frame_Stats_Dlist)
end

Admin_Sys_Frame_Stats_BT_1:SetPos(Admin_System_Global:Size_Auto(350, "w"),Admin_System_Global:Size_Auto(5, "h"))
Admin_Sys_Frame_Stats_BT_1:SetSize(Admin_System_Global:Size_Auto(17, "w"),Admin_System_Global:Size_Auto(17, "h"))
Admin_Sys_Frame_Stats_BT_1:SetImage( "icon16/cross.png" )
function Admin_Sys_Frame_Stats_BT_1:Paint(w,h)
end
Admin_Sys_Frame_Stats_BT_1.DoClick = function()
if IsValid(Admin_Sys_FrameRatingSec) then
     Admin_Sys_FrameRatingSec:Remove()
end

Admin_Sys_Frame_Stats:Remove()
end

Admin_Sys_UpdateDlist(Admin_Sys_Frame_Stats_Dlist)
for k, v in pairs(Admin_Sys_Frame_Stats_Dlist.Columns) do
     Admin_Sys_Frame_Stats_Dlist.Columns[k].Header:SetTextColor(Color(236, 240, 241))
     Admin_Sys_Frame_Stats_Dlist.Columns[k].Header:SetFont("Admin_Sys_Font_T1")
     Admin_Sys_Frame_Stats_Dlist.Columns[k].Header.Paint = function(self, w, h) draw.RoundedBox( 6, 0, 0, w, h, Color(52,73,94)) end
end
Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].btnGrip.Paint = function(self, w, h) draw.RoundedBox( 3, 0, 0, w, h, Color(52,73,94)) end
Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].btnUp.Paint = function(self, w, h) draw.RoundedBox( 5, 0, 0, w, h, Color(52,73,94)) end
Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].btnDown.Paint = function(self, w, h) draw.RoundedBox( 5, 0, 0, w, h, Color(52,73,94)) end
Admin_Sys_Frame_Stats_Dlist:GetChildren()[8].Paint = function() end
Admin_Sys_Frame_Stats_Dlist:GetChildren()[8]:SetHideButtons( true )
Admin_Sys_Frame_Stats_Dlist.Paint = function() end
end

local function Admin_Sys_Stats_Primary() 
if (IsValid(Admin_Sys_LoadDataFrame) and Admin_SysV == 2) or IsValid(Admin_Sys_Frame_Stats) then return end

local Admin_Sys_Int = net.ReadUInt(32)
local Admin_Sys_Data = net.ReadData( Admin_Sys_Int )
local Admin_Sys_Decompress = Admin_Sys_Data and util.Decompress(Admin_Sys_Data)
local Admin_Sys_Json = Admin_Sys_Decompress and util.JSONToTable( Admin_Sys_Decompress ) or {}

if istable(Admin_Sys_Json) then
     Admin_SysV = Admin_SysV + 1
     if Admin_SysV == 1 then
          Admin_SysJsonStatsTbl = Admin_Sys_Json
          Admin_SysCT = Admin_SysCT + table.Count(Admin_SysJsonStatsTbl)
     else
          Admin_SysJsonRateTbl = Admin_Sys_Json
          Admin_SysCR = Admin_SysCR + table.Count(Admin_SysJsonRateTbl)
     end
end

if IsValid(Admin_Sys_LoadDataFrame) then return end
Admin_Sys_LoadDataFrame = vgui.Create( "DFrame" )
timer.Create(Admin_SysSafeRmvStuck, 15, 1, function()
if IsValid(Admin_Sys_LoadDataFrame) then
     Admin_Sys_UpdateValue()
     Admin_Sys_LoadDataFrame:Remove()
end
end)
local Admin_Sys_LoadDataFrame_BT = vgui.Create( "DButton", Admin_Sys_LoadDataFrame  )
local Admin_SysLoadPr, Admin_SysCur = 0, CurTime() + 1

Admin_Sys_LoadDataFrame:SetSize( Admin_System_Global:Size_Auto(300, "w"), Admin_System_Global:Size_Auto(125, "h") ) 
Admin_Sys_LoadDataFrame:SetDraggable(true)
Admin_Sys_LoadDataFrame:ShowCloseButton(false)
Admin_Sys_LoadDataFrame:SetTitle( "" )
Admin_Sys_LoadDataFrame:Center()
Admin_Sys_LoadDataFrame:MakePopup()
Admin_Sys_LoadDataFrame.Paint = function( self, w, h )
Admin_System_Global:Gui_Blur(self, 1, Color( 0, 0, 0, 170 ), 2)
draw.RoundedBox( 6, 10, 35, w-20, 80, Color(52,73,94, 120))
draw.RoundedBox( 6, 0, 0, w, Admin_System_Global:Size_Auto(26, "h"), Color(52,73,94))
draw.RoundedBox( 6, 4, 25, Admin_Sys_LerpAnim(Admin_SysN, 34.1, "loadrd"), 1, Admin_SysLoadPr <= 5 and Color(255,0,0, 150) or Color(39, 174, 96))
draw.DrawText( Admin_System_Global.lang["stats_loadwt"].. "" ..Admin_Sys_LerpAnim(Admin_SysN, 100, "load").. "%", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(5, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( "Status : ", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(40, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Admin_SysLoadStat, Admin_SysLoadPr <= 5 and "Admin_Sys_Font_T1" or "Admin_Sys_Font_T4", w/2, Admin_SysLoadPr <= 5 and Admin_System_Global:Size_Auto(90, "h") or Admin_System_Global:Size_Auto(75, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
draw.DrawText( Admin_SysLoadPr <= 5 and Admin_SysLoadRate or "", "Admin_Sys_Font_T1", w/2, Admin_System_Global:Size_Auto(65, "h"), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
end
timer.Create(Admin_SysDataRdiDel, 0, 0, function()
local AdminSysCurThink = CurTime()
if (Admin_SysLoadPr >= 2 and Admin_SysN == 0) then
     Admin_SysN = 50
elseif (Admin_SysLoadPr >= 4 and Admin_SysN == 50) then
     Admin_SysN = 100
end
if (Admin_SysLoadPr <= 0) then
     Admin_SysLoadRate = Admin_System_Global.lang["stats_loadratingtbl"].. ""..Admin_System_Global:Admin_Sys_TicketDot()
     Admin_Sys_LoadDataFrame_BT:SetImage( "icon16/arrow_refresh.png" )
end
if AdminSysCurThink > Admin_SysCur + 0.5 and Admin_SysV >= 1 then
     Admin_SysLoadRate = Admin_System_Global.lang["stats_endratingtbl"]
	 Admin_SysLoadPr = 2
end
if (Admin_SysLoadPr >= 0 and Admin_SysLoadPr <= 2) then
     Admin_SysLoadStat = Admin_System_Global.lang["stats_loadstatstbl"].. ""..Admin_System_Global:Admin_Sys_TicketDot()
end
if (Admin_SysV >= 2) then
     Admin_SysLoadStat = Admin_System_Global.lang["stats_endstatstbl"]
     Admin_Sys_LoadDataFrame_BT:SetImage( "icon16/cross.png" )
	 Admin_SysLoadPr = 4
end
if Admin_SysLoadPr >= 3 and AdminSysCurThink > Admin_SysCur + 2 then
     Admin_SysLoadStat = Admin_System_Global.lang["stats_opfound"].. "" ..Admin_SysCT..  " logs (global stats)"
     Admin_SysLoadRate = Admin_System_Global.lang["stats_opfound"].. "" ..Admin_SysCR.. " logs (evaluations)"
	 Admin_SysLoadPr = 5
end
if Admin_SysLoadPr >= 5 and AdminSysCurThink > Admin_SysCur + 4 then
     Admin_SysLoadStat = Admin_System_Global.lang["stats_oplogs"].. ""..Admin_System_Global:Admin_Sys_TicketDot()
	 Admin_SysLoadPr = 6
end
if Admin_SysLoadPr >= 6 and AdminSysCurThink > Admin_SysCur + 5 then
     Admin_Sys_Stats_Func(Admin_SysJsonStatsTbl or {}, Admin_SysJsonRateTbl or {})
     Admin_Sys_UpdateValue()
     timer.Remove(Admin_SysDataRdiDel)
     Admin_Sys_LoadDataFrame:Remove()
end
end)

Admin_Sys_LoadDataFrame_BT:SetPos(Admin_System_Global:Size_Auto(277, "w"),Admin_System_Global:Size_Auto(5, "h"))
Admin_Sys_LoadDataFrame_BT:SetSize(Admin_System_Global:Size_Auto(19, "w"),Admin_System_Global:Size_Auto(19, "h"))
Admin_Sys_LoadDataFrame_BT:SetImage( "icon16/cross.png" )
function Admin_Sys_LoadDataFrame_BT:Paint(w,h)
end
Admin_Sys_LoadDataFrame_BT.DoClick = function()
if (Admin_SysLoadPr < 4) then return end
Admin_Sys_UpdateValue()

if IsValid(Admin_Sys_LoadDataFrame) then
     Admin_Sys_LoadDataFrame:Remove()
end
end
end
net.Receive("Admin_Sys:Log", Admin_Sys_Stats_Primary)