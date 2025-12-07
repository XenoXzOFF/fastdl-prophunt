----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System
--- // true = activer, false = désactiver
if SERVER then return end
--- //
Admin_System_Global.Mode_HUD = true --- // Activer l'affichage des informations sur les véhicules/joueurs en mode Admin.
Admin_System_Global.Mode_Vcmod = true --- // true = Si le VCmod est présent sur votre serveur.
Admin_System_Global.Mode_Bypass = { --- // Indiquer ici les groupes qui peuvent contourner l'affichage des informations sur les véhicules/joueurs en mode Admin, ils seront invisibles aux autres admins.
     ["superadmin"] = true,
}

Admin_System_Global.Mode_Bypass_Veh = true --- // Les admins ne voient pas les infos des véhicules appartenant au groupe ci-dessus "Admin_System_Global.Mode_Bypass".
Admin_System_Global.Mode_Bypass_Player = true --- // Les admins ne voient pas les infos des joueurs appartenant au groupe ci-dessus "Admin_System_Global.Mode_Bypass".
--- //
Admin_System_Global.Mode_Bool = true --- // Activer l'affichage des états (cloak, godmod, noclip) sur votre HUD en mode Admin.
Admin_System_Global.Mode_Height = "haut" --- Positionement vertical - "haut", "milieu", "bas".
Admin_System_Global.Mode_Wide = "milieu" --- Positionement horizontal - "gauche", "milieu", "droite".