----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
----------- // SCRIPT BY INJ3
--- // https://steamcommunity.com/id/Inj3/
--- // Improved Admin System
--- // true = activer, false = désactiver

--- //
Admin_System_Global.TicketLoad = true --- true = Activer le système de ticket / false = Désactiver le système de ticket.
Admin_System_Global.Ticket_TakePerm = false --- IMPORTANT = true : Les tickets peuvent être pris en charge et gérer que si vous êtes en mode administrateur. / - False = Les tickets peuvent être pris en charge hors mode administrateur.
Admin_System_Global.CharMax = 100 --- // Indiquer ici le nombre de caractère limite maximum que le joueur peut inclure dans un ticket.
--- //

Admin_System_Global.Notif_Gen = { --- // Créer vos propres notifications à inclure au ticket ici !
     [1] = {
          Name_Notification = "Notification [Patientez quelques minutes.]", --- // Nom de votre notification.
          Message_Notification = "Votre ticket admin va être traité dans moins de quelques minutes."  --- // Message à envoyer au joueur !
     },
     [2] = {
          Name_Notification = "Notification [Ticket traité dans moins d'une minute.]",  --- // Nom de votre notification.
          Message_Notification = "Votre ticket va être traité dans moins d'une minute."   --- // Message à envoyer au joueur !
     }
}

if CLIENT then
     Admin_System_Global.Notif_Bool = true --- // false = Les tickets seront visibles, et affichés directement sans la notification. / true = Afficher une notification cliquable lorsqu'un ticket est reçu, les tickets ne seront plus visibles, ils doivent être affichés seulement via la notification
     Admin_System_Global.Ticket_AntiPCharge = false --- // true = Les administrateurs ne peuvent pas reprendre un ticket déjà prise en charge. / false = Les administrateurs peuvent reprendre un ticket déjà prise en charge.
     --- //
     Admin_System_Global.Ticket_Delai = 1500 --- // Temps avant la fermeture d'un ticket en seconde - // Inclure 0 si vous ne voulez pas de délai de fermeture automatique.
     Admin_System_Global.Ticket_TicketVisible = 3 --- // Indiquer ici le maximum de ticket qui seront visibles sur votre écran.
     Admin_System_Global.Ticket_CachePCharge = false  --- // true : Cacher le nom des administrateurs qui ont pris en charge le ticket aux autres administrateurs.
     --- //
     Admin_System_Global.Ticket_CachePCharge_Text = "Un administrateur"  --- // Le texte qui va être remplacé, si vous avez caché le nom lors de la prise en charge.
     Admin_System_Global.Notif_Son = "ui/hint.wav"  --- // Son lorsqu'un ticket est reçu -- https://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/index8f77.html
     Admin_System_Global.Ticket_NoText = "Le support est actuellement hors ligne, veuillez nous contacter via notre Teamspeak ---> teamspeak5.mtxserv.fr:10142" --- // Le texte a affiché s'il n'y a aucun administrateur en ligne.
     --- //
     Admin_System_Global.Ticket_PosRdm_H  = "haut" --- // La positions des tickets vertical, "haut", "milieu".
     Admin_System_Global.Ticket_PosRdm_W  = "droite" --- // La positions des tickets horizontal, "gauche", "droite".
else
     Admin_System_Global.Ticket_Text = "Le ticket a bien été envoyé, temps de réponse estimé max : 10 minutes !" --- // Le texte a affiché lorsqu'un joueur a envoyé un ticket aux administrateurs.
     --- //
     Admin_System_Global.Take_Ticket = 10 --- // Temps en secondes entre les différentes prises en charge des tickets par l'administrateur via le button "prendre ticket" / Anti-SPAM.
     Admin_System_Global.Ticket_EnvJoueur = 5 --- // Temps en secondes avant qu'un joueur puisse à nouveau envoyer un ticket / Anti-SPAM.
     --- //
     Admin_System_Global.Ticket_CachePCharge_Jr = false --- // true = Cacher la notification de prise en charge envoyée aux joueurs.
     Admin_System_Global.Ticket_Bool = true --- // true = Les tickets seront visibles tout le temps hors mode Admin / false = Les tickets sont visibles que si vous avez activé le mode Admin.
     Admin_System_Global.Ticket_Bool_1 = true --- // true = Vous pouvez voir vos propres tickets crée en administrateur / false = Seuls les autres administrateurs connectés peuvent voir vos propres tickets créés en administrateur.
end

--- // Créer vos propres buttons sur le panneau de création du ticket (vous pouvez générer une quantité illimitée de buttons) ,"!ticket" ou votre commande pré-défini dans la console, ou le chat.
Admin_System_Global:AddTicketBut(1, "Url Discord", "https://discord.gg/F2jsGwjSjK", false, false)
Admin_System_Global:AddTicketBut(2, "Workshop", "https://steamcommunity.com/sharedfiles/filedetails/?id=2592191209", false, false)
Admin_System_Global:AddTicketBut(3, "Boutique", "", false, false)
Admin_System_Global:AddTicketBut(4, "No RP", "", true, true)
Admin_System_Global:AddTicketBut(5, "Freekill", "", true, true)
Admin_System_Global:AddTicketBut(6, "Insulte", "", true, true)
Admin_System_Global:AddTicketBut(7, "Bloquer", "", false, false)
Admin_System_Global:AddTicketBut(8, "Erreur Rose", "", true, false)
Admin_System_Global:AddTicketBut(9, "Script Erreur", "", true, false)
Admin_System_Global:AddTicketBut(10, "Questions", "", true, false)
Admin_System_Global:AddTicketBut(11, "No Pain", "", true, true) 

--- Important : lire ci-dessous si vous souhaitez créer vos propres buttons.
--- Admin_System_Global:AddTicketBut(12, "Custom", "https://monsite.com", false, false) -- Exemple d'un button.
--- Typo à respecter : (1 --> Ordre de positionnement, "Custom" --> Nom du button, "https://monsite.com" --> Lien vers votre site web, false --> Si true, alors une fenêtre avec des indications en plus s'affichera pour le joueur, false --> Si true alors une demande d'évaluation sera envoyé aux joueurs à la fin du ticket, aucune demande ne peut être envoyée si les buttons ouvre déjà un site web)