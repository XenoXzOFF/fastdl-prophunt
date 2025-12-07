----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

local Admin_Sys_OverrideCommand, Admin_Sys_OverrideCommand_AR, Admin_Sys_Timerdl, Admin_Sys_GameEngine = "///", "@", 0.00001, engine.ActiveGamemode()
Admin_Sys_RembTable = Admin_Sys_RembTable or {}
Admin_Sys_TeleportCheck = Admin_Sys_TeleportCheck or {}
AdminSys_StatusSwitch = AdminSys_StatusSwitch or {}
Admin_SysRate = Admin_SysRate or {}

--- Override code of the crappy addon. (https://steamcommunity.com/sharedfiles/filedetails/?id=308977650) and fix rendering player !
if Admin_System_Global.FixShittingAddon_1 then
     hook.Add("Initialize", "AdminSystem_OverrideHook_Init", function()
     hook.Remove("Think", "SetPlayerCamoAlpha")
     local Improved_AdmiSystemFix = nil

     local function Admin_SystemFixAddonsWorkshop() --- Rewrite and optimize this shitting code
          local Improved_AdmiSystemFixCur = CurTime()

          if Improved_AdmiSystemFixCur > (Improved_AdmiSystemFix or 0) then
               local Admin_SysClassPl = ents.FindByClass("player")
               for _, v in ipairs(Admin_SysClassPl) do

                    if v:GetNWBool("CamoEnabled") then
                         if (v:GetVelocity():Length() <= 1) then
                              v:SetNoDraw(true)
                         else
                              v:SetNoDraw(false)
                         end
                    end
               end
               Improved_AdmiSystemFix = Improved_AdmiSystemFixCur + 1
          end
          hook.Add("Think", "SetPlayerCamoAlpha", Admin_SystemFixAddonsWorkshop)
          hook.Remove("Initialize", "AdminSystem_OverrideHook_Init")
     end
     end)
end

local function Admin_Sys_OpenPanel(Admin_Sys_Ply)
     if not IsValid(Admin_Sys_Ply) then return end
	 
     Admin_Sys_Ply.Admin_Sys_CheckBool = true
     net.Start("Admin_Sys:Crea_Tick")
     net.Send(Admin_Sys_Ply)
end

local function Admin_Sys_CheckString(Admin_Sys_String, Admin_Sys_Cmd)
     if string.sub( string.lower( Admin_Sys_String ), 1, string.len(string.lower( Admin_Sys_Cmd )) + 1 ) == string.lower( Admin_Sys_Cmd ) then
          return true
     end

     return false
end 

local function Admin_SysCompareGroundPos(AdminSys_Ent, AdminSys_Ply, AdminSysPos_Old)
     local Admin_SysPos = AdminSys_Ent:GetPos()

     local AdminSysTrace = util.TraceLine({
          start = Admin_SysPos,
          endpos = Admin_SysPos * 50000
     })

     if AdminSysTrace.HitPos:Distance( Admin_SysPos ) < 45 and AdminSysTrace.HitPos:Distance( AdminSysPos_Old ) > 145 then
          local AdminSys_vPoint = Admin_SysPos
          local AdminSys_EffectData = EffectData()
		  
          AdminSys_EffectData:SetOrigin( AdminSys_vPoint )
          util.Effect( "StunstickImpact", AdminSys_EffectData )
          AdminSys_Ent:SetLocalVelocity(Vector(0, 0, 0))
		  
          if timer.Exists("ImprovedAdminSysChkGrnd" ..AdminSys_Ply:AccountID()) then
               timer.Remove("ImprovedAdminSysChkGrnd" ..AdminSys_Ply:AccountID())
          end
     end
end

timer.Simple(15, function()
hook.Add("PlayerSay", "Admin_Sys:Chat_Cmd",function(ply, text)
if Admin_System_Global.TicketLoad then
     if Admin_System_Global.OverrideOpenTick then
          if (text[1].. "" ..text[2].. "" ..text[3] == Admin_Sys_OverrideCommand) then
               return "", Admin_Sys_OpenPanel(ply)
          elseif (text[1] == Admin_Sys_OverrideCommand_AR and text[2] ~= "") then
               return Admin_System_Global:AddChatAdmin(ply, string.Replace(text, Admin_Sys_OverrideCommand_AR, ""), true)
          end
     end

     if Admin_System_Global.Ticket_Cmd ~= Admin_Sys_OverrideCommand and Admin_Sys_CheckString(text, Admin_System_Global.Ticket_Cmd) then
          return "", Admin_Sys_OpenPanel(ply)
     end
end

if Admin_Sys_CheckString(text, Admin_System_Global.Stats_Cmd) then
     return "", Admin_System_Global:Sys_Cmd(ply, 1)
end

if Admin_Sys_CheckString(text, Admin_System_Global.Mode_Cmd) then
     return "", ply:Status_()
end

if Admin_Sys_CheckString(text, Admin_System_Global.ZoneAdmin_Cmd) then
     return "", Admin_System_Global:Sys_Cmd(ply, 2)
end

if Admin_Sys_CheckString(text, Admin_System_Global.Remb_Cmd) then
     return "", Admin_System_Global:Sys_Cmd(ply, 3)
end

if Admin_Sys_CheckString(text, Admin_System_Global.Cmd_General) then
     return "", Admin_System_Global:Sys_Cmd(ply, 4)
end

if Admin_Sys_CheckString(text, Admin_System_Global.ModeAdmin_Chx) then
     return "", Admin_System_Global:Sys_Cmd(ply, 5)
end

if Admin_Sys_CheckString(text, Admin_System_Global.Service_Cmd) then
     return "", Admin_System_Global:Sys_Cmd(ply, 6)
end

if Admin_Sys_CheckString(text, Admin_System_Global.Chat_Cmd) then
     return "", Admin_System_Global:Sys_Cmd(ply, 7)
end

if Admin_Sys_CheckString(text, Admin_System_Global.StreamMod_Cmd) then
     return "", ply:ConCommand(Admin_System_Global.StreamMod_Cmd)
end
end)
end)

if Admin_System_Global.Admin_System_ForceNoClip then
     hook.Add( "PlayerNoClip", "Admin_Sys:ForceNoClip", function( ply, desiredState )
     if not Admin_System_Global.ForceNoClip_WhiteList[ply:GetUserGroup()] then

          if Admin_System_Global:Sys_Check(ply) then
               if desiredState or not desiredState then
                    return false
               end
          else
               if desiredState or not desiredState then
                    return false
               end
          end
     end
     end)
end

hook.Add("PlayerSwitchWeapon", "Admin_Sys:SwitchWeap", function(ply)
if Admin_System_Global:State_Ret(ply) then
     timer.Create("Admin_Sys_Switch" .. ply:SteamID(), Admin_Sys_Timerdl, 1, function()	
     if IsValid(ply) then
	 
          for _, v in pairs(ply:GetWeapons()) do
               v:SetNoDraw(true)
          end
     end 
     end)
end
end)

hook.Add("PlayerShouldTakeDamage", "Admin_System_Global:GodModeSys", function(victim, attacker)
if Admin_System_Global:Sys_Check(victim) then

     if victim.SysGodMode then
          return false
     end
end
end)

hook.Add("PlayerLeaveVehicle", "Admin_Sys:Leave_Veh", function(ply)
if Admin_System_Global:State_Ret(ply) then
     timer.Create("Admin_Sys_LeaveVeh" .. ply:SteamID(), Admin_Sys_Timerdl, 1, function()
     if IsValid(ply) then

          ply:SysCloakEnabled()
          ply:SysGodEnabled()
		  ply:SysNoClipEnabled()
     end
     end)
end
end)

if Admin_System_Global.PhysGun_Freeze then
     hook.Add("PhysgunDrop", "Admin_Sys:PhysDrop", function(ply, ent)
     if Admin_System_Global:Sys_Check(ply) and IsValid(ent) and ent:IsPlayer() then
          if ply:KeyPressed(Admin_System_Global.PhysGun_Touche) then

               if Admin_System_Global:LevelCheck(ply, ent) then
                    timer.Simple(Admin_Sys_Timerdl,function()
                    ent:Lock()
                    ent:SetMoveType(MOVETYPE_NONE)
                    ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
                    end)
                    if timer.Exists("ImprovedAdminSysChkGrnd" ..ply:AccountID()) then
                         timer.Remove("ImprovedAdminSysChkGrnd" ..ply:AccountID())
                    end
                    Admin_System_Global:Notification(ply, "[Improved Admin System - PhysGun Freeze] Le joueur " ..ent:Nick().. " est maintenant freeze !")
               end
          else
               ent:UnLock()
               ent:SetMoveType(MOVETYPE_WALK)
               ent:SetCollisionGroup(COLLISION_GROUP_PLAYER)
               if Admin_System_Global.PhysGun_ProtectImpactGround then
                    local Admin_SysPosOldCached = ent:GetPos()
                    timer.Create("ImprovedAdminSysChkGrnd" ..ply:AccountID(), 0, 0, function()
                    if not IsValid(ply) then
                         return
                    end
                    if not IsValid(ent) then
                         timer.Remove("ImprovedAdminSysChkGrnd" ..ply:AccountID())
                         return
                    end
                    Admin_SysCompareGroundPos(ent, ply, Admin_SysPosOldCached)
                    end)
               end
          end

     end
     end)
end

hook.Add("PlayerDisconnected","Admin_Sys:Ply_Disconnected",function(Admin_Sys_Ply)
local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
local Admin_Sys_id = Admin_Sys_Ply:AccountID()

for _, v in ipairs(Admin_Sys_FindClass_Ply) do
     if Admin_System_Global:Sys_Check(v) then
	 
          net.Start("Admin_Sys:Remv_Tick")
          net.WriteEntity(Admin_Sys_Ply)
          net.Send(v)

          local Admin_Sys_AccountIDv  = v:AccountID()
          if Admin_Sys_TeleportCheck[Admin_Sys_AccountIDv] then
               if Admin_Sys_TeleportCheck[Admin_Sys_AccountIDv][Admin_Sys_id] then
                    Admin_Sys_TeleportCheck[Admin_Sys_AccountIDv][Admin_Sys_id] = nil
               end
          end
		  
     end
end

if Admin_Sys_TeleportCheck[Admin_Sys_id] then
     Admin_Sys_TeleportCheck[Admin_Sys_id] = nil
end
if  Admin_Sys_RembTable[Admin_Sys_id] then
     Admin_Sys_RembTable[Admin_Sys_id] = nil
end
if AdminSys_StatusSwitch[Admin_Sys_id] then
     AdminSys_StatusSwitch[Admin_Sys_id] = nil
end
if Admin_SysRate[Admin_Sys_Ply] then
     Admin_SysRate[Admin_Sys_Ply] = nil
end

if timer.Exists("ImprovedAdminSysRvRate" ..Admin_Sys_id) then
     timer.Remove("ImprovedAdminSysRvRate" ..Admin_Sys_id)
end
if timer.Exists("ImprovedAdminSysChkGrnd" ..Admin_Sys_id) then
     timer.Remove("ImprovedAdminSysChkGrnd" ..Admin_Sys_id)
end

end)

hook.Add("PlayerInitialSpawn","Admin_Sys:InitSpawn", function(ply)
timer.Simple(5,function()
if Admin_System_Global:Sys_Check(ply) then
     ply:SetNWBool( "Admin_Sys_Status", false )
end
end)
end)

hook.Add( "OnPlayerChangedTeam", "Admin_Sys:ChangeTeam", function ( ply, oldTeam, newTeam )
timer.Simple(0.1, function()
if not IsValid(ply) then return end

if Admin_System_Global:State_Ret(ply) then
     ply:Status_()
end
end)
end)

hook.Add( "PlayerDeath", "Admin_Sys:DeathPly", function (victim, inflictor, attacker)
if victim:IsPlayer() and Admin_System_Global:Sys_Check(victim) and Admin_System_Global:State_Ret(victim) then
     victim:Status_()

     if AdminSys_StatusSwitch[victim:AccountID()] then
          AdminSys_StatusSwitch[victim:AccountID()] = nil
     end
end
end)

if Admin_System_Global.Remb_On then
     hook.Add( "DoPlayerDeath", "Admin_Sys:DoDeathPly", function(ply, attacker, dmg)
     if ply:IsPlayer() and not ply:IsBot() then
          if not Admin_System_Global.Remb_Death and ply == attacker then return end
          local Admin_Sys_ID = ply:AccountID()

          if Admin_Sys_ID == Admin_Sys_RembTable[Admin_Sys_ID] then
               Admin_Sys_RembTable[Admin_Sys_ID] = nil
          end
          Admin_Sys_RembTable[Admin_Sys_ID] = {health = ply:GetMaxHealth(), weapon = {}, money = {}, model = ply:GetModel(), job = ply:Team(), curtime = CurTime()}

          if (Admin_Sys_GameEngine == "darkrp") then
               local Admin_Sys_Money = ply:getDarkRPVar("money")

               timer.Create("timer_"..ply:SteamID(), 0.5, 1, function()
               if IsValid(ply) then
                    Admin_Sys_RembTable[Admin_Sys_ID].money = Admin_Sys_Money - ply:getDarkRPVar("money")
               end
               end)
          end
          if #ply:GetWeapons() >= 1 then
               for k, v in pairs( ply:GetWeapons() ) do
                    table.insert(Admin_Sys_RembTable[Admin_Sys_ID].weapon, v:GetClass())
               end
          end
     end
     end)
end