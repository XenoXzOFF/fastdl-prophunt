--[[
  AWarn3 Localization: NL-NL (Nederlands)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Dutch translation.
]]

local LANGUAGE_CODE = "NL"
local LANGUAGE_NAME = "Nederlands"

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
  welcome1 = "Welkom bij AWarn3!",
  insufficientperms = "Onvoldoende rechten om dit commando uit te voeren.",
  insufficientperms2 = "Onvoldoende rechten om de waarschuwingen van deze speler te bekijken.",
  commandnonexist = "Dit commando bestaat niet.",
  invalidtargetid = "Ongeldig doel of ID.",
  invalidtarget = "Ongeldig doel.",
  reasonrequired = "Een reden voor de waarschuwing is verplicht.",
  remove1activewarn = "Je hebt 1 actieve waarschuwing verwijderd van",
  deletedwarningid = "Verwijderde waarschuwing ID",
  removeallwarnings = "Je hebt alle waarschuwingen verwijderd van",
  deletedwarningsfor = "Alle waarschuwingen verwijderd voor",
  cantopenconsole = "Je kunt het menu niet openen vanuit de serverconsole.",
  invalidoption = "Ongeldige optie.",
  invalidoptionvaluetype = "Ongeldig optiewaarde-type.",
  optionsloaded = "Opties geladen!",
  nopunishment = "Geen straf voor dit aantal waarschuwingen.",
  punishmentsloaded = "Straffen geladen!",
  playernotallowedwarn = "Deze speler kan niet worden gewaarschuwd.",
  warnmessage1 = "Je bent gewaarschuwd door %s voor %s.",
  warnmessage2 = "Je hebt %s gewaarschuwd voor %s.",
  warnmessage3 = "%s is gewaarschuwd door %s voor %s.",
  warnmessage4 = "Je bent gewaarschuwd door %s.",
  warnmessage5 = "Je hebt %s gewaarschuwd.",
  warnmessage6 = "%s is gewaarschuwd door %s.",
  joinmessage1 = "is de server binnengekomen met waarschuwingen.",
  joinmessage2 = "Zijn laatste waarschuwing was op:",
  joinmessage3 = "Welkom terug! Het lijkt erop dat je in het verleden gewaarschuwd bent.",
  joinmessage4 = "Je kunt je waarschuwingen op elk moment bekijken door te typen",
  joinmessage5 = "Speler komt binnen met actieve waarschuwingen:",
  closemenu = "Menu Sluiten",
  searchplayers = "Spelers Zoeken",
  viewwarnings = "Waarschuwingen",
  configuration = "Configuratie",
  clientoptions = "Gebruikersopties",
  serveroptions = "Serveropties",
  colorcustomization = "Kleuraanpassing",
  colorselection = "Kleurselectie",
  languageconfiguration = "Taalinstellingen",
  selectlanguage = "Selecteer een Taal",
  enablekickpunish = "Kick-straf inschakelen",
  enablebanpunish = "Ban-straf inschakelen",
  enabledecay = "Actieve waarschuwingen laten vervallen",
  resetafterban = "Actieve waarschuwingen resetten na ban",
  allowwarnadmins = "Admins mogen waarschuwen",
  clientjoinmessage = "Aantal waarschuwingen tonen aan speler bij joinen",
  adminjoinmessage = "Bericht tonen aan admins wanneer speler joinen met waarschuwingen",
  pressenter = "Druk op Enter om op te slaan",
  entertosave = "Enter om op te slaan",
  chatprefix = "Chatvoorvoegsel",
  warningdecayrate = "Waarschuwing-vervaltempo",
  serverlanguage = "Servertaal",
  punishmentsconfiguration = "Straffen Configuratie",
  addpunishment = "Straf Toevoegen",
  warnings = "Waarschuwingen",
  punishtype = "Straftype",
  punishlength = "Straftijd",
  playermessage = "Bericht aan Speler",
  playername = "Spelernaam",
  messagetoplayer = "Bericht aan Speler",
  servermessage = "Serverbericht",
  messagetoserver = "Bericht aan Server",
  deletewarning = "Waarschuwing Verwijderen",
  punishaddmenu = "Straf Toevoegen Menu",
  inminutes = "In Minuten",
  ["0equalperma"] = "0 = Permanent",
  ["use%"] = "Gebruik %%s om de spelernaam te tonen",
  setdefault = "Instellen als Standaard",
  showingownwarnings = "Eigen waarschuwingen weergeven",
  warnedby = "Gewaarschuwd door",
  warningserver = "Waarschuwing Server",
  warningreason = "Reden van Waarschuwing",
  warningdate = "Datum van Waarschuwing",
  nothing = "NIETS",
  submit = "Bevestigen",
  connectedplayers = "Verbonden Spelers",
  displaywarningsfor = "Waarschuwingen weergeven voor",
  activewarnings = "Actieve Waarschuwingen",
  selectedplayernowarnings = "Geselecteerde speler heeft geen waarschuwingen.",
  selectplayerseewarnings = "Selecteer een speler om zijn waarschuwingen te bekijken.",
  warnplayer = "Speler Waarschuwen",
  reduceactiveby1 = "Actieve waarschuwingen met 1 verminderen",
  playerwarningmenu = "Speler Waarschuwingsmenu",
  playersearchmenu = "Speler Zoekmenu",
  warningplayer = "Speler Waarschuwen",
  excludeplayers = "Spelers zonder waarschuwingen uitsluiten",
  searchforplayers = "Zoek spelers op naam of SteamID64",
  name = "Naam",
  lastplayed = "Laatst Gespeeld",
  lastwarned = "Laatst Gewaarschuwd",
  never = "Nooit",
  playerid = "Speler ID",
  lookupplayerwarnings = "Waarschuwingen van deze speler bekijken",
  servername = "Servernaam",
  punishmentoptions = "Straffen",
  kickpunishdescription = "Indien ingeschakeld kan AWarn3 spelers van de server kicken als straf.",
  banpunishdescription = "Indien ingeschakeld kan AWarn3 spelers van de server bannen als straf.",
  enabledecaydescription = "Indien ingeschakeld zullen actieve waarschuwingen na verloop van tijd vervallen.",
  reasonrequireddescription = "Indien ingeschakeld moeten admins een reden opgeven bij het geven van een waarschuwing.",
  resetafterbandescription = "Indien ingeschakeld worden de actieve waarschuwingen van een speler na een ban door AWarn3 gereset naar 0.",
  logevents = "Waarschuwing Gebeurtenissen Loggen",
  logeventsdescription = "Indien ingeschakeld worden acties binnen AWarn3 gelogd in een tekstbestand.",
  allowwarnadminsdescription = "Indien ingeschakeld kunnen admins andere admins waarschuwen.",
  clientjoinmessagedescription = "Indien ingeschakeld zien gebruikers bij joinen een bericht in de chat als ze waarschuwingen hebben.",
  adminjoinmessagedescription = "Indien ingeschakeld zien admins wanneer een speler met waarschuwingen joint.",
  chatprefixdescription = "Het chatcommando dat wordt gebruikt voor AWarn3-commando’s. Standaard: !warn",
  warningdecayratedescription = "De tijd (in minuten) dat een speler verbonden moet zijn voor 1 actieve waarschuwing vervalt.",
  servernamedescription = "De naam van deze server. Handig voor meerdere serveropstellingen.",
  selectlanguagedescription = "Dit is de taal waarin serverberichten worden weergegeven.",
  theme = "Interface Thema",
  themeselect = "Selecteer Thema",
  punishgroup = "Strafgroep",
  grouptoset = "Groep om in te stellen",
  viewnotes = "Bekijk Spelernotities",
  playernotes = "Spelernotities",
  interfacecustomizations = "Interface Aanpassingen",
  enableblur = "Achtergrond Vervaging Inschakelen",
  chooseapreset = "Kies een preset (Optioneel)",
  warningpresets = "Presets",
  addeditpreset = "Preset Toevoegen/Bewerken",
  presetname = "Presetnaam",
  presetreason = "Presetreden",
  customcommand = "Aangepast Commando",
  customcommandplaceholder = "Vervangingen — %n: Spelernaam, %s: SteamID, %i: SteamID64",
  confirm = "Bevestigen",
  cancel = "Annuleren",
  deleteconfirmdialogue1 = "Bevestig Verwijdering van Alle Waarschuwingen",
  deleteconfirmdialogue2 = "Je staat op het punt alle waarschuwingen van deze speler te verwijderen.",
  deleteconfirmdialogue3 = "Bevestig deze actie alstublieft.",
  removewhendeletewarning = "Actieve waarschuwing verwijderen bij verwijderen van waarschuwing",
  removewhendeletewarningdescription = "Indien ingeschakeld wordt 1 actieve waarschuwing verwijderd wanneer een waarschuwing wordt verwijderd.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
