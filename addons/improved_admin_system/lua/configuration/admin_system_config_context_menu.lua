----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System
--- // true = activer, false = désactiver
if SERVER then return end

--- // Commande Chat
Admin_System_Global.Action_Warn = "!warn" --- // Inclure votre commande chat pour ouvrir vos Warns ici !
Admin_System_Global.Action_Logs = "!logs" --- // Inclure votre commande chat pour ouvrir vos Logs ici !

--- // Context Menu de Garry's Mod par défaut (Affichage, PNJs, BodyGroup ect..)
Admin_System_Global.Cacher_ContextDefaut = true --- // Cacher les buttons du Context Menu par défaut de Garry's Mod (Affichage, PNJs, BodyGroup ect..)
Admin_System_Global.WhiteList_ContextDefaut = { --- // Les groupes qui verront les buttons du Context Menu par défaut (Affichage, PNJs, BodyGroup ect..)
     ["superadmin"] = true,
}

--- // Context Menu Action Improved Admin System
Admin_System_Global.Action_On = true --- // true = Activer le Context Menu Action de Improved Admin System.
Admin_System_Global.Action_Perm = false --- // true = Les administrateurs peuvent activer le context menu action seulement en administrateur en service, et s'ils sont dans le groupe "Admin_System_Global.Action_Table" / false = Seul le groupe "Admin_System_Global.Action_Table" sera pris en compte pour ouvrir le context menu action.
Admin_System_Global.Action_Table = { --- // Indiquer ici les groupes qui peuvent accéder aux Context Menu Action.
     ["Helper"] = true,
	 ["Moderateur Test"] = true,
     ["Moderateur Test vip"] = true,
     ["Moderateur"] = true,
     ["Moderateur vip"] = true,
     ["Moderateur+"] = true,
     ["Moderateur+VIP"] = true,
     ["Chef moderateur"] = true,
     ["Chef moderateurVIP"] = true,
     ["Administrateur"] = true,
     ["admin vip"] = true,
     ["GerantSTAFF"] = true,
     ["admin"] = true,
     ["superadmin"] = true,
}

--- // Context Menu Improved Admin System
Admin_System_Global.Active_ContextMenu = true --- // Activer le Context Menu de Improved Admin System.
Admin_System_Global.Title = "Improved Admin System - Context Menu" --- // Titre du context menu de gauche.
Admin_System_Global.ContextMenu_TitleRight = "Action rapide" --- Titre du context menu de droite.

Admin_System_Global.ContextMenu_BlackList = { --- // Les métiers blacklist qui ne peuvent pas avoir accès au Context Menu.
     ["Pigeon"] = true,
     ["Mouette"] = true,
}
Admin_System_Global.ContextMenu_WeaponBackList = { --- // Lorsque vous tenez une arme, le context menu ne peut pas s'ouvrir.
     ["vc_wrench"] = true, --- Exemple
}

Admin_System_Global.ContextLeftHide = false --- // true : Cacher le context menu de gauche.
Admin_System_Global.ContextLeftPos = "gauche" --- // (gauche,droite) Position du context menu de gauche.
Admin_System_Global.ContextMenu_CountPolice = { --- // Context menu de gauche, compter le nombre de joueur en ligne - Indiquer votre nom de job Police ici
     ["*WL* CHEF BAC"] = true,
     ["Recrue du Swat"] = true,
     ["WL* Chef du Swat"] = true,
     ["Sniper du Swat"] = true,
     ["*WL* BAC"] = true,
     ["Policier Corrompu"] = true,
     ["Cadet"] = true,
     ["*WL* Officier"] = true,
     ["*WL* Officier Plus"] = true,
     ["*WL* Capitaine"] = true,
     ["Recrue Bac"] = true,
}
Admin_System_Global.ContextMenu_CountMedic = { --- // Context menu de gauche, compter le nombre de joueur en ligne - Indiquer votre nom de job Médecin ici
     ["Medecin"] = true,
}

Admin_System_Global.ContextRightHide = false --- // true : Cacher le context menu de droite.
Admin_System_Global.ContextRightPos = "droite" --- // (gauche,droite) Position du context menu de droite.
Admin_System_Global.Command_ContextMenu = "simple_thirdperson_enable_toggle" --- // Commande pour changer de vue (ThirdPerson).

Admin_System_Global.ContextMenu_TblFunc = { --- // Button du context menu de droite, vous pouvez les modifier ici, et en ajouter dans les catégories ci-dessous.
     ["Joueur Action"] = {
          [1] = {Name = Admin_System_Global.lang["contextmenu_dropmoney"], Icon = "icon16/money_delete.png", Func = function()
          Admin_System_Global:ContextMenu_Func(false)
          end},

          [2] = {Name = Admin_System_Global.lang["contextmenu_givemoney"], Icon = "icon16/money_add.png", Func = function()
          Admin_System_Global:ContextMenu_Func(true)
          end},

          [3] = {Name = Admin_System_Global.lang["contextmenu_ticket"], Icon = "icon16/shield.png", Func = function()
          LocalPlayer():ConCommand( Admin_System_Global.Ticket_Cmd)
          end},

          [4] = {Name = Admin_System_Global.lang["contextmenu_dropweap"], Icon = "icon16/monitor.png", Func = function()
          LocalPlayer():ConCommand( "say /drop")
          end},

          [5] = {Name = Admin_System_Global.lang["contextmenu_stopsound"],  Icon = "icon16/music.png", Func = function()
          LocalPlayer():ConCommand( "stopsound")
          chat.AddText(Color( 255, 0, 0 ), "[", "Admin System", "] : ", Color( 255, 255, 255 ), Admin_System_Global.lang["contextmenu_textstopsound"] )
          end},

          [6] = {Name = Admin_System_Global.lang["contextmenu_changeview"], Icon = "icon16/webcam.png", Func = function()
          LocalPlayer():ConCommand( Admin_System_Global.Command_ContextMenu )
          end},

          [7] = {Name = "Donner licence", Icon = "icon16/vcard.png", OnlyForMayor = true, Func = function()
          LocalPlayer():ConCommand( "say /givelicense" )
          end},

          [8] = {Name = "Vendre mes portes", Icon = "icon16/door_open.png", Func = function()
          LocalPlayer():ConCommand( "say /sellalldoors" )
          end}
     },
     ["Admin Action"] = {
          [1] = {Name = Admin_System_Global.lang["contextmenu_adminmod"], Icon = "icon16/eye.png",  OnlyForAdmin = true, Func = function()
          if LocalPlayer():AdminStatusCheck() then LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["contextmenu_adminmodeon"] ) return end
          net.Start("Admin_Sys:Cmd_Status")
          net.SendToServer()
          end},

          [2] = {Name = Admin_System_Global.lang["contextmenu_rpmod"], Icon = "icon16/house.png", OnlyForAdmin = true, Func = function()
          if not LocalPlayer():AdminStatusCheck() then LocalPlayer():PrintMessage( HUD_PRINTTALK, Admin_System_Global.lang["contextmenu_adminmodeoff"] ) return end
          net.Start("Admin_Sys:Cmd_Status")
          net.SendToServer()
          end},

          [3] = {Name = Admin_System_Global.lang["contextmenu_log"], Icon = "icon16/page_white_code.png", OnlyForAdmin = true, Func = function()
          LocalPlayer():ConCommand( "say " ..Admin_System_Global.Action_Logs )
          end},

          [4] = {Name = Admin_System_Global.lang["contextmenu_warn"], Icon = "icon16/bell.png", OnlyForAdmin = true, Func = function()
          LocalPlayer():ConCommand( "say " ..Admin_System_Global.Action_Warn )
          end},

          [5] = {Name = Admin_System_Global.lang["contextmenu_refund"], Icon = "icon16/money.png", OnlyForAdmin = true, Func = function()
          LocalPlayer():ConCommand( Admin_System_Global.Remb_Cmd )
          end},

          [6] = {Name = Admin_System_Global.lang["contextmenu_cmdgeneral"], Icon = "icon16/chart_organisation.png", OnlyForAdmin = true, Func = function()
          LocalPlayer():ConCommand( Admin_System_Global.Cmd_General )
          end},

          [7] = {Name = "Me démenotter", Icon = "icon16/cut_red.png", OnlyForAdmin = true, Func = function()
          if RHandcuffsConfig then
               if LocalPlayer():GetNWBool("rhc_cuffed") then
                    LocalPlayer():ConCommand("rhc_cuffplayer " ..LocalPlayer():Nick())
					return
               else
                    LocalPlayer():PrintMessage( HUD_PRINTTALK, "Vous n'êtes pas menotté !" )
               end
          end
          if RKidnapConfig then
               if LocalPlayer():GetNWBool("rks_restrained") then
					 LocalPlayer():ConCommand("rks_togglerestrains " ..LocalPlayer():Nick())
					return
               else
                    LocalPlayer():PrintMessage( HUD_PRINTTALK, "Vous n'avez pas de serflex !" )
               end
          end
          if Realistic_Police then
		  -- I haven't found any NW or other way to return the status on the client side, the developer wouldn't answer me to Discord, I did the best I could to adapt it..
               net.Start("Admin_Sys:Action")
               net.WriteUInt( 10, 4 )
               net.WriteBool(false)
               net.SendToServer()
               return
          end

          LocalPlayer():PrintMessage( HUD_PRINTTALK, "Realistic Handcuffs ou Realistic_Police ou Realistic Kidnaping n'est pas installé sur votre serveur !" )
          end}
     }
}