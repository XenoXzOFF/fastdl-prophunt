--[[
  AWarn3 Localization: PL-PL (Polski)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Polish translation.
]]

local LANGUAGE_CODE = "PL"
local LANGUAGE_NAME = "Polski"

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
  welcome1 = "Witamy w AWarn3!",
  insufficientperms = "Brak uprawnień do wykonania tej komendy.",
  insufficientperms2 = "Brak uprawnień do wyświetlenia ostrzeżeń tego gracza.",
  commandnonexist = "Ta komenda nie istnieje.",
  invalidtargetid = "Nieprawidłowy cel lub ID.",
  invalidtarget = "Nieprawidłowy cel.",
  reasonrequired = "Powód ostrzeżenia jest wymagany.",
  remove1activewarn = "Usunąłeś 1 aktywne ostrzeżenie od",
  deletedwarningid = "Usunięto ostrzeżenie o ID",
  removeallwarnings = "Usunąłeś wszystkie ostrzeżenia od",
  deletedwarningsfor = "Wszystkie ostrzeżenia usunięte dla",
  cantopenconsole = "Nie możesz otworzyć menu z konsoli serwera.",
  invalidoption = "Nieprawidłowa opcja.",
  invalidoptionvaluetype = "Nieprawidłowy typ wartości opcji.",
  optionsloaded = "Opcje załadowane!",
  nopunishment = "Brak kary dla tej liczby ostrzeżeń.",
  punishmentsloaded = "Kary załadowane!",
  playernotallowedwarn = "Ten gracz nie może być ostrzeżony.",
  warnmessage1 = "Zostałeś ostrzeżony przez %s za %s.",
  warnmessage2 = "Ostrzegłeś %s za %s.",
  warnmessage3 = "%s został ostrzeżony przez %s za %s.",
  warnmessage4 = "Zostałeś ostrzeżony przez %s.",
  warnmessage5 = "Ostrzegłeś %s.",
  warnmessage6 = "%s został ostrzeżony przez %s.",
  joinmessage1 = "dołączył do serwera z ostrzeżeniami.",
  joinmessage2 = "Jego ostatnie ostrzeżenie było dnia:",
  joinmessage3 = "Witamy ponownie! Wygląda na to, że byłeś już wcześniej ostrzeżony.",
  joinmessage4 = "Możesz zobaczyć swoje ostrzeżenia w każdej chwili, wpisując",
  joinmessage5 = "Gracz dołącza z aktywnymi ostrzeżeniami:",
  closemenu = "Zamknij Menu",
  searchplayers = "Szukaj Graczy",
  viewwarnings = "Ostrzeżenia",
  configuration = "Konfiguracja",
  clientoptions = "Opcje Użytkownika",
  serveroptions = "Opcje Serwera",
  colorcustomization = "Dostosowanie Kolorów",
  colorselection = "Wybór Koloru",
  languageconfiguration = "Ustawienia Języka",
  selectlanguage = "Wybierz Język",
  enablekickpunish = "Włącz karę Wyrzucenia",
  enablebanpunish = "Włącz karę Bana",
  enabledecay = "Włącz wygasanie aktywnych ostrzeżeń",
  resetafterban = "Zresetuj aktywne ostrzeżenia po banie",
  allowwarnadmins = "Zezwól na ostrzeganie administratorów",
  clientjoinmessage = "Wyświetl liczbę ostrzeżeń graczowi przy wejściu",
  adminjoinmessage = "Wyświetl wiadomość administratorom, gdy gracz z ostrzeżeniami dołącza",
  pressenter = "Naciśnij Enter, aby zapisać",
  entertosave = "Enter, aby zapisać",
  chatprefix = "Prefiks Czatu",
  warningdecayrate = "Tempo Wygasania Ostrzeżeń",
  serverlanguage = "Język Serwera",
  punishmentsconfiguration = "Konfiguracja Kar",
  addpunishment = "Dodaj Karę",
  warnings = "Ostrzeżenia",
  punishtype = "Rodzaj Kary",
  punishlength = "Długość Kary",
  playermessage = "Wiadomość do Gracza",
  playername = "Nazwa Gracza",
  messagetoplayer = "Wiadomość do Gracza",
  servermessage = "Wiadomość Serwera",
  messagetoserver = "Wiadomość do Serwera",
  deletewarning = "Usuń Ostrzeżenie",
  punishaddmenu = "Menu Dodawania Kary",
  inminutes = "W Minutach",
  ["0equalperma"] = "0 = Permanentnie",
  ["use%"] = "Użyj %%s, aby wyświetlić nazwę gracza",
  setdefault = "Ustaw jako Domyślne",
  showingownwarnings = "Wyświetlanie własnych ostrzeżeń",
  warnedby = "Ostrzeżony Przez",
  warningserver = "Serwer Ostrzeżenia",
  warningreason = "Powód Ostrzeżenia",
  warningdate = "Data Ostrzeżenia",
  nothing = "NIC",
  submit = "Zatwierdź",
  connectedplayers = "Połączeni Gracze",
  displaywarningsfor = "Wyświetlanie Ostrzeżeń dla",
  activewarnings = "Aktywne Ostrzeżenia",
  selectedplayernowarnings = "Wybrany gracz nie ma żadnych ostrzeżeń.",
  selectplayerseewarnings = "Wybierz gracza, aby zobaczyć jego ostrzeżenia.",
  warnplayer = "Ostrzeż Gracza",
  reduceactiveby1 = "Zredukuj aktywne ostrzeżenia o 1",
  playerwarningmenu = "Menu Ostrzeżeń Gracza",
  playersearchmenu = "Menu Wyszukiwania Graczy",
  warningplayer = "Ostrzeganie Gracza",
  excludeplayers = "Wyklucz graczy bez historii ostrzeżeń",
  searchforplayers = "Szukaj graczy po nazwie lub SteamID64",
  name = "Nazwa",
  lastplayed = "Ostatnio Grał",
  lastwarned = "Ostatnie Ostrzeżenie",
  never = "Nigdy",
  playerid = "ID Gracza",
  lookupplayerwarnings = "Sprawdź ostrzeżenia tego gracza",
  servername = "Nazwa Serwera",
  punishmentoptions = "Kary",
  kickpunishdescription = "Jeśli włączone, AWarn3 może wyrzucać graczy z serwera jako karę.",
  banpunishdescription = "Jeśli włączone, AWarn3 może banować graczy z serwera jako karę.",
  enabledecaydescription = "Jeśli włączone, aktywne ostrzeżenia będą wygasać z czasem.",
  reasonrequireddescription = "Jeśli włączone, administratorzy będą musieli podać powód przy ostrzeżeniu.",
  resetafterbandescription = "Jeśli włączone, aktywne ostrzeżenia gracza zostaną zresetowane do 0 po banie przez AWarn3.",
  logevents = "Rejestruj Zdarzenia Ostrzeżeń",
  logeventsdescription = "Jeśli włączone, działania w AWarn3 będą zapisywane w pliku tekstowym.",
  allowwarnadminsdescription = "Jeśli włączone, administratorzy będą mogli ostrzegać innych administratorów.",
  clientjoinmessagedescription = "Jeśli włączone, gracze zobaczą wiadomość na czacie przy wejściu, jeśli mają ostrzeżenia.",
  adminjoinmessagedescription = "Jeśli włączone, administratorzy zobaczą, gdy gracz z ostrzeżeniami dołączy.",
  chatprefixdescription = "Prefiks czatu używany do komend AWarn3. Domyślnie: !warn",
  warningdecayratedescription = "Czas (w minutach), przez jaki gracz musi być połączony, aby 1 aktywne ostrzeżenie wygasło.",
  servernamedescription = "Nazwa tego serwera. Przydatne przy wielu serwerach.",
  selectlanguagedescription = "To jest język, w którym będą wyświetlane wiadomości serwera.",
  theme = "Motyw Interfejsu",
  themeselect = "Wybierz Motyw",
  punishgroup = "Grupa Kary",
  grouptoset = "Grupa do Ustawienia",
  viewnotes = "Zobacz Notatki Gracza",
  playernotes = "Notatki Gracza",
  interfacecustomizations = "Dostosowanie Interfejsu",
  enableblur = "Włącz Rozmycie Tła",
  chooseapreset = "Wybierz preset (Opcjonalne)",
  warningpresets = "Presety",
  addeditpreset = "Dodaj/Edytuj Preset",
  presetname = "Nazwa Presetu",
  presetreason = "Powód Presetu",
  customcommand = "Komenda Niestandardowa",
  customcommandplaceholder = "Zamienniki — %n: Nazwa Gracza, %s: SteamID, %i: SteamID64",
  confirm = "Potwierdź",
  cancel = "Anuluj",
  deleteconfirmdialogue1 = "Potwierdź Usunięcie Wszystkich Ostrzeżeń",
  deleteconfirmdialogue2 = "Zaraz usuniesz wszystkie ostrzeżenia tego gracza.",
  deleteconfirmdialogue3 = "Potwierdź tę akcję.",
  removewhendeletewarning = "Usuń aktywne ostrzeżenie przy kasowaniu ostrzeżenia",
  removewhendeletewarningdescription = "Jeśli włączone, 1 aktywne ostrzeżenie zostanie usunięte, gdy ostrzeżenie zostanie skasowane.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
