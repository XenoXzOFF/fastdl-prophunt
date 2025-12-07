--[[
  AWarn3 Localization: NO-NB (Norsk Bokmål)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Norwegian Bokmål translation.
]]

local LANGUAGE_CODE = "NO-NB"
local LANGUAGE_NAME = "Norsk Bokmål"

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
  welcome1 = "Velkommen til AWarn3!",
  insufficientperms = "Du har ikke tillatelse til å kjøre denne kommandoen.",
  insufficientperms2 = "Du har ikke tillatelse til å se advarslene til denne spilleren.",
  commandnonexist = "Denne kommandoen finnes ikke.",
  invalidtargetid = "Ugyldig mål eller ID.",
  invalidtarget = "Ugyldig mål.",
  reasonrequired = "En grunn er påkrevd for advarselen.",
  remove1activewarn = "Du fjernet 1 aktiv advarsel fra",
  deletedwarningid = "Slettet advarsel-ID",
  removeallwarnings = "Du fjernet alle advarsler fra",
  deletedwarningsfor = "Alle advarsler slettet for",
  cantopenconsole = "Du kan ikke åpne menyen fra serverkonsollen.",
  invalidoption = "Ugyldig alternativ.",
  invalidoptionvaluetype = "Ugyldig verditype for alternativ.",
  optionsloaded = "Alternativer lastet!",
  nopunishment = "Ingen straff for dette antallet advarsler.",
  punishmentsloaded = "Straffer lastet!",
  playernotallowedwarn = "Denne spilleren kan ikke advares.",
  warnmessage1 = "Du ble advart av %s for %s.",
  warnmessage2 = "Du advarte %s for %s.",
  warnmessage3 = "%s ble advart av %s for %s.",
  warnmessage4 = "Du ble advart av %s.",
  warnmessage5 = "Du advarte %s.",
  warnmessage6 = "%s ble advart av %s.",
  joinmessage1 = "har blitt med på serveren med advarsler.",
  joinmessage2 = "Deres siste advarsel var den:",
  joinmessage3 = "Velkommen tilbake! Det ser ut til at du har blitt advart tidligere.",
  joinmessage4 = "Du kan se advarslene dine når som helst ved å skrive",
  joinmessage5 = "Spiller blir med med aktive advarsler:",
  closemenu = "Lukk Meny",
  searchplayers = "Søk Spillere",
  viewwarnings = "Advarsler",
  configuration = "Konfigurasjon",
  clientoptions = "Brukervalg",
  serveroptions = "Servervalg",
  colorcustomization = "Fargetilpasning",
  colorselection = "Fargevalg",
  languageconfiguration = "Språkinnstillinger",
  selectlanguage = "Velg Språk",
  enablekickpunish = "Aktiver Kick-straff",
  enablebanpunish = "Aktiver Ban-straff",
  enabledecay = "Aktiver nedbygging av aktive advarsler",
  resetafterban = "Tilbakestill aktive advarsler etter Ban",
  allowwarnadmins = "Tillat å advare administratorer",
  clientjoinmessage = "Vis antall advarsler til spilleren ved innlogging",
  adminjoinmessage = "Vis melding til administratorer når spiller blir med med advarsler",
  pressenter = "Trykk Enter for å lagre",
  entertosave = "Enter for å lagre",
  chatprefix = "Chat-prefiks",
  warningdecayrate = "Nedbyggingsrate for advarsler",
  serverlanguage = "Serverspråk",
  punishmentsconfiguration = "Straffekonfigurasjon",
  addpunishment = "Legg til Straff",
  warnings = "Advarsler",
  punishtype = "Straffetype",
  punishlength = "Straffelengde",
  playermessage = "Melding til Spiller",
  playername = "Spillernavn",
  messagetoplayer = "Melding til Spiller",
  servermessage = "Servermelding",
  messagetoserver = "Melding til Server",
  deletewarning = "Slett Advarsel",
  punishaddmenu = "Meny for å Legge til Straff",
  inminutes = "I Minutter",
  ["0equalperma"] = "0 = Permanent",
  ["use%"] = "Bruk %%s for å vise spillernavnet",
  setdefault = "Sett som Standard",
  showingownwarnings = "Viser dine egne advarsler",
  warnedby = "Advart Av",
  warningserver = "Advarselsserver",
  warningreason = "Advarselsgrunn",
  warningdate = "Advarselsdato",
  nothing = "INGENTING",
  submit = "Bekreft",
  connectedplayers = "Tilkoblede Spillere",
  displaywarningsfor = "Viser Advarsler for",
  activewarnings = "Aktive Advarsler",
  selectedplayernowarnings = "Den valgte spilleren har ingen registrerte advarsler.",
  selectplayerseewarnings = "Velg en spiller for å se advarslene deres.",
  warnplayer = "Advar Spiller",
  reduceactiveby1 = "Reduser aktive advarsler med 1",
  playerwarningmenu = "Spilleradvarselsmeny",
  playersearchmenu = "Spillersøk-meny",
  warningplayer = "Advarer Spiller",
  excludeplayers = "Ekskluder spillere uten advarsler",
  searchforplayers = "Søk etter spillere etter navn eller SteamID64",
  name = "Navn",
  lastplayed = "Sist Spilt",
  lastwarned = "Sist Advart",
  never = "Aldri",
  playerid = "Spiller-ID",
  lookupplayerwarnings = "Se advarslene til denne spilleren",
  servername = "Servernavn",
  punishmentoptions = "Straffer",
  kickpunishdescription = "Hvis aktivert, kan AWarn3 kaste spillere ut som straff.",
  banpunishdescription = "Hvis aktivert, kan AWarn3 banne spillere som straff.",
  enabledecaydescription = "Hvis aktivert, vil aktive advarsler forsvinne over tid.",
  reasonrequireddescription = "Hvis aktivert, må administratorer oppgi en grunn når de advarer.",
  resetafterbandescription = "Hvis aktivert, vil en brukers aktive advarsler settes til 0 etter å ha blitt bannet av AWarn3.",
  logevents = "Logg Advarselsaktiviteter",
  logeventsdescription = "Hvis aktivert, vil handlinger i AWarn3 bli logget til en tekstfil.",
  allowwarnadminsdescription = "Hvis aktivert, kan administratorer advare andre administratorer.",
  clientjoinmessagedescription = "Hvis aktivert, vil brukere som blir med på serveren se en melding i chat hvis de har advarsler.",
  adminjoinmessagedescription = "Hvis aktivert, vil administratorer se når en spiller med advarsler blir med.",
  chatprefixdescription = "Chat-kommandoen brukt for AWarn3-kommandoer. Standard: !warn",
  warningdecayratedescription = "Tiden (i minutter) en spiller må være tilkoblet for at én aktiv advarsel skal forsvinne.",
  servernamedescription = "Navnet på denne serveren. Nyttig for flere-server-oppsett.",
  selectlanguagedescription = "Dette er språket servermeldinger vil vises i.",
  theme = "Grensesnitt-tema",
  themeselect = "Velg Tema",
  punishgroup = "Straffegruppe",
  grouptoset = "Gruppe som skal settes",
  viewnotes = "Vis Spillernotater",
  playernotes = "Spillernotater",
  interfacecustomizations = "Grensesnitt-tilpasninger",
  enableblur = "Aktiver Bakgrunnsuskarphet",
  chooseapreset = "Velg et preset (valgfritt)",
  warningpresets = "Presets",
  addeditpreset = "Legg til/Rediger Preset",
  presetname = "Preset-navn",
  presetreason = "Preset-grunn",
  customcommand = "Egendefinert Kommando",
  customcommandplaceholder = "Erstatninger — %n: Spillernavn, %s: SteamID, %i: SteamID64",
  confirm = "Bekreft",
  cancel = "Avbryt",
  deleteconfirmdialogue1 = "Bekreft sletting av alle advarsler",
  deleteconfirmdialogue2 = "Du er i ferd med å slette alle advarsler for denne spilleren.",
  deleteconfirmdialogue3 = "Vennligst bekreft denne handlingen.",
  removewhendeletewarning = "Fjern aktiv advarsel når en advarsel slettes",
  removewhendeletewarningdescription = "Hvis aktivert, fjernes 1 aktiv advarsel når en advarsel slettes.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
