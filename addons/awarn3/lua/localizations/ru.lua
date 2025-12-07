--[[
  AWarn3 Localization: RU-RU (Русский)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Russian translation.
]]

local LANGUAGE_CODE = "RU"
local LANGUAGE_NAME = "Русский"

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
  welcome1 = "Добро пожаловать в AWarn3!",
  insufficientperms = "Недостаточно прав для выполнения этой команды.",
  insufficientperms2 = "Недостаточно прав для просмотра предупреждений этого игрока.",
  commandnonexist = "Эта команда не существует.",
  invalidtargetid = "Неверная цель или ID.",
  invalidtarget = "Неверная цель.",
  reasonrequired = "Необходимо указать причину предупреждения.",
  remove1activewarn = "Вы удалили 1 активное предупреждение у",
  deletedwarningid = "Удалённое предупреждение ID",
  removeallwarnings = "Вы удалили все предупреждения у",
  deletedwarningsfor = "Все предупреждения удалены для",
  cantopenconsole = "Вы не можете открыть меню из консоли сервера.",
  invalidoption = "Неверный параметр.",
  invalidoptionvaluetype = "Неверный тип значения параметра.",
  optionsloaded = "Настройки загружены!",
  nopunishment = "Нет наказания для этого количества предупреждений.",
  punishmentsloaded = "Наказания загружены!",
  playernotallowedwarn = "Этого игрока нельзя предупредить.",
  warnmessage1 = "Вы получили предупреждение от %s по причине: %s.",
  warnmessage2 = "Вы предупредили %s по причине: %s.",
  warnmessage3 = "%s получил предупреждение от %s по причине: %s.",
  warnmessage4 = "Вы получили предупреждение от %s.",
  warnmessage5 = "Вы предупредили %s.",
  warnmessage6 = "%s получил предупреждение от %s.",
  joinmessage1 = "подключился к серверу с предупреждениями.",
  joinmessage2 = "Его последнее предупреждение было:",
  joinmessage3 = "С возвращением! Похоже, ранее вы уже получали предупреждения.",
  joinmessage4 = "Вы можете посмотреть свои предупреждения в любое время, введя",
  joinmessage5 = "Игрок подключается с активными предупреждениями:",
  closemenu = "Закрыть Меню",
  searchplayers = "Поиск Игроков",
  viewwarnings = "Предупреждения",
  configuration = "Конфигурация",
  clientoptions = "Настройки Пользователя",
  serveroptions = "Настройки Сервера",
  colorcustomization = "Настройка Цветов",
  colorselection = "Выбор Цвета",
  languageconfiguration = "Настройки Языка",
  selectlanguage = "Выбрать Язык",
  enablekickpunish = "Включить наказание — Кик",
  enablebanpunish = "Включить наказание — Бан",
  enabledecay = "Включить автоматическое снятие предупреждений",
  resetafterban = "Сброс предупреждений после Бана",
  allowwarnadmins = "Разрешить предупреждать администраторов",
  clientjoinmessage = "Показывать количество предупреждений игроку при входе",
  adminjoinmessage = "Показывать сообщение администраторам, когда игрок входит с предупреждениями",
  pressenter = "Нажмите Enter для сохранения",
  entertosave = "Enter для Сохранения",
  chatprefix = "Префикс Чата",
  warningdecayrate = "Скорость снятия предупреждений",
  serverlanguage = "Язык Сервера",
  punishmentsconfiguration = "Конфигурация Наказаний",
  addpunishment = "Добавить Наказание",
  warnings = "Предупреждения",
  punishtype = "Тип Наказания",
  punishlength = "Длительность Наказания",
  playermessage = "Сообщение Игроку",
  playername = "Имя Игрока",
  messagetoplayer = "Сообщение Игроку",
  servermessage = "Сообщение Сервера",
  messagetoserver = "Сообщение Серверу",
  deletewarning = "Удалить Предупреждение",
  punishaddmenu = "Меню Добавления Наказания",
  inminutes = "В Минутах",
  ["0equalperma"] = "0 = Постоянно",
  ["use%"] = "Используйте %%s, чтобы показать имя игрока",
  setdefault = "Установить по Умолчанию",
  showingownwarnings = "Отображаются ваши собственные предупреждения",
  warnedby = "Предупреждён",
  warningserver = "Сервер Предупреждения",
  warningreason = "Причина Предупреждения",
  warningdate = "Дата Предупреждения",
  nothing = "НИЧЕГО",
  submit = "Подтвердить",
  connectedplayers = "Подключённые Игроки",
  displaywarningsfor = "Отображение Предупреждений для",
  activewarnings = "Активные Предупреждения",
  selectedplayernowarnings = "Выбранный игрок не имеет предупреждений.",
  selectplayerseewarnings = "Выберите игрока, чтобы увидеть его предупреждения.",
  warnplayer = "Предупредить Игрока",
  reduceactiveby1 = "Уменьшить активные предупреждения на 1",
  playerwarningmenu = "Меню Предупреждений Игрока",
  playersearchmenu = "Меню Поиска Игроков",
  warningplayer = "Предупреждение Игроку",
  excludeplayers = "Исключить игроков без истории предупреждений",
  searchforplayers = "Искать игроков по имени или SteamID64",
  name = "Имя",
  lastplayed = "Последняя Игра",
  lastwarned = "Последнее Предупреждение",
  never = "Никогда",
  playerid = "ID Игрока",
  lookupplayerwarnings = "Просмотр предупреждений этого игрока",
  servername = "Имя Сервера",
  punishmentoptions = "Наказания",
  kickpunishdescription = "Если включено, AWarn3 может кикать игроков с сервера как наказание.",
  banpunishdescription = "Если включено, AWarn3 может банить игроков с сервера как наказание.",
  enabledecaydescription = "Если включено, активные предупреждения будут автоматически сниматься со временем.",
  reasonrequireddescription = "Если включено, администраторы должны указать причину при выдаче предупреждения.",
  resetafterbandescription = "Если включено, активные предупреждения пользователя будут сброшены до 0 после бана через AWarn3.",
  logevents = "Логировать События Предупреждений",
  logeventsdescription = "Если включено, действия AWarn3 будут записываться в текстовый файл.",
  allowwarnadminsdescription = "Если включено, администраторы смогут предупреждать других администраторов.",
  clientjoinmessagedescription = "Если включено, пользователи будут видеть сообщение в чате при входе, если у них есть предупреждения.",
  adminjoinmessagedescription = "Если включено, администраторы увидят, когда игрок с предупреждениями присоединяется.",
  chatprefixdescription = "Команда чата для команд AWarn3. По умолчанию: !warn",
  warningdecayratedescription = "Время (в минутах), которое игрок должен быть подключён, чтобы одно активное предупреждение снялось.",
  servernamedescription = "Имя этого сервера. Полезно при множестве серверов.",
  selectlanguagedescription = "Это язык, на котором будут отображаться сообщения сервера.",
  theme = "Тема Интерфейса",
  themeselect = "Выбрать Тему",
  punishgroup = "Группа Наказаний",
  grouptoset = "Группа для Установки",
  viewnotes = "Просмотр Заметок Игрока",
  playernotes = "Заметки Игрока",
  interfacecustomizations = "Настройки Интерфейса",
  enableblur = "Включить Размытие Фона",
  chooseapreset = "Выберите пресет (необязательно)",
  warningpresets = "Пресеты",
  addeditpreset = "Добавить/Редактировать Пресет",
  presetname = "Имя Пресета",
  presetreason = "Причина Пресета",
  customcommand = "Пользовательская Команда",
  customcommandplaceholder = "Замены — %n: Имя Игрока, %s: SteamID, %i: SteamID64",
  confirm = "Подтвердить",
  cancel = "Отмена",
  deleteconfirmdialogue1 = "Подтвердите удаление всех предупреждений",
  deleteconfirmdialogue2 = "Вы собираетесь удалить все предупреждения этого игрока.",
  deleteconfirmdialogue3 = "Пожалуйста, подтвердите это действие.",
  removewhendeletewarning = "Удалять активное предупреждение при удалении предупреждения",
  removewhendeletewarningdescription = "Если включено, 1 активное предупреждение будет удалено, когда удаляется предупреждение.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
