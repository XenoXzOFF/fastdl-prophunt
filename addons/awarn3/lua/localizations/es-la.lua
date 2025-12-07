--[[
  AWarn3 Localization: ES-LA (Español Latinoamericano)
  Notas:
    - Claves iguales para compatibilidad.
    - Estilo más natural para Latinoamérica, menos formal.
    - Placeholders (%s, %n, %i) preservados.
]]

local LANGUAGE_CODE = "ES-LA"
local LANGUAGE_NAME = "Español Latinoamericano"

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
  welcome1 = "¡Bienvenido a AWarn3!",
  insufficientperms = "No tienes permisos para usar este comando.",
  insufficientperms2 = "No tienes permisos para ver las advertencias de este jugador.",
  commandnonexist = "Ese comando no existe.",
  invalidtargetid = "Jugador o ID inválido.",
  invalidtarget = "Objetivo inválido.",
  reasonrequired = "Debes dar una razón para la advertencia.",
  remove1activewarn = "Quitaste 1 advertencia activa de",
  deletedwarningid = "Advertencia con ID eliminada",
  removeallwarnings = "Quitaste todas las advertencias de",
  deletedwarningsfor = "Se borraron todas las advertencias de",
  cantopenconsole = "No puedes abrir el menú desde la consola del servidor.",
  invalidoption = "Opción inválida.",
  invalidoptionvaluetype = "Tipo de valor inválido para la opción.",
  optionsloaded = "¡Opciones cargadas!",
  nopunishment = "No hay castigo para esta cantidad de advertencias.",
  punishmentsloaded = "¡Castigos cargados!",
  playernotallowedwarn = "No está permitido advertir a este jugador.",
  warnmessage1 = "Fuiste advertido por %s por %s.",
  warnmessage2 = "Advertiste a %s por %s.",
  warnmessage3 = "%s fue advertido por %s por %s.",
  warnmessage4 = "Fuiste advertido por %s.",
  warnmessage5 = "Advertiste a %s.",
  warnmessage6 = "%s fue advertido por %s.",
  joinmessage1 = "entró al servidor con advertencias.",
  joinmessage2 = "Su última advertencia fue el:",
  joinmessage3 = "¡Bienvenido de nuevo! Parece que ya tienes advertencias previas.",
  joinmessage4 = "Puedes ver tus advertencias en cualquier momento escribiendo",
  joinmessage5 = "Jugador entrando con advertencias activas:",
  closemenu = "Cerrar Menú",
  searchplayers = "Buscar Jugadores",
  viewwarnings = "Advertencias",
  configuration = "Configuración",
  clientoptions = "Opciones de Usuario",
  serveroptions = "Opciones del Servidor",
  colorcustomization = "Personalizar Colores",
  colorselection = "Elegir Color",
  languageconfiguration = "Idioma",
  selectlanguage = "Elegir un Idioma",
  enablekickpunish = "Activar castigo de Expulsión",
  enablebanpunish = "Activar castigo de Baneo",
  enabledecay = "Activar Decadencia de Advertencias",
  resetafterban = "Reiniciar Advertencias después de un Baneo",
  allowwarnadmins = "Permitir advertir a Admins",
  clientjoinmessage = "Mostrar número de advertencias al jugador al entrar",
  adminjoinmessage = "Mostrar mensaje a admins cuando entra un jugador con advertencias",
  pressenter = "Presiona Enter para guardar",
  entertosave = "Enter para Guardar",
  chatprefix = "Prefijo de Chat",
  warningdecayrate = "Tasa de Decadencia",
  serverlanguage = "Idioma del Servidor",
  punishmentsconfiguration = "Configurar Castigos",
  addpunishment = "Agregar Castigo",
  warnings = "Advertencias",
  punishtype = "Tipo de Castigo",
  punishlength = "Duración del Castigo",
  playermessage = "Mensaje al Jugador",
  playername = "Nombre del Jugador",
  messagetoplayer = "Mensaje al Jugador",
  servermessage = "Mensaje del Servidor",
  messagetoserver = "Mensaje al Servidor",
  deletewarning = "Borrar Advertencia",
  punishaddmenu = "Agregar Castigo",
  inminutes = "En Minutos",
  ["0equalperma"] = "0 = Permanente",
  ["use%"] = "Usa %%s para mostrar el nombre del jugador",
  setdefault = "Usar por Defecto",
  showingownwarnings = "Mostrando tus propias advertencias",
  warnedby = "Advertido Por",
  warningserver = "Servidor",
  warningreason = "Razón",
  warningdate = "Fecha",
  nothing = "NADA",
  submit = "Enviar",
  connectedplayers = "Jugadores Conectados",
  displaywarningsfor = "Mostrando Advertencias de",
  activewarnings = "Advertencias Activas",
  selectedplayernowarnings = "El jugador seleccionado no tiene advertencias.",
  selectplayerseewarnings = "Selecciona un jugador para ver sus advertencias.",
  warnplayer = "Advertir Jugador",
  reduceactiveby1 = "Reducir advertencias activas en 1",
  playerwarningmenu = "Menú de Advertencias",
  playersearchmenu = "Menú de Búsqueda de Jugadores",
  warningplayer = "Advirtiendo a Jugador",
  excludeplayers = "Excluir jugadores sin historial de advertencias",
  searchforplayers = "Buscar jugadores por nombre o SteamID64",
  name = "Nombre",
  lastplayed = "Última vez jugado",
  lastwarned = "Última Advertencia",
  never = "Nunca",
  playerid = "ID del Jugador",
  lookupplayerwarnings = "Ver advertencias de este jugador",
  servername = "Nombre del Servidor",
  punishmentoptions = "Castigos",
  kickpunishdescription = "Si está activado, AWarn3 puede expulsar jugadores como castigo.",
  banpunishdescription = "Si está activado, AWarn3 puede banear jugadores como castigo.",
  enabledecaydescription = "Si está activado, las advertencias activas se irán quitando con el tiempo.",
  reasonrequireddescription = "Si está activado, los admins deberán escribir una razón al advertir.",
  resetafterbandescription = "Si está activado, las advertencias activas de un jugador se reinician a 0 después de ser baneado por AWarn3.",
  logevents = "Registrar Eventos",
  logeventsdescription = "Si está activado, las acciones de AWarn3 se guardan en un archivo de texto.",
  allowwarnadminsdescription = "Si está activado, los admins pueden advertir a otros admins.",
  clientjoinmessagedescription = "Si está activado, los jugadores verán un mensaje al entrar si tienen advertencias.",
  adminjoinmessagedescription = "Si está activado, los admins verán cuando entra alguien con advertencias.",
  chatprefixdescription = "El comando de chat para AWarn3. Por defecto: !warn",
  warningdecayratedescription = "El tiempo (en minutos) que un jugador debe estar conectado para que se quite una advertencia activa.",
  servernamedescription = "El nombre de este servidor. Útil si manejas varios.",
  selectlanguagedescription = "El idioma en que se mostrarán los mensajes del servidor.",
  theme = "Tema",
  themeselect = "Elegir Tema",
  punishgroup = "Grupo de Castigo",
  grouptoset = "Grupo a Asignar",
  viewnotes = "Ver Notas del Jugador",
  playernotes = "Notas del Jugador",
  interfacecustomizations = "Personalizar Interfaz",
  enableblur = "Activar Desenfoque de Fondo",
  chooseapreset = "Elige un preset (opcional)",
  warningpresets = "Presets",
  addeditpreset = "Agregar/Editar Preset",
  presetname = "Nombre del Preset",
  presetreason = "Razón del Preset",
  customcommand = "Comando Personalizado",
  customcommandplaceholder = "Reemplazos — %n: Nombre, %s: SteamID, %i: SteamID64",
  confirm = "Confirmar",
  cancel = "Cancelar",
  deleteconfirmdialogue1 = "Confirmar Borrado de Advertencias",
  deleteconfirmdialogue2 = "Vas a borrar todas las advertencias de este jugador.",
  deleteconfirmdialogue3 = "Confirma esta acción.",
  removewhendeletewarning = "Quitar advertencia activa al borrar",
  removewhendeletewarningdescription = "Si está activado, se quitará 1 advertencia activa cuando se borre una advertencia.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
