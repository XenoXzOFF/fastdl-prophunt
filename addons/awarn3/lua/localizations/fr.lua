--[[
  AWarn3 Localization: FR-FR (Français)
  Remarques :
    - Les clés restent inchangées pour compatibilité.
    - Les placeholders (%s, %n, %i) sont conservés.
    - Traduction en français neutre, adaptée pour serveurs.
]]

local LANGUAGE_CODE = "FR"
local LANGUAGE_NAME = "Français"

local L = AWarn and AWarn.Localization
if not L then
  AWarn = AWarn or {}
  AWarn.Localization = AWarn.Localization or {
    Languages = {},
    LangCodes = {},
    RegisterLanguage = function(self, code, name)
      self.Languages[code] = self.Languages[code] or {}
      self.LangCodes[code] = name
    end,
    AddDefinition = function(self, code, key, value)
      self.Languages[code] = self.Languages[code] or {}
      self.Languages[code][key] = value
    end
  }
  L = AWarn.Localization
end

L:RegisterLanguage(LANGUAGE_CODE, LANGUAGE_NAME)

local defs = {
  welcome1 = "Bienvenue sur AWarn3 !",
  insufficientperms = "Permissions insuffisantes pour exécuter cette commande.",
  insufficientperms2 = "Permissions insuffisantes pour voir les avertissements de ce joueur.",
  commandnonexist = "Cette commande n'existe pas.",
  invalidtargetid = "Cible ou ID invalide.",
  invalidtarget = "Cible invalide.",
  reasonrequired = "Une raison est obligatoire pour l'avertissement.",
  remove1activewarn = "Vous avez supprimé 1 avertissement actif de",
  deletedwarningid = "ID d'avertissement supprimé",
  removeallwarnings = "Vous avez supprimé tous les avertissements de",
  deletedwarningsfor = "Tous les avertissements supprimés pour",
  cantopenconsole = "Vous ne pouvez pas ouvrir le menu depuis la console du serveur.",
  invalidoption = "Option invalide.",
  invalidoptionvaluetype = "Type de valeur d'option invalide.",
  optionsloaded = "Options chargées !",
  nopunishment = "Aucune sanction pour ce nombre d'avertissements.",
  punishmentsloaded = "Sanctions chargées !",
  playernotallowedwarn = "Ce joueur ne peut pas être averti.",
  warnmessage1 = "Vous avez été averti par %s pour %s.",
  warnmessage2 = "Vous avez averti %s pour %s.",
  warnmessage3 = "%s a été averti par %s pour %s.",
  warnmessage4 = "Vous avez été averti par %s.",
  warnmessage5 = "Vous avez averti %s.",
  warnmessage6 = "%s a été averti par %s.",
  joinmessage1 = "a rejoint le serveur avec des avertissements.",
  joinmessage2 = "Son dernier avertissement date du :",
  joinmessage3 = "Bienvenue à nouveau ! Il semble que vous ayez déjà été averti.",
  joinmessage4 = "Vous pouvez consulter vos avertissements à tout moment en tapant",
  joinmessage5 = "Joueur rejoignant avec des avertissements actifs :",
  closemenu = "Fermer le Menu",
  searchplayers = "Rechercher des Joueurs",
  viewwarnings = "Avertissements",
  configuration = "Configuration",
  clientoptions = "Options Utilisateur",
  serveroptions = "Options Serveur",
  colorcustomization = "Personnalisation des Couleurs",
  colorselection = "Sélection de Couleur",
  languageconfiguration = "Personnalisation de la Langue",
  selectlanguage = "Choisir une Langue",
  enablekickpunish = "Activer la Sanction de Kick",
  enablebanpunish = "Activer la Sanction de Bannissement",
  enabledecay = "Activer la Décroissance des Avertissements Actifs",
  resetafterban = "Réinitialiser les avertissements actifs après un bannissement",
  allowwarnadmins = "Autoriser l'avertissement des Admins",
  clientjoinmessage = "Afficher le nombre d'avertissements au joueur à la connexion",
  adminjoinmessage = "Afficher un message aux admins quand un joueur rejoint avec des avertissements",
  pressenter = "Appuyez sur Entrée pour enregistrer",
  entertosave = "Entrée pour Sauvegarder",
  chatprefix = "Préfixe de Chat",
  warningdecayrate = "Taux de Décroissance des Avertissements",
  serverlanguage = "Langue du Serveur",
  punishmentsconfiguration = "Configuration des Sanctions",
  addpunishment = "Ajouter une Sanction",
  warnings = "Avertissements",
  punishtype = "Type de Sanction",
  punishlength = "Durée de la Sanction",
  playermessage = "Message au Joueur",
  playername = "Nom du Joueur",
  messagetoplayer = "Message au Joueur",
  servermessage = "Message du Serveur",
  messagetoserver = "Message au Serveur",
  deletewarning = "Supprimer l'Avertissement",
  punishaddmenu = "Menu d'Ajout de Sanction",
  inminutes = "En Minutes",
  ["0equalperma"] = "0 = Permanent",
  ["use%"] = "Utilisez %%s pour afficher le nom du joueur",
  setdefault = "Définir par Défaut",
  showingownwarnings = "Affichage de vos propres avertissements",
  warnedby = "Averti Par",
  warningserver = "Serveur de l'Avertissement",
  warningreason = "Raison de l'Avertissement",
  warningdate = "Date de l'Avertissement",
  nothing = "RIEN",
  submit = "Valider",
  connectedplayers = "Joueurs Connectés",
  displaywarningsfor = "Affichage des Avertissements de",
  activewarnings = "Avertissements Actifs",
  selectedplayernowarnings = "Le joueur sélectionné n'a aucun avertissement enregistré.",
  selectplayerseewarnings = "Sélectionnez un joueur pour voir ses avertissements.",
  warnplayer = "Avertir le Joueur",
  reduceactiveby1 = "Réduire les avertissements actifs de 1",
  playerwarningmenu = "Menu d'Avertissement du Joueur",
  playersearchmenu = "Menu de Recherche de Joueurs",
  warningplayer = "Avertissement du Joueur",
  excludeplayers = "Exclure les joueurs sans historique d'avertissements",
  searchforplayers = "Rechercher des joueurs par nom ou SteamID64",
  name = "Nom",
  lastplayed = "Dernière Partie",
  lastwarned = "Dernier Avertissement",
  never = "Jamais",
  playerid = "ID du Joueur",
  lookupplayerwarnings = "Voir les avertissements de ce joueur",
  servername = "Nom du Serveur",
  punishmentoptions = "Sanctions",
  kickpunishdescription = "Si activé, AWarn3 peut expulser les joueurs comme sanction.",
  banpunishdescription = "Si activé, AWarn3 peut bannir les joueurs comme sanction.",
  enabledecaydescription = "Si activé, les avertissements actifs disparaîtront avec le temps.",
  reasonrequireddescription = "Si activé, les admins devront fournir une raison lors d'un avertissement.",
  resetafterbandescription = "Si activé, les avertissements actifs d'un joueur seront remis à 0 après un bannissement par AWarn3.",
  logevents = "Enregistrer les Événements",
  logeventsdescription = "Si activé, les actions dans AWarn3 seront enregistrées dans un fichier texte.",
  allowwarnadminsdescription = "Si activé, les admins pourront avertir d'autres admins.",
  clientjoinmessagedescription = "Si activé, les joueurs verront un message dans le chat à la connexion s'ils ont des avertissements.",
  adminjoinmessagedescription = "Si activé, les admins verront lorsqu'un joueur ayant des avertissements rejoint.",
  chatprefixdescription = "Le préfixe de commande de chat pour AWarn3. Par défaut : !warn",
  warningdecayratedescription = "Le temps (en minutes) qu'un joueur doit rester connecté pour qu'un avertissement actif disparaisse.",
  servernamedescription = "Le nom de ce serveur. Utile pour les configurations multi-serveurs.",
  selectlanguagedescription = "La langue dans laquelle les messages du serveur seront affichés.",
  theme = "Thème de l'Interface",
  themeselect = "Choisir un Thème",
  punishgroup = "Groupe de Sanction",
  grouptoset = "Groupe à Attribuer",
  viewnotes = "Voir les Notes du Joueur",
  playernotes = "Notes du Joueur",
  interfacecustomizations = "Personnalisations de l'Interface",
  enableblur = "Activer le Flou d'Arrière-plan",
  chooseapreset = "Choisissez un preset (optionnel)",
  warningpresets = "Presets",
  addeditpreset = "Ajouter/Modifier un Preset",
  presetname = "Nom du Preset",
  presetreason = "Raison du Preset",
  customcommand = "Commande Personnalisée",
  customcommandplaceholder = "Remplacements — %n: Nom du Joueur, %s: SteamID, %i: SteamID64",
  confirm = "Confirmer",
  cancel = "Annuler",
  deleteconfirmdialogue1 = "Confirmer la Suppression de Tous les Avertissements",
  deleteconfirmdialogue2 = "Vous êtes sur le point de supprimer tous les avertissements de ce joueur.",
  deleteconfirmdialogue3 = "Veuillez confirmer cette action.",
  removewhendeletewarning = "Supprimer une avertissement actif lors de la suppression",
  removewhendeletewarningdescription = "Si activé, 1 avertissement actif sera supprimé lorsqu'un avertissement est supprimé.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
