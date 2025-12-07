----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3 
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System 
Admin_System_Global = Admin_System_Global or {}   
Admin_System_Global.Gen_Ticket = Admin_System_Global.Gen_Ticket or {}
Admin_System_Global.Version = "2.7.9(8)" 

-- // 
Admin_System_Global.Mode_Lang = "fr" --- // Choose a default language - Indicate: "fr" or "en".
Admin_System_Global.Stats_Save =  "improvedticketsystem/sauvegarde/" --- // Sauvegarde des logs/évaluations.
Admin_System_Global.ZoneAdmin_Save = "improvedticketsystem/position/" --- // Sauvegarde des positions Zone Admin.
-- //

local Admin_Sys_LMeta = FindMetaTable("Player")
local LanguageSys = file.Find("language/*", "LUA")
local ConfigurationSys = file.Find("configuration/*", "LUA")
local ClientSys = file.Find("admin_system/admin_system_client/*", "LUA")
local HookSys = file.Find("admin_system/admin_system_client/admin_system_utils/*", "LUA")
local VguiSys = file.Find("admin_system/admin_system_client/admin_system_vgui/*", "LUA")

function Admin_Sys_LMeta:AdminStatusCheck()
          return (IsValid(self) and self:GetNWBool("Admin_Sys_Status")) or false
end

function Admin_System_Global:AddTicketBut(AddSys_Pos, AddSys_Name, AddSys_WebLink, AddSys_Comp, AddSys_Rating)
     if (AddSys_Pos <= 1) then Admin_System_Global.Gen_Ticket = {} end
     table.insert(Admin_System_Global.Gen_Ticket, AddSys_Pos, {NameButton = AddSys_Name, WebLink = AddSys_WebLink, Complementary = AddSys_Comp, Rating = AddSys_Rating})
end
 
--- Loader
if SERVER then
     local ServerSys, Admin_Sys_Math = file.Find("admin_system/admin_system_server/*", "LUA"), 0

     local function Admin_SysMathRound(Admin_Sys_Cnt, Admin_Sys_Tbl)
          local Admin_Sys_Math = math.Round((Admin_Sys_Cnt/#Admin_Sys_Tbl) * 100)
          return Admin_Sys_Math
     end
     MsgC( Color( 0, 250, 0 ), "\n --SERVER-- \n\nImproved Admin System - loading files in progress on server.. Please Wait\n" )

     for count, file in pairs (ConfigurationSys) do
          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > Command :" )
          end
          if (file == "admin_system_config_command.lua") then

               include("configuration/"..file)
               AddCSLuaFile("configuration/"..file)
               MsgC( Color( 0, 250, 0 ), "\nLoad file configuration/" ..file.. " - 1/" ..#ConfigurationSys.." - Loading : " ..Admin_SysMathRound(count, ConfigurationSys).. "%" )

               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System Command - 1 file(s) loaded correctly \n" )
               break
          end
     end

     for count, file in pairs (LanguageSys) do
          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > language :" )
          end
          if (Admin_System_Global.Mode_Lang ..".lua" == file) then

               include("language/"..file)
               AddCSLuaFile("language/"..file)
               MsgC( Color( 0, 250, 0 ), "\nLoad file language/" ..file.. " - Loading : " ..Admin_SysMathRound(count, LanguageSys).. "%" )

               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System language - 1 file(s) loaded correctly \n" )
               break
          end
     end

     for count, file in pairs (ConfigurationSys) do
          if (file == "admin_system_config_command.lua") then
               continue
          end

          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > configuration :" )
          end

          include("configuration/"..file)
          AddCSLuaFile("configuration/"..file)
          MsgC( Color( 0, 250, 0 ), "\nLoad file configuration/" ..file.. " - " ..count.."/" ..#ConfigurationSys.." - Loading : " ..Admin_SysMathRound(count, ConfigurationSys).. "%" )

          if (count == #ConfigurationSys) then
               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System configuration - " ..#ConfigurationSys.. " file(s) loaded correctly \n" )
          end
     end

     for count, file in pairs (ServerSys) do

          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > server :" )
          end

          include("admin_system/admin_system_server/"..file)
          MsgC( Color( 0, 250, 0 ), "\nLoading file admin_system_server/" ..file.. " - " ..count.."/" ..#ServerSys.." - Loading : " ..Admin_SysMathRound(count, ServerSys).. "%" )

          if (count == #ServerSys) then
               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System server - " ..#ServerSys.. " file(s) loaded correctly \n" )
          end
     end

     for count, file in pairs (ClientSys) do

          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > client :" )
          end

          AddCSLuaFile("admin_system/admin_system_client/"..file)
          MsgC( Color( 0, 250, 0 ), "\nLoading file admin_system_client/" ..file.. " - " ..count.."/" ..#ClientSys.." - Loading : " ..Admin_SysMathRound(count, ClientSys).. "%" )

          if (count == #ClientSys) then
               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System client - " ..#ClientSys.. " file(s) loaded correctly \n" )
          end
     end

     for count, file in pairs (HookSys) do

          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > hook :" )
          end

          AddCSLuaFile("admin_system/admin_system_client/admin_system_utils/"..file)
          MsgC( Color( 0, 250, 0 ), "\nLoading file admin_system_utils/" ..file.. " - " ..count.."/" ..#HookSys.." - Loading : " ..Admin_SysMathRound(count, HookSys).. "%" )

          if (count == #HookSys) then
               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System hook - " ..#HookSys.. " file(s) loaded correctly \n" )
          end
     end

     for count, file in pairs (VguiSys) do

          if (count == 1) then
               MsgC( Color( 0, 250, 0 ), "\n Loading file > vgui :" )
          end

          AddCSLuaFile("admin_system/admin_system_client/admin_system_vgui/"..file)
          MsgC( Color( 0, 250, 0 ), "\nLoading file admin_system_vgui/" ..file.. " - " ..count.."/" ..#VguiSys.." - Loading : " ..Admin_SysMathRound(count, VguiSys).. "%" )

          if (count == #VguiSys) then
               MsgC( Color( 0, 250, 0 ), "\n Improved Admin System vgui - " ..#VguiSys.. " file(s) loaded correctly \n" )
          end
     end

     timer.Simple(5,function()
     Admin_System_Global.Admin_System_Save = string.lower(Admin_System_Global.Admin_System_Save)
     end)

     MsgC( Color( 0, 250, 0 ), "\nImproved Admin System v" ..Admin_System_Global.Version.. " by Inj3 - 100% loading all files on server\nGood administration !\n\n" )
end

if CLIENT then
     MsgC( Color( 0, 250, 0 ), "\n --CLIENT-- \n" )

     local Admin_Sys_Cmd_GeneralTbl_ = {}
     Admin_Sys_Table_Notif = Admin_Sys_Table_Notif or {}
     Admin_System_Global.SysCloakStatus = Admin_System_Global.SysCloakStatus or false
     Admin_System_Global.SysGodModeStatus = Admin_System_Global.SysGodModeStatus or false
     Admin_System_Global.SysStreamerMod = Admin_System_Global.SysStreamerMod or false

     function Admin_System_Global:AddCmdBut(AddSys_Pos, AddSys_Name, AddSys_Commands, AddSys_Icon, AddSys_Ret)
          if not AddSys_Ret then
               if AddSys_Pos <= 1 then
                    Admin_Sys_Cmd_GeneralTbl_ = {}
               end
               table.insert(Admin_Sys_Cmd_GeneralTbl_, AddSys_Pos, {Name = AddSys_Name, Commands = AddSys_Commands, Icon = AddSys_Icon})
          else
               return Admin_Sys_Cmd_GeneralTbl_
          end
     end

     for count, file in pairs (ConfigurationSys) do
          if (file == "admin_system_config_command.lua") then
               include("configuration/"..file)
               break
          end
     end

     for count, file in pairs (LanguageSys) do
          if (Admin_System_Global.Mode_Lang ..".lua" == file) then
               include("language/"..file)
               break
          end
     end

     for count, file in pairs (ConfigurationSys) do
          if (file == "admin_system_config_command.lua") then continue end
          include("configuration/"..file)
     end

     for count, file in pairs (ClientSys) do
          include("admin_system/admin_system_client/"..file)
     end

     for count, file in pairs (HookSys) do
          include("admin_system/admin_system_client/admin_system_utils/"..file)
     end

     for count, file in pairs (VguiSys) do
          include("admin_system/admin_system_client/admin_system_vgui/"..file)
     end

     MsgC( Color( 0, 250, 0 ), "\nImproved Admin System v" ..Admin_System_Global.Version.. " by Inj3 - 100% loading all files on client\n" )
end