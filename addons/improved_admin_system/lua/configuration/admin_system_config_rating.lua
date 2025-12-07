----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System
--- // true = activer, false = désactiver

Admin_System_Global.RateAdminEnable = true --- // true = Activer le système d'avis support (évaluation) - // Désactiver le système d'avis support
Admin_System_Global.RateAdminDelete = { --- // Qui peut supprimer un commentaire créer par un joueur ?
     ["GerantSTAFF"] = true,
     ["superadmin"] = true,
}

if SERVER then
     Admin_System_Global.RateAdminDelay = 15 ---(en minutes) Le temps avant qu'un joueur puisse de nouveau avoir une demande d'avis via un ticket.
     Admin_System_Global.RateAdmin = true --- // true = Les administrateurs ne peuvent pas voter entre eux - false = les administrateurs peuvent voter entre eux.
end