--[[
  AWarn3 Localization: IT-IT (Italiano)
  Note:
    - Le chiavi restano identiche per compatibilità.
    - I placeholder (%s, %n, %i) sono mantenuti.
    - Traduzione in italiano neutro, adatta per server.
]]

local LANGUAGE_CODE = "IT"
local LANGUAGE_NAME = "Italiano"

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
  welcome1 = "Benvenuto in AWarn3!",
  insufficientperms = "Permessi insufficienti per eseguire questo comando.",
  insufficientperms2 = "Permessi insufficienti per visualizzare gli avvertimenti di questo giocatore.",
  commandnonexist = "Questo comando non esiste.",
  invalidtargetid = "ID o bersaglio non valido.",
  invalidtarget = "Bersaglio non valido.",
  reasonrequired = "È necessario fornire una motivazione per l'avvertimento.",
  remove1activewarn = "Hai rimosso 1 avvertimento attivo da",
  deletedwarningid = "ID avvertimento eliminato",
  removeallwarnings = "Hai rimosso tutti gli avvertimenti da",
  deletedwarningsfor = "Tutti gli avvertimenti eliminati per",
  cantopenconsole = "Non puoi aprire il menu dalla console del server.",
  invalidoption = "Opzione non valida.",
  invalidoptionvaluetype = "Tipo di valore dell'opzione non valido.",
  optionsloaded = "Opzioni caricate!",
  nopunishment = "Nessuna punizione per questo numero di avvertimenti.",
  punishmentsloaded = "Punizioni caricate!",
  playernotallowedwarn = "Questo giocatore non può essere avvertito.",
  warnmessage1 = "Sei stato avvertito da %s per %s.",
  warnmessage2 = "Hai avvertito %s per %s.",
  warnmessage3 = "%s è stato avvertito da %s per %s.",
  warnmessage4 = "Sei stato avvertito da %s.",
  warnmessage5 = "Hai avvertito %s.",
  warnmessage6 = "%s è stato avvertito da %s.",
  joinmessage1 = "è entrato nel server con avvertimenti.",
  joinmessage2 = "Il suo ultimo avvertimento risale al:",
  joinmessage3 = "Bentornato sul server! Sembra che tu sia già stato avvertito.",
  joinmessage4 = "Puoi vedere i tuoi avvertimenti in qualsiasi momento digitando",
  joinmessage5 = "Giocatore in entrata con avvertimenti attivi:",
  closemenu = "Chiudi Menu",
  searchplayers = "Cerca Giocatori",
  viewwarnings = "Avvertimenti",
  configuration = "Configurazione",
  clientoptions = "Opzioni Utente",
  serveroptions = "Opzioni Server",
  colorcustomization = "Personalizzazione Colori",
  colorselection = "Selezione Colore",
  languageconfiguration = "Impostazioni Lingua",
  selectlanguage = "Seleziona una Lingua",
  enablekickpunish = "Abilita Punizione Kick",
  enablebanpunish = "Abilita Punizione Ban",
  enabledecay = "Abilita Decadimento Avvertimenti Attivi",
  resetafterban = "Reimposta avvertimenti attivi dopo il Ban",
  allowwarnadmins = "Permetti di avvertire gli Admin",
  clientjoinmessage = "Mostra il numero di avvertimenti al giocatore all'accesso",
  adminjoinmessage = "Mostra messaggio agli admin quando un giocatore entra con avvertimenti",
  pressenter = "Premi Invio per salvare",
  entertosave = "Invio per Salvare",
  chatprefix = "Prefisso Chat",
  warningdecayrate = "Tasso di Decadimento Avvertimenti",
  serverlanguage = "Lingua del Server",
  punishmentsconfiguration = "Configurazione Punizioni",
  addpunishment = "Aggiungi Punizione",
  warnings = "Avvertimenti",
  punishtype = "Tipo di Punizione",
  punishlength = "Durata della Punizione",
  playermessage = "Messaggio al Giocatore",
  playername = "Nome del Giocatore",
  messagetoplayer = "Messaggio al Giocatore",
  servermessage = "Messaggio del Server",
  messagetoserver = "Messaggio al Server",
  deletewarning = "Elimina Avvertimento",
  punishaddmenu = "Menu Aggiunta Punizione",
  inminutes = "In Minuti",
  ["0equalperma"] = "0 = Permanente",
  ["use%"] = "Usa %%s per mostrare il nome del giocatore",
  setdefault = "Imposta come Predefinito",
  showingownwarnings = "Mostrando i tuoi avvertimenti",
  warnedby = "Avvertito Da",
  warningserver = "Server dell'Avvertimento",
  warningreason = "Motivo dell'Avvertimento",
  warningdate = "Data dell'Avvertimento",
  nothing = "NULLA",
  submit = "Conferma",
  connectedplayers = "Giocatori Connessi",
  displaywarningsfor = "Mostrando Avvertimenti per",
  activewarnings = "Avvertimenti Attivi",
  selectedplayernowarnings = "Il giocatore selezionato non ha avvertimenti registrati.",
  selectplayerseewarnings = "Seleziona un giocatore per vedere i suoi avvertimenti.",
  warnplayer = "Avverti Giocatore",
  reduceactiveby1 = "Riduci gli avvertimenti attivi di 1",
  playerwarningmenu = "Menu Avvertimenti Giocatore",
  playersearchmenu = "Menu Ricerca Giocatori",
  warningplayer = "Avvertendo Giocatore",
  excludeplayers = "Escludi giocatori senza avvertimenti",
  searchforplayers = "Cerca giocatori per nome o SteamID64",
  name = "Nome",
  lastplayed = "Ultima Partita",
  lastwarned = "Ultimo Avvertimento",
  never = "Mai",
  playerid = "ID Giocatore",
  lookupplayerwarnings = "Consulta gli avvertimenti di questo giocatore",
  servername = "Nome del Server",
  punishmentoptions = "Punizioni",
  kickpunishdescription = "Se abilitato, AWarn3 può espellere i giocatori dal server come punizione.",
  banpunishdescription = "Se abilitato, AWarn3 può bannare i giocatori dal server come punizione.",
  enabledecaydescription = "Se abilitato, gli avvertimenti attivi decadranno col tempo.",
  reasonrequireddescription = "Se abilitato, gli admin devono fornire una motivazione quando avvertono.",
  resetafterbandescription = "Se abilitato, gli avvertimenti attivi di un giocatore verranno azzerati dopo un ban da AWarn3.",
  logevents = "Registra Eventi Avvertimenti",
  logeventsdescription = "Se abilitato, le azioni in AWarn3 saranno registrate in un file di testo.",
  allowwarnadminsdescription = "Se abilitato, gli admin potranno avvertire altri admin.",
  clientjoinmessagedescription = "Se abilitato, i giocatori vedranno un messaggio in chat all'accesso se hanno avvertimenti.",
  adminjoinmessagedescription = "Se abilitato, gli admin vedranno quando un giocatore con avvertimenti entra.",
  chatprefixdescription = "Il comando di chat usato per i comandi AWarn3. Predefinito: !warn",
  warningdecayratedescription = "Il tempo (in minuti) che un giocatore deve restare connesso perché un avvertimento attivo decada.",
  servernamedescription = "Il nome di questo server. Utile per setup multi-server.",
  selectlanguagedescription = "La lingua in cui verranno mostrati i messaggi del server.",
  theme = "Tema Interfaccia",
  themeselect = "Seleziona Tema",
  punishgroup = "Gruppo di Punizione",
  grouptoset = "Gruppo da Impostare",
  viewnotes = "Visualizza Note Giocatore",
  playernotes = "Note Giocatore",
  interfacecustomizations = "Personalizzazioni Interfaccia",
  enableblur = "Abilita Sfocatura Sfondo",
  chooseapreset = "Scegli un preset (Opzionale)",
  warningpresets = "Preset",
  addeditpreset = "Aggiungi/Modifica Preset",
  presetname = "Nome Preset",
  presetreason = "Motivo Preset",
  customcommand = "Comando Personalizzato",
  customcommandplaceholder = "Sostituzioni — %n: Nome Giocatore, %s: SteamID, %i: SteamID64",
  confirm = "Conferma",
  cancel = "Annulla",
  deleteconfirmdialogue1 = "Conferma Eliminazione di Tutti gli Avvertimenti",
  deleteconfirmdialogue2 = "Stai per eliminare tutti gli avvertimenti di questo giocatore.",
  deleteconfirmdialogue3 = "Conferma questa azione.",
  removewhendeletewarning = "Rimuovi avvertimento attivo quando elimini un avvertimento",
  removewhendeletewarningdescription = "Se abilitato, 1 avvertimento attivo verrà rimosso quando un avvertimento viene eliminato.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
