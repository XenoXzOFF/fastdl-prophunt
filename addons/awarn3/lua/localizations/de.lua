--[[
  AWarn3 Localization: DE-DE (Deutsch)
  Hinweise:
    - Schlüssel bleiben identisch für Kompatibilität.
    - Platzhalter (%s, %n, %i) bleiben erhalten.
    - Neutrales Deutsch, passend für Serversprache.
]]

local LANGUAGE_CODE = "DE"
local LANGUAGE_NAME = "Deutsch"

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
  welcome1 = "Willkommen bei AWarn3!",
  insufficientperms = "Unzureichende Berechtigungen, um diesen Befehl auszuführen.",
  insufficientperms2 = "Unzureichende Berechtigungen, um die Verwarnungen dieses Spielers einzusehen.",
  commandnonexist = "Dieser Befehl existiert nicht.",
  invalidtargetid = "Ungültiges Ziel oder ID.",
  invalidtarget = "Ungültiges Ziel.",
  reasonrequired = "Ein Grund für die Verwarnung ist erforderlich.",
  remove1activewarn = "Du hast 1 aktive Verwarnung entfernt von",
  deletedwarningid = "Verwarnungs-ID gelöscht",
  removeallwarnings = "Du hast alle Verwarnungen entfernt von",
  deletedwarningsfor = "Alle Verwarnungen gelöscht für",
  cantopenconsole = "Das Menü kann nicht von der Serverkonsole geöffnet werden.",
  invalidoption = "Ungültige Option.",
  invalidoptionvaluetype = "Ungültiger Werttyp für Option.",
  optionsloaded = "Optionen geladen!",
  nopunishment = "Keine Strafe für diese Anzahl an Verwarnungen.",
  punishmentsloaded = "Strafen geladen!",
  playernotallowedwarn = "Dieser Spieler darf nicht verwarnt werden.",
  warnmessage1 = "Du wurdest von %s verwarnt wegen %s.",
  warnmessage2 = "Du hast %s verwarnt wegen %s.",
  warnmessage3 = "%s wurde von %s verwarnt wegen %s.",
  warnmessage4 = "Du wurdest von %s verwarnt.",
  warnmessage5 = "Du hast %s verwarnt.",
  warnmessage6 = "%s wurde von %s verwarnt.",
  joinmessage1 = "ist dem Server mit Verwarnungen beigetreten.",
  joinmessage2 = "Seine letzte Verwarnung war am:",
  joinmessage3 = "Willkommen zurück! Es scheint, dass du zuvor verwarnt wurdest.",
  joinmessage4 = "Du kannst deine Verwarnungen jederzeit einsehen mit",
  joinmessage5 = "Spieler tritt mit aktiven Verwarnungen bei:",
  closemenu = "Menü schließen",
  searchplayers = "Spieler suchen",
  viewwarnings = "Verwarnungen",
  configuration = "Konfiguration",
  clientoptions = "Benutzeroptionen",
  serveroptions = "Serveroptionen",
  colorcustomization = "Farbanpassung",
  colorselection = "Farbauswahl",
  languageconfiguration = "Spracheinstellungen",
  selectlanguage = "Sprache auswählen",
  enablekickpunish = "Kick-Strafe aktivieren",
  enablebanpunish = "Ban-Strafe aktivieren",
  enabledecay = "Aktive Verwarnungen automatisch abbauen",
  resetafterban = "Aktive Verwarnungen nach Bann zurücksetzen",
  allowwarnadmins = "Admins dürfen verwarnt werden",
  clientjoinmessage = "Spieler beim Beitritt über Verwarnungen informieren",
  adminjoinmessage = "Admins benachrichtigen, wenn Spieler mit Verwarnungen beitreten",
  pressenter = "Drücke Enter, um zu speichern",
  entertosave = "Enter zum Speichern",
  chatprefix = "Chat-Präfix",
  warningdecayrate = "Rate des Verwarnungsabbaus",
  serverlanguage = "Serversprache",
  punishmentsconfiguration = "Strafkonfiguration",
  addpunishment = "Strafe hinzufügen",
  warnings = "Verwarnungen",
  punishtype = "Strafart",
  punishlength = "Strafdauer",
  playermessage = "Nachricht an Spieler",
  playername = "Spielername",
  messagetoplayer = "Nachricht an Spieler",
  servermessage = "Servernachricht",
  messagetoserver = "Nachricht an Server",
  deletewarning = "Verwarnung löschen",
  punishaddmenu = "Strafe hinzufügen",
  inminutes = "In Minuten",
  ["0equalperma"] = "0 = Permanent",
  ["use%"] = "Verwende %%s, um den Spielernamen anzuzeigen",
  setdefault = "Als Standard festlegen",
  showingownwarnings = "Eigene Verwarnungen anzeigen",
  warnedby = "Verwarnt von",
  warningserver = "Server der Verwarnung",
  warningreason = "Verwarnungsgrund",
  warningdate = "Verwarnungsdatum",
  nothing = "NICHTS",
  submit = "Bestätigen",
  connectedplayers = "Verbundene Spieler",
  displaywarningsfor = "Verwarnungen anzeigen für",
  activewarnings = "Aktive Verwarnungen",
  selectedplayernowarnings = "Der ausgewählte Spieler hat keine Verwarnungen.",
  selectplayerseewarnings = "Wähle einen Spieler, um seine Verwarnungen zu sehen.",
  warnplayer = "Spieler verwarnen",
  reduceactiveby1 = "Aktive Verwarnungen um 1 reduzieren",
  playerwarningmenu = "Spielerverwarnungsmenü",
  playersearchmenu = "Spielersuchmenü",
  warningplayer = "Spieler verwarnen",
  excludeplayers = "Spieler ohne Verwarnungen ausblenden",
  searchforplayers = "Suche Spieler nach Name oder SteamID64",
  name = "Name",
  lastplayed = "Zuletzt gespielt",
  lastwarned = "Zuletzt verwarnt",
  never = "Nie",
  playerid = "Spieler-ID",
  lookupplayerwarnings = "Verwarnungen dieses Spielers anzeigen",
  servername = "Servername",
  punishmentoptions = "Strafen",
  kickpunishdescription = "Wenn aktiviert, kann AWarn3 Spieler als Strafe vom Server kicken.",
  banpunishdescription = "Wenn aktiviert, kann AWarn3 Spieler als Strafe bannen.",
  enabledecaydescription = "Wenn aktiviert, bauen sich aktive Verwarnungen mit der Zeit ab.",
  reasonrequireddescription = "Wenn aktiviert, müssen Admins beim Verwarnen einen Grund angeben.",
  resetafterbandescription = "Wenn aktiviert, werden die aktiven Verwarnungen nach einem Bann durch AWarn3 auf 0 zurückgesetzt.",
  logevents = "Verwarnungsereignisse protokollieren",
  logeventsdescription = "Wenn aktiviert, werden Aktionen von AWarn3 in einer Textdatei protokolliert.",
  allowwarnadminsdescription = "Wenn aktiviert, können Admins andere Admins verwarnen.",
  clientjoinmessagedescription = "Wenn aktiviert, sehen Spieler beim Beitritt eine Chatnachricht, wenn sie Verwarnungen haben.",
  adminjoinmessagedescription = "Wenn aktiviert, sehen Admins, wenn Spieler mit Verwarnungen beitreten.",
  chatprefixdescription = "Das Chat-Kommando für AWarn3-Befehle. Standard: !warn",
  warningdecayratedescription = "Die Zeit (in Minuten), die ein Spieler verbunden sein muss, damit eine Verwarnung abgebaut wird.",
  servernamedescription = "Der Name dieses Servers. Nützlich für mehrere Server.",
  selectlanguagedescription = "Die Sprache, in der Servernachrichten angezeigt werden.",
  theme = "Interface-Theme",
  themeselect = "Theme auswählen",
  punishgroup = "Strafgruppe",
  grouptoset = "Zu setzende Gruppe",
  viewnotes = "Spielernotizen anzeigen",
  playernotes = "Spielernotizen",
  interfacecustomizations = "Interface-Anpassungen",
  enableblur = "Hintergrundunschärfe aktivieren",
  chooseapreset = "Preset auswählen (optional)",
  warningpresets = "Presets",
  addeditpreset = "Preset hinzufügen/bearbeiten",
  presetname = "Preset-Name",
  presetreason = "Preset-Grund",
  customcommand = "Benutzerdefinierter Befehl",
  customcommandplaceholder = "Ersetzungen — %n: Spielername, %s: SteamID, %i: SteamID64",
  confirm = "Bestätigen",
  cancel = "Abbrechen",
  deleteconfirmdialogue1 = "Löschen aller Verwarnungen bestätigen",
  deleteconfirmdialogue2 = "Du bist dabei, alle Verwarnungen dieses Spielers zu löschen.",
  deleteconfirmdialogue3 = "Bitte bestätige diese Aktion.",
  removewhendeletewarning = "Aktive Verwarnung beim Löschen entfernen",
  removewhendeletewarningdescription = "Wenn aktiviert, wird 1 aktive Verwarnung entfernt, wenn eine Verwarnung gelöscht wird.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
