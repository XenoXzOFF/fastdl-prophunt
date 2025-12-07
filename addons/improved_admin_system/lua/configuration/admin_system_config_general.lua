----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System
--- // true = activer, false = désactiver

--- The language can be changed directly in the file : addons\improved_admin_system\lua\autorun\admin_system_load.lua (if you are not French)

Admin_System_Global.General_Permission = { --- // Indiquer ici les groupes qui peuvent avoir un accès presque total, comme traiter/afficher les tickets, activer le Mode Admin, et accéder à certaines actions. Ne pas indiquer d'autres groupes que vos groupes modérateurs/administrateurs/superadmins !
     ["ModoTest"] = {Level = 10}, --- // Level : (Un nombre inférieur ne peut pas effectuer d'action sur un nombre supérieur) Freeze un autre joueur, se téléporter, strip, ejecter conducteur, ect.. si vous souhaitez aucune restriction entre vos groupes, indiquer le même nombre partout dans la catégorie "Level".
     ["Helper"] = {Level = 10},
	 ["ModoTestVIP"] = {Level = 10},
     ["Moderateur"] = {Level = 30},
     ["ModerateurVIP"] = {Level = 30},
     ["Moderateur+"] = {Level = 50},
     ["Moderateur+VIP"] = {Level = 50},
     ["Chef moderateur"] = {Level = 70},
     ["Chef moderateurVIP"] = {Level = 70},
     ["Administrateur"] = {Level = 80},
     ["AdministrateurVIP"] = {Level = 80},
     ["GerantSTAFF"] = {Level = 90},
     ["admin"] = {Level = 95},
     ["superadmin"] = {Level = 100},
}

if SERVER then
     --- //
     Admin_System_Global.Admin_System_Ressource = 1 --- 0 = Aucun téléchargement des ressources automatiques / 1 = Workshop / 2 = FastDL
     Admin_System_Global.Admin_System_Save = "Data" --- // Sauvegarde des données / "Data", "SQLite".
     --- //
     Admin_System_Global.FixShittingAddon_1 = false --- Avez-vous le script "Active Camouflage" (https://steamcommunity.com/sharedfiles/filedetails/?id=308977650), si oui placez la variable en true.
     --- //
     Admin_System_Global.OverrideOpenTick = true  --- true = Remplacer /// et /// + message automatiquement, le panel de création du ticket va s'ouvrir à la place.
     Admin_System_Global.Admin_System_HideNotifAdm = false --- true = Cacher la notification lorsqu'un joueur utilise la commande pour passer en mode administrateur.
     --- //
     Admin_System_Global.SwitchAutoJob = false --- true = Activé le système de changement de job, vous serez automatiquement redirigé dans le métier ci-dessous "Admin_System_Global.SwitchAutoJobTbl".
     Admin_System_Global.SwitchAutoJobTbl = "Administrateur en Service" --- Exemple, indiquer votre job ici si "Admin_System_Global.SwitchAutoJob" est en true.
     Admin_System_Global.SwitchOldJob = false --- true = Revenir à l'état d'origine de votre ancien job après avoir désactivé le mode admin. (rétablie = job, position, arme, armure, vie) / false = désactiver
     --- //
     Admin_System_Global.Admin_System_ForceNoClip = false --- // true = Force le passage en noclip aux administrateurs en mode administrateur. / false = Les administrateurs peuvent désactiver le noclip en mode admin.
     Admin_System_Global.ForceNoClip_WhiteList = { --- // Indiquer ici les groupes WhiteList ne seront pas inclu dans le ForceNoClip.
          ["GerantSTAFF"] = true,
          ["superadmin"] = true,
     }
     --- //
     Admin_System_Global.PhysGun_Freeze = false --- // Activé le système pour freeze un joueur lorsqu'il est attrapé avec le Physics Gun, et/ou réduire sa vitesse d'impact.
     Admin_System_Global.PhysGun_ProtectImpactGround = false --- // Si un joueur est lâché d'une hauteur élevée par le physics gun, sa vitesse sera réduite à zéro avant impact sur le sol (aucun dégât subi).
     Admin_System_Global.PhysGun_Touche = IN_ATTACK2 --- // La Touche pour freeze un joueur lorsqu'il est attrapé avec le Physics Gun (clique droit par défaut) . (https://wiki.facepunch.com/gmod/Enums/IN)
     --- //
     Admin_System_Global.Admin_System_ZoneAdminDist = 300 --- // Indiquer ici la distance maximum à inclure entre les zones administrateurs (minimum conseillé : 300).
     --- //
     Admin_System_Global.AntiSpam_Gen = 1.5 --- // Temps en seconde en général lorsque l'administrateur va pouvoir de nouveau effectuer une action / Anti-SPAM.
     --- //
     Admin_System_Global.Cmd_Service_Groupe = { --- // Indiquer ici les groupes qui peuvent accéder au panel pour consulter les administrateurs en service.
          ["GerantSTAFF"] = true,
          ["superadmin"] = true,
     }
     --- // Groupe pouvant accéder aux mode streamer (les tickets ne seront plus visibles.)
     Admin_System_Global.StreamMod = { --- // Indiquer vos groupes ici
          ["superadmin"] = true,
     }
     --- //
     Admin_System_Global.Remb_On = true --- // true = Activer le système de remboursement. false = Désactiver le système de remboursement.
     Admin_System_Global.Remb_Death = true --- // true = Les joueurs qui sont mort par suicide sont ajoutés dans le système de remboursement.
     Admin_System_Global.Remb_Groupe = { --- // Indiquer ici les groupes qui peuvent accéder au panel de remboursement.
          ["GerantSTAFF"] = true,
          ["superadmin"] = true,
     }

     --- //
     Admin_System_Global.Stats_Groupe = { --- // Indiquer ici les groupes qui peuvent consulter les statistiques des tickets.
          ["Helper"] = true,
		  ["ModoTest"] = true,
          ["ModoTestVIP"] = true,
          ["Moderateur"] = true,
          ["ModerateurVIP"] = true,
          ["Moderateur+"] = true,
          ["Moderateur+VIP"] = true,
          ["Chef moderateur"] = true,
          ["Chef moderateurVIP"] = true,
          ["Administrateur"] = true,
          ["AdministrateurVIP"] = true,
          ["GerantSTAFF"] = true,
          ["superadmin"] = true,
     }

     --- //
     Admin_System_Global.ZoneAdmin_Groupe = { --- // Indiquer ici les groupes qui peuvent ajouter/supprimer des Zones Admin.
          ["GerantSTAFF"] = true,
          ["superadmin"] = true,
     }
else
     --- //
     Admin_System_Global.NotifPopup_Sound = "buttons/button24.wav" --- // Son de la notification Popup (https://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/index8f77.html)
     Admin_System_Global.FixForceRender = true --- Rétablir automatiquement le cloak en mode administrateur si l'un de vos addons tente de le retirer sans raison.

     --- // Commandes générales (vous pouvez générer une quantité illimitée de buttons).
     --- Important : lire ci-dessous si vous souhaitez créer vos propres buttons.
     --- Admin_System_Global:AddCmdBut(13, "Custom", "say !admin", "icon16/shield.png") --- Exemple d'un button.
     --- Typo à respecter : (13 --> Ordre de positionnement, "Custom" --> Nom du button, "say !admin" --> Commande à executer, "icon16/shield.png" --> Icon)

     Admin_System_Global:AddCmdBut(1, "Zone Admin", Admin_System_Global.ZoneAdmin_Cmd, "icon16/shield.png")
     Admin_System_Global:AddCmdBut(2, "Stats Admin", Admin_System_Global.Stats_Cmd, "icon16/chart_pie.png")
     Admin_System_Global:AddCmdBut(3, "Remboursement", Admin_System_Global.Remb_Cmd, "icon16/money.png")
     Admin_System_Global:AddCmdBut(4, "Chat Admin", "say " ..Admin_System_Global.Chat_Cmd, "icon16/comments.png")
     Admin_System_Global:AddCmdBut(5, "Admin Config", "say " ..Admin_System_Global.ModeAdmin_Chx, "icon16/cog.png")
     Admin_System_Global:AddCmdBut(6, "Admin Service", "say " ..Admin_System_Global.Service_Cmd, "icon16/user.png")
     Admin_System_Global:AddCmdBut(7, "Mode admin", "say " ..Admin_System_Global.Mode_Cmd, "icon16/eye.png")
     Admin_System_Global:AddCmdBut(8, "Créer un ticket", Admin_System_Global.Ticket_Cmd, "icon16/email_edit.png")
     Admin_System_Global:AddCmdBut(9, "Gestion (wip)", "wip", "icon16/lock.png") --- // Cette fonctionnalité sera disponible dans une prochaine mise à jour.
     Admin_System_Global:AddCmdBut(10, "Ulx", "say !menu", "icon16/application_osx_terminal.png") --- // Si la commande n'est pas une commande console, mais seulement disponible via le chat, ajouter say devant votre commande.
     Admin_System_Global:AddCmdBut(11, "Warn", "say !warn", "icon16/bell.png")
     Admin_System_Global:AddCmdBut(12, "Logs", "say !logs", "icon16/page_white_code.png")

     --- //
     Admin_System_Global.Admin_System_AutoRdm = false --- // true (déconseillé pour le moment, contactez-moi si vous en avez réellement besoin) : Activer l'auto-redimension des panneaux en fonction de la résolution de l'écran. (peut baisser la qualité visuelle des panneaux) / Par défaut : false - Désactiver
end