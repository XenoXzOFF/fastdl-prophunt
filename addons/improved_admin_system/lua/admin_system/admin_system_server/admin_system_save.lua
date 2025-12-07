----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

if (Admin_System_Global.Admin_System_Ressource == 1) then
     resource.AddWorkshop("2250503116")
elseif (Admin_System_Global.Admin_System_Ressource == 2) then
     resource.AddFile( "resource/fonts/Rajdhani-Bold.ttf" )
     resource.AddFile( "resource/fonts/Rajdhani-Medium.ttf" )
end

if not file.Exists(Admin_System_Global.ZoneAdmin_Save, "DATA") then
     file.CreateDir(Admin_System_Global.ZoneAdmin_Save)
end
if not file.Exists(Admin_System_Global.ZoneAdmin_Save.. "pos.txt", "DATA") then
     file.Write(Admin_System_Global.ZoneAdmin_Save.. "pos.txt", "[]")
end
if not file.Exists(Admin_System_Global.Stats_Save, "DATA") then
     file.CreateDir(Admin_System_Global.Stats_Save)
end
if not file.Exists(Admin_System_Global.Stats_Save.. "rating.json", "DATA") then
     file.Write(Admin_System_Global.Stats_Save.. "rating.json", "[]")
end 

if (Admin_System_Global.Admin_System_Save == "data") then
     if file.Exists(Admin_System_Global.Stats_Save .. "sv.txt", "DATA") then
          file.Rename(Admin_System_Global.Stats_Save .. "sv.txt", Admin_System_Global.Stats_Save .."sv.json")
     else
          if not file.Exists(Admin_System_Global.Stats_Save .. "sv.json", "DATA") then
               file.Write(Admin_System_Global.Stats_Save .. "sv.json", "[]")
          end
     end
elseif (Admin_System_Global.Admin_System_Save == "sqlite") then
     if (sql.TableExists("Improved_Ticket_System")) then
          Msg("Improved Ticket System SQlite a été chargé avec succès !")
          local Admin_Sys_SQlite_TickQuery = sql.QueryValue("SELECT Central_Grp from Improved_Ticket_System")
          if not Admin_Sys_SQlite_TickQuery then
               sql.Query("ALTER TABLE Improved_Ticket_System ADD Central_Grp varchar(20)")
          end
     else
          sql.Query("CREATE TABLE Improved_Ticket_System (Central_SteamID varchar(20), Central_Admin varchar(20), Central_Horodatage INTEGER, Central_NumbTicket INTEGER, Central_Grp varchar(20))")
     end
end