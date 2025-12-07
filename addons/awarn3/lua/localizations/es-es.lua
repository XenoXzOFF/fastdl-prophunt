--[[
  AWarn3 Localization: ES-ES (Español)
  Notas:
    - Las claves permanecen iguales para compatibilidad.
    - Se han mantenido los marcadores de formato (%s, %n, %i).
    - Traducción en español neutro (castellano estándar).
]]

local LANGUAGE_CODE = "ES-ES"
local LANGUAGE_NAME = "Español"

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
  insufficientperms = "Permisos insuficientes para ejecutar este comando.",
  insufficientperms2 = "Permisos insuficientes para ver las advertencias de este jugador.",
  commandnonexist = "Este comando no existe.",
  invalidtargetid = "Objetivo o ID inválido.",
  invalidtarget = "Objetivo inválido.",
  reasonrequired = "Se requiere una razón para la advertencia.",
  remove1activewarn = "Has eliminado 1 advertencia activa de",
  deletedwarningid = "ID de advertencia eliminada",
  removeallwarnings = "Has eliminado todas las advertencias de",
  deletedwarningsfor = "Se eliminaron todas las advertencias de",
  cantopenconsole = "No puedes abrir el menú desde la consola del servidor.",
  invalidoption = "Opción inválida.",
  invalidoptionvaluetype = "Tipo de valor de opción inválido.",
  optionsloaded = "¡Opciones cargadas!",
  nopunishment = "No hay castigo para esta cantidad de advertencias.",
  punishmentsloaded = "¡Castigos cargados!",
  playernotallowedwarn = "Este jugador no puede ser advertido.",
  warnmessage1 = "Has sido advertido por %s por %s.",
  warnmessage2 = "Has advertido a %s por %s.",
  warnmessage3 = "%s fue advertido por %s por %s.",
  warnmessage4 = "Has sido advertido por %s.",
  warnmessage5 = "Has advertido a %s.",
  warnmessage6 = "%s fue advertido por %s.",
  joinmessage1 = "se ha unido al servidor con advertencias.",
  joinmessage2 = "Su última advertencia fue el:",
  joinmessage3 = "Bienvenido de nuevo al servidor. Parece que has sido advertido en el pasado.",
  joinmessage4 = "Puedes ver tus advertencias en cualquier momento escribiendo",
  joinmessage5 = "Jugador se une con advertencias activas:",
  closemenu = "Cerrar Menú",
  searchplayers = "Buscar Jugadores",
  viewwarnings = "Advertencias",
  configuration = "Configuración",
  clientoptions = "Opciones de Usuario",
  serveroptions = "Opciones del Servidor",
  colorcustomization = "Personalización de Colores",
  colorselection = "Selección de Color",
  languageconfiguration = "Personalización de Idioma",
  selectlanguage = "Seleccionar un Idioma",
  enablekickpunish = "Habilitar Castigo de Expulsión",
  enablebanpunish = "Habilitar Castigo de Baneo",
  enabledecay = "Habilitar Decadencia de Advertencias Activas",
  resetafterban = "Reiniciar Advertencias Activas Después de un Baneo",
  allowwarnadmins = "Permitir Advertir a Administradores",
  clientjoinmessage = "Mostrar número de advertencias al jugador al unirse",
  adminjoinmessage = "Mostrar mensaje a administradores cuando un jugador se une con advertencias",
  pressenter = "Pulsa Enter para guardar cambios",
  entertosave = "Enter para Guardar",
  chatprefix = "Prefijo de Chat",
  warningdecayrate = "Tasa de Decadencia de Advertencias",
  serverlanguage = "Idioma del Servidor",
  punishmentsconfiguration = "Configuración de Castigos",
  addpunishment = "Añadir Castigo",
  warnings = "Advertencias",
  punishtype = "Tipo de Castigo",
  punishlength = "Duración del Castigo",
  playermessage = "Mensaje al Jugador",
  playername = "Nombre del Jugador",
  messagetoplayer = "Mensaje al Jugador",
  servermessage = "Mensaje del Servidor",
  messagetoserver = "Mensaje al Servidor",
  deletewarning = "Eliminar Advertencia",
  punishaddmenu = "Menú para Añadir Castigo",
  inminutes = "En Minutos",
  ["0equalperma"] = "0 = Permanente",
  ["use%"] = "Usa %%s para mostrar el nombre del jugador",
  setdefault = "Establecer por Defecto",
  showingownwarnings = "Mostrando tus propias advertencias",
  warnedby = "Advertido Por",
  warningserver = "Servidor de la Advertencia",
  warningreason = "Razón de la Advertencia",
  warningdate = "Fecha de la Advertencia",
  nothing = "NADA",
  submit = "Enviar",
  connectedplayers = "Jugadores Conectados",
  displaywarningsfor = "Mostrando Advertencias de",
  activewarnings = "Advertencias Activas",
  selectedplayernowarnings = "El jugador seleccionado no tiene advertencias registradas.",
  selectplayerseewarnings = "Selecciona un jugador para ver sus advertencias.",
  warnplayer = "Advertir Jugador",
  reduceactiveby1 = "Reducir advertencias activas en 1",
  playerwarningmenu = "Menú de Advertencias de Jugador",
  playersearchmenu = "Menú de Búsqueda de Jugadores",
  warningplayer = "Advirtiendo a Jugador",
  excludeplayers = "Excluir jugadores sin historial de advertencias",
  searchforplayers = "Buscar jugadores por nombre o SteamID64",
  name = "Nombre",
  lastplayed = "Última Partida",
  lastwarned = "Última Advertencia",
  never = "Nunca",
  playerid = "ID del Jugador",
  lookupplayerwarnings = "Consultar advertencias de este jugador",
  servername = "Nombre del Servidor",
  punishmentoptions = "Castigos",
  kickpunishdescription = "Si está habilitado, AWarn3 puede expulsar a jugadores del servidor como castigo.",
  banpunishdescription = "Si está habilitado, AWarn3 puede banear a jugadores del servidor como castigo.",
  enabledecaydescription = "Si está habilitado, las advertencias activas decaerán con el tiempo.",
  reasonrequireddescription = "Si está habilitado, los administradores deberán proporcionar una razón al advertir.",
  resetafterbandescription = "Si está habilitado, las advertencias activas de un usuario se reiniciarán a 0 después de ser baneado por AWarn3.",
  logevents = "Registrar Eventos de Advertencia",
  logeventsdescription = "Si está habilitado, las acciones dentro de AWarn3 se registrarán en un archivo de texto.",
  allowwarnadminsdescription = "Si está habilitado, los administradores podrán advertir a otros administradores.",
  clientjoinmessagedescription = "Si está habilitado, los usuarios que se unan al servidor verán un mensaje en el chat si tienen advertencias.",
  adminjoinmessagedescription = "Si está habilitado, los administradores verán cuando cualquier jugador con advertencias se una.",
  chatprefixdescription = "El comando de chat usado para los comandos de AWarn3. Por defecto: !warn",
  warningdecayratedescription = "El tiempo (en minutos) que un jugador debe estar conectado para que decaiga una advertencia activa.",
  servernamedescription = "El nombre de este servidor. Útil para configuraciones con múltiples servidores.",
  selectlanguagedescription = "Este es el idioma en el que se mostrarán los mensajes del servidor.",
  theme = "Tema de la Interfaz",
  themeselect = "Seleccionar Tema",
  punishgroup = "Grupo de Castigo",
  grouptoset = "Grupo a Asignar",
  viewnotes = "Ver Notas del Jugador",
  playernotes = "Notas del Jugador",
  interfacecustomizations = "Personalizaciones de Interfaz",
  enableblur = "Habilitar Desenfoque de Fondo",
  chooseapreset = "Elige un preset (Opcional)",
  warningpresets = "Presets",
  addeditpreset = "Añadir/Editar Preset",
  presetname = "Nombre del Preset",
  presetreason = "Razón del Preset",
  customcommand = "Comando Personalizado",
  customcommandplaceholder = "Reemplazos — %n: Nombre del Jugador, %s: SteamID, %i: SteamID64",
  confirm = "Confirmar",
  cancel = "Cancelar",
  deleteconfirmdialogue1 = "Confirmar Eliminación de Todas las Advertencias",
  deleteconfirmdialogue2 = "Estás a punto de eliminar todas las advertencias de este jugador.",
  deleteconfirmdialogue3 = "Por favor confirma esta acción.",
  removewhendeletewarning = "Eliminar advertencia activa al borrar advertencia",
  removewhendeletewarningdescription = "Si está habilitado, se eliminará 1 advertencia activa de un jugador al borrar una advertencia.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
