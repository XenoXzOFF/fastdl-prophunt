----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
---- // https://steamcommunity.com/id/Inj3/

if not Admin_System_Global.Action_On then return end
local Admin_Tbl, Admin_Touch, Admin_Action_DistPly, Admin_Action_DistVeh, Admin_Sys_ButDelay, Admin_Sys_NameDOld, Admin_Sys_Bits, Admin_SysPressed = Admin_Tbl or {}, MOUSE_LEFT, 90000, 400000, 0, nil, 4, false

local function Admin_Sys_But(Admin_Sys_Table, Admin_Sys_x, Admin_Sys_Cursx, Admin_Sys_y, Admin_Sys_Cursy, Admin_Sys_Nw, Admin_Sys_Nh, Admin_Sys_Nd, Admin_Sys_Nt, Admin_Sys_Rev)
     Admin_Tbl[Admin_Sys_Table] = {
          Admin_Sys_x = Admin_Sys_x,
          Admin_Sys_Cursx = math.Round(Admin_Sys_Cursx),
          Admin_Sys_y = Admin_Sys_y,
          Admin_Sys_Cursy = math.Round(Admin_Sys_Cursy),
          Admin_Sys_Nw = Admin_Sys_Nw,
          Admin_Sys_Nh = Admin_Sys_Nh,
          Admin_Sys_Nd = Admin_Sys_Nd,
          Admin_Sys_Nt = Admin_Sys_Nt,
          Admin_Sys_Rev = Admin_Sys_Rev
     }

     if not Admin_Tbl[Admin_Sys_Table].Admin_Sys_Rev then
          if Admin_Tbl[Admin_Sys_Table].Admin_Sys_x > (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursx - Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nw) and Admin_Tbl[Admin_Sys_Table].Admin_Sys_x < (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursx - Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nw) + Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nh and Admin_Tbl[Admin_Sys_Table].Admin_Sys_y > (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursy + (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nt or 0)) and Admin_Tbl[Admin_Sys_Table].Admin_Sys_y < (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursy + (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nt or 0)) + Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nd  then
               return true, Admin_System_Global.Active_ContextMenu and Admin_System_Global:Admin_Sys_CHide(true)
          end
     else
          if Admin_Tbl[Admin_Sys_Table].Admin_Sys_x > (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursx + Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nw) and Admin_Tbl[Admin_Sys_Table].Admin_Sys_x < (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursx + Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nw) + Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nh and Admin_Tbl[Admin_Sys_Table].Admin_Sys_y > (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursy + (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nt or 0)) and Admin_Tbl[Admin_Sys_Table].Admin_Sys_y < (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Cursy + (Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nt or 0)) + Admin_Tbl[Admin_Sys_Table].Admin_Sys_Nd  then
               return true, Admin_System_Global.Active_ContextMenu and Admin_System_Global:Admin_Sys_CHide(true)
          end
     end
     return false, Admin_System_Global.Active_ContextMenu and Admin_System_Global:Admin_Sys_CHide(false)
end

local function Admin_Button_Cmd(Admin_Sys_NameD, Admin_Sys_Posx, Admin_Sys_Posy)
     if input.IsMouseDown( Admin_Touch ) then
          draw.RoundedBox(6, Admin_Sys_Posx, Admin_Sys_Posy, 100 - 2, 25 - 2, Color(192, 57, 43))
          if Admin_Sys_NameDOld ~= Admin_Sys_NameD or not Admin_Sys_NameD then
               Admin_Sys_NameDOld = Admin_Sys_NameD
          end
          if Admin_Sys_NameDOld == Admin_Sys_NameD then
               if Admin_SysPressed then
                    return false
               end
               Admin_SysPressed = true
               return true, surface.PlaySound( "buttons/button15.wav" )
          end
     end

     Admin_SysPressed = false
     return false
end

local function Admin_Sys_Context_Action()
     local Admin_Player = LocalPlayer()

     if not Admin_System_Global.Action_Perm and Admin_System_Global.Action_Table[Admin_Player:GetUserGroup()] or Admin_System_Global.Action_Table[Admin_Player:GetUserGroup()] and Admin_Player:AdminStatusCheck() then

          local Admin_Sys_FindClass_Ply = ents.FindByClass("player")
          local Admin_Sys_FindClass_Veh = ents.FindByClass("prop_vehicle_jeep")

          for _, v in ipairs(Admin_Sys_FindClass_Ply) do
               if Admin_Player == v or v:GetPos():DistToSqr(Admin_Player:GetPos()) > Admin_Action_DistPly or v:InVehicle() then continue end

               local admin_EyePos = v:EyePos() + Vector(0,0,3)
               admin_EyePos = admin_EyePos:ToScreen()
               local x, y = input.GetCursorPos()

               --///////--
               if v:Alive() then
                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_adminzone"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, nil, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)

                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_adminzone"], admin_EyePos.x - 130, admin_EyePos.y) then
                              if Admin_Player:AdminStatusCheck() then
                                   net.Start("Admin_Sys:ZNAdmin")
                                   net.WriteBool(true)
                                   net.WriteEntity(v)
                                   net.WriteUInt( 3, Admin_Sys_Bits )
                                   net.SendToServer()
                              else
                                   Admin_Player:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["contextaction_adminmod"].. "" ..Admin_System_Global.Mode_Cmd )
                              end
                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_adminzone"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_adminzone"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 3 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_strip"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 40, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 40, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 40 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if #v:GetWeapons() >= 1 and Admin_Button_Cmd( Admin_System_Global.lang["contextaction_strip"], admin_EyePos.x - 130, admin_EyePos.y + 40) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 3, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(false)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_strip"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 40 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(#v:GetWeapons() <= 0 and "No weapons" or Admin_System_Global.lang["contextaction_strip"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 43 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_freeze"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 80, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 80, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 80 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_freeze"], admin_EyePos.x - 130, admin_EyePos.y + 80) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 1, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(false)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_freeze"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 80 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(v:GetCollisionGroup() == COLLISION_GROUP_PLAYER and Admin_System_Global.lang["contextaction_freeze"] or Admin_System_Global.lang["contextaction_unfreeze"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 83 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_fullhealth"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 120, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 120, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 120 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_fullhealth"], admin_EyePos.x - 130, admin_EyePos.y + 120) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 2, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(false)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_fullhealth"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 120 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_fullhealth"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 123 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_fullarmor"] , x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 160, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 160, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 160 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_fullarmor"], admin_EyePos.x - 130, admin_EyePos.y + 160) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 4, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(false)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_fullarmor"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 160 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_fullarmor"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 163 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_mute"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 200, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 200, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 200 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_mute"], admin_EyePos.x - 130, admin_EyePos.y + 200) then
                              if v:IsMuted() then
                                   v:SetMuted( false )
                              else
                                   v:SetMuted( true )
                              end

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_mute"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 200 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(v:IsMuted() and Admin_System_Global.lang["contextaction_unmute"] or Admin_System_Global.lang["contextaction_mute"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 203 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_retpos"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 240, false) then
                         draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 240, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 240 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_retpos"], admin_EyePos.x - 130, admin_EyePos.y + 240) then
                              net.Start("Admin_Sys:TP_Reset")
                              net.WriteUInt( 1, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.SendToServer()
                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_retpos"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 240 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_retpos"] , "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 243 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if ((RHandcuffsConfig and v:GetNWBool("rhc_cuffed")) or Realistic_Police or (RKidnapConfig and v:GetNWBool("rks_unrestrain"))) then
                         if Admin_Sys_But(Admin_System_Global.lang["contextaction_uncuff"], x, admin_EyePos.x, y, admin_EyePos.y, 130, 100, 25, 280, false) then
                              draw.RoundedBox(6, admin_EyePos.x-130 + 1, admin_EyePos.y + 280, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                              draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 280 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                              if Admin_Button_Cmd(Admin_System_Global.lang["contextaction_uncuff"], admin_EyePos.x - 130, admin_EyePos.y + 280) then

                                   if RHandcuffsConfig then
                                        Admin_Player:ConCommand("rhc_cuffplayer " ..v:Nick())
                                   end

                                   if Realistic_Police then
                                        net.Start("Admin_Sys:Action")
                                        net.WriteUInt( 10, Admin_Sys_Bits )
                                        net.WriteEntity(v)
                                        net.WriteBool(false)
                                        net.SendToServer()
                                   end

                                   if RKidnapConfig then
                                        if v:GetNWBool("rks_restrained") and v:GetPos():DistToSqr(Admin_Player:GetPos()) < 5000 then
                                             net.Start("rks_unrestrain")
                                             net.WriteEntity(v)
                                             net.SendToServer()
                                        else
                                             Admin_Player:PrintMessage( HUD_PRINTTALK, "Le joueur n'a pas de serflex, ou est trop loin de votre position !" )
                                        end
                                   end

                                   Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_uncuff"]
                              end
                         else
                              draw.RoundedBox(6, admin_EyePos.x-130, admin_EyePos.y + 280 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         end
                         draw.DrawText(Admin_System_Global.lang["contextaction_uncuff"], "Admin_Sys_Font_T1", admin_EyePos.x - 80 , admin_EyePos.y + 283 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)
                    end

                    --///////--

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_copysteam"], x, admin_EyePos.x, y, admin_EyePos.y, 30, 100, 25, 40, true) then
                         draw.RoundedBox(6, admin_EyePos.x+30 + 1, admin_EyePos.y + 40, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x+30, admin_EyePos.y + 40 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_copysteam"], admin_EyePos.x + 30, admin_EyePos.y + 40) then
                              SetClipboardText( v:SteamID() )
                              Admin_Player:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["ticket_copysteam_t"].. " " ..v:SteamID() )
                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_copysteam"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x+30, admin_EyePos.y + 40 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_copysteam"] , "Admin_Sys_Font_T1", admin_EyePos.x + 80 , admin_EyePos.y + 43 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But("General", x, admin_EyePos.x, y, admin_EyePos.y, 30, 100, 25, 80, true) then
                         draw.RoundedBox(6, admin_EyePos.x+30 + 1, admin_EyePos.y + 80, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x+30, admin_EyePos.y + 80 + 1 , 100 - 2, 25- 2, Admin_System_Global.ButContextAction)

                         if Admin_Button_Cmd( "General", admin_EyePos.x + 30, admin_EyePos.y + 80) then
                              Admin_Player:ConCommand( Admin_System_Global.Cmd_General )
                              Admin_Sys_NameDOld = "General"
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x+30, admin_EyePos.y +80 + 1 , 100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText("General" , "Admin_Sys_Font_T1", admin_EyePos.x + 80 , admin_EyePos.y + 83 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But("Warn", x, admin_EyePos.x, y, admin_EyePos.y, 30, 100, 25, 120, true) then
                         draw.RoundedBox(6, admin_EyePos.x + 30 + 1, admin_EyePos.y + 120,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x + 30, admin_EyePos.y + 120 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)

                         if Admin_Button_Cmd( "Warn", admin_EyePos.x + 30, admin_EyePos.y + 120) then
                              Admin_Player:ConCommand( "say " ..Admin_System_Global.Action_Warn )
                              Admin_Sys_NameDOld = "Warn"
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x + 30, admin_EyePos.y + 120 + 1 , 100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText("Warn" , "Admin_Sys_Font_T1", admin_EyePos.x + 80 , admin_EyePos.y + 123, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But("Logs", x, admin_EyePos.x, y, admin_EyePos.y, 30, 100, 25, 160, true) then
                         draw.RoundedBox(6, admin_EyePos.x + 30 + 1, admin_EyePos.y + 160,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x + 30, admin_EyePos.y + 160 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)

                         if Admin_Button_Cmd( "Logs", admin_EyePos.x + 30, admin_EyePos.y + 160) then
                              Admin_Player:ConCommand( "say " ..Admin_System_Global.Action_Logs )
                              Admin_Sys_NameDOld = "Logs"
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x + 30, admin_EyePos.y + 160 + 1 , 100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText("Logs" , "Admin_Sys_Font_T1", admin_EyePos.x + 80 , admin_EyePos.y + 163, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_refund"], x, admin_EyePos.x, y, admin_EyePos.y, 30, 100, 25, 200, true) then
                         draw.RoundedBox(6, admin_EyePos.x + 30 + 1, admin_EyePos.y + 200,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x + 30, admin_EyePos.y + 200 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)

                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_refund"], admin_EyePos.x + 30, admin_EyePos.y + 200) then
                              Admin_Player:ConCommand( Admin_System_Global.Remb_Cmd )
                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_refund"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x + 30, admin_EyePos.y + 200 + 1 , 100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_refund"], "Admin_Sys_Font_T1", admin_EyePos.x + 80 , admin_EyePos.y + 203, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

               else
                    --///////--
                    draw.DrawText(v:GetName() or Admin_System_Global.lang["hudunknown"] , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y - 42, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But("Respawn", x, admin_EyePos.x, y, admin_EyePos.y, 200, 100, 25, nil, false) then
                         draw.RoundedBox(6, admin_EyePos.x-200 + 1, admin_EyePos.y,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)

                         if Admin_Button_Cmd( "Respawn", admin_EyePos.x - 200, admin_EyePos.y) then
                              if not Admin_Player:AdminStatusCheck() then
                                   Admin_Player:PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["contextaction_adminmod"].. "" ..Admin_System_Global.Mode_Cmd )
                                   return
                              end
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 5, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(false)
                              net.SendToServer()

                              Admin_Sys_NameDOld = "Respawn"
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText("Respawn" , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y + 3 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)
               end
          end

          for k, v in ipairs(Admin_Sys_FindClass_Veh) do
               if not v:IsVehicle() or v:GetPos():DistToSqr(Admin_Player:GetPos()) > Admin_Action_DistVeh then continue end

               local admin_EyePos = v:EyePos() + v:OBBCenter() + Vector(0,0,5)
               admin_EyePos = admin_EyePos:ToScreen()
               local x, y = input.GetCursorPos()

               if Admin_Sys_But(Admin_System_Global.lang["contextaction_delete"], x, admin_EyePos.x, y, admin_EyePos.y, 200, 100, 25, nil, false) then
                    draw.RoundedBox(6, admin_EyePos.x-200 + 1, admin_EyePos.y,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                    draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_delete"], admin_EyePos.x - 200, admin_EyePos.y) then
                         net.Start("Admin_Sys:Action")
                         net.WriteUInt( 9, Admin_Sys_Bits )
                         net.WriteEntity(v)
                         net.WriteBool(true)
                         net.SendToServer()

                         Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_delete"]
                    end
               else
                    draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
               end
               draw.DrawText(Admin_System_Global.lang["contextaction_delete"] , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y + 3 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

               if vcmod1 then
                    draw.DrawText(v:VC_getName() or "..." , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y - 42, Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_fuelmax"], x, admin_EyePos.x, y, admin_EyePos.y, 200, 100, 25, 40, false) then
                         draw.RoundedBox(6, admin_EyePos.x-200 + 1, admin_EyePos.y + 40,100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 40 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_fuelmax"], admin_EyePos.x - 200, admin_EyePos.y + 40) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 7, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(true)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_fuelmax"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 40 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_fuelmax"] , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y + 43 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)

                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_repair"], x, admin_EyePos.x, y, admin_EyePos.y, 200, 100, 25, 80, false) then
                         draw.RoundedBox(6, admin_EyePos.x-200 + 1, admin_EyePos.y + 80, 100 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 80 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_repair"], admin_EyePos.x - 200, admin_EyePos.y + 80) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 6, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(true)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_repair"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-200, admin_EyePos.y + 80 + 1 ,100 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_repair"] , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y + 83 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)
               end
               if IsValid(v:GetDriver()) then
                    if Admin_Sys_But(Admin_System_Global.lang["contextaction_ejectowner"] , x, admin_EyePos.x, y, admin_EyePos.y, 225, 150, 25, 120, false) then
                         draw.RoundedBox(6, admin_EyePos.x-225 + 1, admin_EyePos.y + 120, 150 - 4, 25, Admin_System_Global.ButContextActionHover )
                         draw.RoundedBox(6, admin_EyePos.x-225, admin_EyePos.y + 120 + 1 ,150 - 2, 25- 2, Admin_System_Global.ButContextAction)
                         if Admin_Button_Cmd( Admin_System_Global.lang["contextaction_ejectowner"], admin_EyePos.x - 200, admin_EyePos.y + 120) then
                              net.Start("Admin_Sys:Action")
                              net.WriteUInt( 8, Admin_Sys_Bits )
                              net.WriteEntity(v)
                              net.WriteBool(true)
                              net.SendToServer()

                              Admin_Sys_NameDOld = Admin_System_Global.lang["contextaction_ejectowner"]
                         end
                    else
                         draw.RoundedBox(6, admin_EyePos.x-225, admin_EyePos.y + 120 + 1 ,150 - 2, 25- 2, Admin_System_Global.ButContextAction)
                    end
                    draw.DrawText(Admin_System_Global.lang["contextaction_ejectowner"]  , "Admin_Sys_Font_T1", admin_EyePos.x - 151 , admin_EyePos.y + 123 , Admin_System_Global.ButTextContextAction, TEXT_ALIGN_CENTER)
               end
          end
     end
end

hook.Add("OnContextMenuOpen", "Admin_System_ContextAction_OP", function()
hook.Add("HUDPaint", "Admin_Sys_Context_Action", Admin_Sys_Context_Action)
end)

hook.Add("OnContextMenuClose", "Admin_System_ContextAction_CL", function()
hook.Remove("HUDPaint","Admin_Sys_Context_Action")
end)