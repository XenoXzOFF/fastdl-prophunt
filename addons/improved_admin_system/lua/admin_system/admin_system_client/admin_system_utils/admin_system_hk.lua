----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
----------- // SCRIPT BY INJ3 
---- // https://steamcommunity.com/id/Inj3/

local Admin_Sys_Col, Admin_Sys_Col_1, Admin_Sys_Col_2, Admin_Sys_Col_3 = Color(236, 240, 241), Color(76, 209, 55), Color(52, 73, 94), Color(211, 84, 0)
local Admin_Sys_DistancePly, Admin_Sys_DistanceVeh, Admin_Sys_Font, Admin_Sys_Arrow, Admin_Sys_GameEngine = 500000 ,1000000, "Admin_Sys_Font_T1", "➔ ", engine.ActiveGamemode()
local Admin_SysW, Admin_SysH = ScrW(), ScrH()

hook.Add("HUDPaint", "Improved_Admin_SystemInfo_HUD", function()
local Admin_Sys_Ply = LocalPlayer()

if Admin_System_Global.Mode_HUD and Admin_Sys_Ply:AdminStatusCheck() then
     local Admin_Sys_Abs = math.abs(math.sin(CurTime() * 1.5) * 170)
     local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
     local Admin_Sys_FindClass_Veh = ents.FindByClass("prop_vehicle_jeep")

     for _, v in ipairs(Admin_Sys_FindClass_Ply) do
          if not IsValid(v) or v == Admin_Sys_Ply or not v:IsPlayer() then continue end

          local Admin_Sys_ShootPos = v:GetShootPos() + Vector(0,0,-5)
          Admin_Sys_ShootPos.z = Admin_Sys_ShootPos.z + 5
          Admin_Sys_ShootPos = Admin_Sys_ShootPos:ToScreen()
          if not Admin_Sys_ShootPos.visible or (v ~= Admin_Sys_Ply and Admin_System_Global.Mode_Bypass[v:GetUserGroup()]) and Admin_System_Global.Mode_Bypass_Player then continue end
          local Admin_Sys_VehicleB = v:InVehicle()

          draw.DrawText("♦", Admin_Sys_Font, Admin_Sys_ShootPos.x-2 , not Admin_Sys_VehicleB and Admin_Sys_ShootPos.y-30 or Admin_Sys_ShootPos.y, Color(0, 0, Admin_Sys_Abs), TEXT_ALIGN_CENTER)
          if  v:GetPos():DistToSqr(Admin_Sys_Ply:GetPos()) > (Admin_Sys_DistancePly * (not Admin_Sys_VehicleB and 100 or 0.4)) then continue end

          if Admin_Sys_VehicleB then
               local Admin_Sys_C = v:GetVehicle():GetClass() == "prop_vehicle_jeep"
               draw.SimpleTextOutlined(Admin_Sys_C and "Conducteur" or "Passager", Admin_Sys_Font, Admin_Sys_ShootPos.x , Admin_Sys_ShootPos.y-34, Admin_Sys_C and Admin_Sys_Col_3 or Admin_Sys_Col_2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          end
          draw.SimpleTextOutlined(team.GetName(v:Team()), Admin_Sys_Font, Admin_Sys_ShootPos.x , not Admin_Sys_VehicleB and Admin_Sys_ShootPos.y-72 or Admin_Sys_ShootPos.y-22, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          draw.SimpleTextOutlined(v:GetName(), Admin_Sys_Font, Admin_Sys_ShootPos.x , not Admin_Sys_VehicleB and Admin_Sys_ShootPos.y-52 or Admin_Sys_ShootPos.y-10, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)

          if  v:GetPos():DistToSqr(Admin_Sys_Ply:GetPos()) > Admin_Sys_DistancePly or Admin_Sys_VehicleB then continue end

          if (Admin_Sys_GameEngine == "darkrp") then
               draw.SimpleTextOutlined(Admin_System_Global.lang["hudmoney"].. "" ..string.Comma((v:getDarkRPVar("money") or 0)).. "" ..Admin_System_Global.lang["remb_moneysymb"], Admin_Sys_Font, Admin_Sys_ShootPos.x , Admin_Sys_ShootPos.y-165, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          end

          draw.SimpleTextOutlined(Admin_System_Global.lang["hudhealth"].. "" ..((v:Alive() and v:Health()) or 0), Admin_Sys_Font, Admin_Sys_ShootPos.x , Admin_Sys_ShootPos.y-145, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          draw.SimpleTextOutlined(Admin_System_Global.lang["hudarmor"].. "" ..((v:Alive() and v:Armor()) or 0), Admin_Sys_Font, Admin_Sys_ShootPos.x , Admin_Sys_ShootPos.y-130, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          draw.SimpleTextOutlined(Admin_System_Global.lang["hudkilled"].. "" ..string.Replace(v:Frags(), "-", ""), Admin_Sys_Font, Admin_Sys_ShootPos.x , Admin_Sys_ShootPos.y-110, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          draw.SimpleTextOutlined(Admin_System_Global.lang["huddeath"].. "" ..string.Replace(v:Deaths(), "-", ""), Admin_Sys_Font, Admin_Sys_ShootPos.x , Admin_Sys_ShootPos.y-95, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
     end
     for _, v in ipairs(Admin_Sys_FindClass_Veh) do
          if not IsValid(v) or not v:IsVehicle() then continue end

          local Admin_Sys_PosVeh = v:GetPos()
          Admin_Sys_PosVeh.z = Admin_Sys_PosVeh.z + 60
          Admin_Sys_PosVeh = Admin_Sys_PosVeh:ToScreen()
          if not Admin_Sys_PosVeh.visible then continue end

          if IsValid(v:CPPIGetOwner()) and v:CPPIGetOwner():IsPlayer() then
               if (v:CPPIGetOwner() ~= Admin_Sys_Ply and Admin_System_Global.Mode_Bypass[v:CPPIGetOwner():GetUserGroup()]) and Admin_System_Global.Mode_Bypass_Veh then continue end
               draw.SimpleTextOutlined(Admin_System_Global.lang["hud_owner"].. "" ..v:CPPIGetOwner():Nick(), Admin_Sys_Font, Admin_Sys_PosVeh.x-15, Admin_Sys_PosVeh.y-35, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          end
          draw.DrawText("♦", Admin_Sys_Font, Admin_Sys_PosVeh.x-10, Admin_Sys_PosVeh.y-20, Color(Admin_Sys_Abs, 0, 0), TEXT_ALIGN_CENTER)
          if  v:GetPos():DistToSqr(Admin_Sys_Ply:GetPos()) > Admin_Sys_DistanceVeh then continue end
          draw.SimpleTextOutlined(Admin_System_Global.lang["hud_distance"].. ""  ..math.Round(v:GetPos():Distance(Admin_Sys_Ply:GetPos())).. "m", Admin_Sys_Font, Admin_Sys_PosVeh.x-15, Admin_Sys_PosVeh.y-48, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          if Admin_System_Global.Mode_Vcmod and vcmod1 then
               draw.SimpleTextOutlined(v:VC_getName() or Admin_System_Global.lang["hudunknown"], Admin_Sys_Font, Admin_Sys_PosVeh.x-15, Admin_Sys_PosVeh.y-110, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
               draw.SimpleTextOutlined(Admin_System_Global.lang["hudhealth"].. ""  ..math.Round( v:VC_getHealth(true) ), Admin_Sys_Font, Admin_Sys_PosVeh.x-15, Admin_Sys_PosVeh.y-95, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
               draw.SimpleTextOutlined(Admin_System_Global.lang["hudfuel"].. "" ..math.Round( v:VC_fuelGet(true) ), Admin_Sys_Font, Admin_Sys_PosVeh.x-15, Admin_Sys_PosVeh.y-82, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
               draw.SimpleTextOutlined(Admin_System_Global.lang["hudspeed"].. "" ..math.Round( v:VC_getSpeedKmH() ), Admin_Sys_Font, Admin_Sys_PosVeh.x-15, Admin_Sys_PosVeh.y-68, Admin_Sys_Col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Admin_Sys_Col_2)
          end
     end
     if Admin_System_Global.Mode_Bool then
          draw.DrawText("❘ " ..Admin_System_Global.lang["adminmode_text"].. " ❘", Admin_Sys_Font, Admin_System_Global.Mode_Wide == "droite" and Admin_SysW -100 or Admin_System_Global.Mode_Wide == "gauche" and 125 or Admin_System_Global.Mode_Wide == "milieu" and Admin_SysW / 2, Admin_System_Global.Mode_Height == "bas" and Admin_SysH - 50 or Admin_System_Global.Mode_Height == "milieu" and Admin_SysH / 2 - 35 or Admin_System_Global.Mode_Height == "haut" and 10, Admin_Sys_Col, TEXT_ALIGN_CENTER)

          draw.DrawText("Cloak",Admin_Sys_Font, Admin_System_Global.Mode_Wide == "droite" and Admin_SysW -170 or Admin_System_Global.Mode_Wide == "gauche" and 55 or Admin_System_Global.Mode_Wide == "milieu" and Admin_SysW / 2 - 75, Admin_System_Global.Mode_Height == "bas" and Admin_SysH - 28 or Admin_System_Global.Mode_Height == "milieu" and Admin_SysH / 2 or Admin_System_Global.Mode_Height == "haut" and 35, Admin_Sys_Ply:GetNoDraw() and Admin_Sys_Col_1 or Color(Admin_Sys_Abs, 0, 0), TEXT_ALIGN_CENTER)
          draw.DrawText("Godmod",Admin_Sys_Font,  Admin_System_Global.Mode_Wide == "droite" and Admin_SysW - 100 or Admin_System_Global.Mode_Wide == "gauche" and 120 or Admin_System_Global.Mode_Wide == "milieu" and Admin_SysW / 2, Admin_System_Global.Mode_Height == "bas" and Admin_SysH - 28 or Admin_System_Global.Mode_Height == "milieu" and Admin_SysH / 2 or Admin_System_Global.Mode_Height == "haut" and 35,  Admin_System_Global.SysGodModeStatus and Admin_Sys_Col_1 or Color(Admin_Sys_Abs, 0, 0), TEXT_ALIGN_CENTER)
          draw.DrawText("Noclip",Admin_Sys_Font, Admin_System_Global.Mode_Wide == "droite" and Admin_SysW -35 or Admin_System_Global.Mode_Wide == "gauche" and 185 or Admin_System_Global.Mode_Wide == "milieu" and Admin_SysW / 2 + 70, Admin_System_Global.Mode_Height == "bas" and Admin_SysH - 28 or Admin_System_Global.Mode_Height == "milieu" and Admin_SysH / 2 or Admin_System_Global.Mode_Height == "haut" and 35, (Admin_Sys_Ply:GetMoveType() == MOVETYPE_NOCLIP) and Admin_Sys_Col_1 or  Color(Admin_Sys_Abs, 0, 0), TEXT_ALIGN_CENTER)
     end
end
if Admin_System_Global.SysStreamerMod then
draw.DrawText("Mode streamer activé", Admin_Sys_Font, Admin_System_Global.Mode_Wide == "droite" and Admin_SysW -100 or Admin_System_Global.Mode_Wide == "gauche" and 115 or Admin_System_Global.Mode_Wide == "milieu" and Admin_SysW / 2 - 10, Admin_System_Global.Mode_Height == "bas" and Admin_SysH - 15 or Admin_System_Global.Mode_Height == "milieu" and Admin_SysH / 2 + 15  or Admin_System_Global.Mode_Height == "haut" and 55, Admin_System_Global.SysStreamerMod and Admin_Sys_Col_1 or Color(Admin_Sys_Abs, 0, 0), TEXT_ALIGN_CENTER)
end

for count, notif in pairs( Admin_Sys_Table_Notif ) do
     if notif.Admin_Sys_CurSec - CurTime() < 0 then
          table.remove(Admin_Sys_Table_Notif, count)
          continue
     end

     surface.SetFont( Admin_Sys_Font )
     local x,y = surface.GetTextSize( Admin_Sys_Arrow.. ""  ..notif.Admin_Sys_String )
     local Admin_SyS_H = Admin_SysH / 2 + 150 - 50 * count - 40 * ( 1 - ( math.Clamp( CurTime() - notif.Admin_Sys_CurPrim, 0, 1) ) )
     local Admin_SyS_W = Admin_SysW - 35 - x

     draw.RoundedBox( 5, Admin_SyS_W, Admin_SyS_H , x + 20, 40, Admin_System_Global.NotifPopup )
     draw.DrawText(Admin_Sys_Arrow.. ""  ..notif.Admin_Sys_String, Admin_Sys_Font, Admin_SyS_W + 10, Admin_SyS_H + 40/2-y/2, Admin_Sys_Col, TEXT_ALIGN_LEFT)
end
end)