--[[
  AWarn3 Localization: PT-PT (Português de Portugal)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral European Portuguese.
]]

local LANGUAGE_CODE = "PT"
local LANGUAGE_NAME = "Português (Portugal)"

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
  welcome1 = "Bem-vindo ao AWarn3!",
  insufficientperms = "Permissões insuficientes para executar este comando.",
  insufficientperms2 = "Permissões insuficientes para ver os avisos deste jogador.",
  commandnonexist = "Esse comando não existe.",
  invalidtargetid = "Alvo ou ID inválido.",
  invalidtarget = "Alvo inválido.",
  reasonrequired = "É necessário indicar uma razão para o aviso.",
  remove1activewarn = "Removeste 1 aviso ativo de",
  deletedwarningid = "ID de aviso eliminado",
  removeallwarnings = "Removeste todos os avisos de",
  deletedwarningsfor = "Todos os avisos eliminados para",
  cantopenconsole = "Não podes abrir o menu pela consola do servidor.",
  invalidoption = "Opção inválida.",
  invalidoptionvaluetype = "Tipo de valor da opção inválido.",
  optionsloaded = "Opções carregadas!",
  nopunishment = "Sem punição para esta quantidade de avisos.",
  punishmentsloaded = "Punições carregadas!",
  playernotallowedwarn = "Este jogador não pode ser avisado.",
  warnmessage1 = "Foste avisado por %s por %s.",
  warnmessage2 = "Avisaste %s por %s.",
  warnmessage3 = "%s foi avisado por %s por %s.",
  warnmessage4 = "Foste avisado por %s.",
  warnmessage5 = "Avisaste %s.",
  warnmessage6 = "%s foi avisado por %s.",
  joinmessage1 = "entrou no servidor com avisos.",
  joinmessage2 = "O seu último aviso foi em:",
  joinmessage3 = "Bem-vindo de volta! Parece que já foste avisado anteriormente.",
  joinmessage4 = "Podes ver os teus avisos a qualquer momento escrevendo",
  joinmessage5 = "Jogador a entrar com avisos ativos:",
  closemenu = "Fechar Menu",
  searchplayers = "Procurar Jogadores",
  viewwarnings = "Avisos",
  configuration = "Configurações",
  clientoptions = "Opções do Utilizador",
  serveroptions = "Opções do Servidor",
  colorcustomization = "Personalização de Cores",
  colorselection = "Seleção de Cor",
  languageconfiguration = "Configurações de Idioma",
  selectlanguage = "Selecionar um Idioma",
  enablekickpunish = "Ativar punição de Expulsão",
  enablebanpunish = "Ativar punição de Banimento",
  enabledecay = "Ativar decadência de avisos ativos",
  resetafterban = "Reiniciar avisos ativos após Banimento",
  allowwarnadmins = "Permitir avisar administradores",
  clientjoinmessage = "Mostrar número de avisos ao jogador ao entrar",
  adminjoinmessage = "Mostrar mensagem aos administradores quando um jogador entra com avisos",
  pressenter = "Prime Enter para guardar",
  entertosave = "Enter para Guardar",
  chatprefix = "Prefixo do Chat",
  warningdecayrate = "Taxa de Decadência dos Avisos",
  serverlanguage = "Idioma do Servidor",
  punishmentsconfiguration = "Configuração de Punições",
  addpunishment = "Adicionar Punição",
  warnings = "Avisos",
  punishtype = "Tipo de Punição",
  punishlength = "Duração da Punição",
  playermessage = "Mensagem ao Jogador",
  playername = "Nome do Jogador",
  messagetoplayer = "Mensagem ao Jogador",
  servermessage = "Mensagem do Servidor",
  messagetoserver = "Mensagem ao Servidor",
  deletewarning = "Eliminar Aviso",
  punishaddmenu = "Menu de Adição de Punição",
  inminutes = "Em Minutos",
  ["0equalperma"] = "0 = Permanente",
  ["use%"] = "Usa %%s para mostrar o nome do jogador",
  setdefault = "Definir como Padrão",
  showingownwarnings = "A mostrar os teus próprios avisos",
  warnedby = "Avisado Por",
  warningserver = "Servidor do Aviso",
  warningreason = "Razão do Aviso",
  warningdate = "Data do Aviso",
  nothing = "NADA",
  submit = "Confirmar",
  connectedplayers = "Jogadores Conectados",
  displaywarningsfor = "A mostrar Avisos de",
  activewarnings = "Avisos Ativos",
  selectedplayernowarnings = "O jogador selecionado não tem avisos registados.",
  selectplayerseewarnings = "Seleciona um jogador para ver os seus avisos.",
  warnplayer = "Avisar Jogador",
  reduceactiveby1 = "Reduzir avisos ativos em 1",
  playerwarningmenu = "Menu de Avisos do Jogador",
  playersearchmenu = "Menu de Pesquisa de Jogadores",
  warningplayer = "A avisar Jogador",
  excludeplayers = "Excluir jogadores sem histórico de avisos",
  searchforplayers = "Procurar jogadores por nome ou SteamID64",
  name = "Nome",
  lastplayed = "Última Vez Jogado",
  lastwarned = "Último Aviso",
  never = "Nunca",
  playerid = "ID do Jogador",
  lookupplayerwarnings = "Ver avisos deste jogador",
  servername = "Nome do Servidor",
  punishmentoptions = "Punições",
  kickpunishdescription = "Se ativado, o AWarn3 pode expulsar jogadores do servidor como punição.",
  banpunishdescription = "Se ativado, o AWarn3 pode banir jogadores do servidor como punição.",
  enabledecaydescription = "Se ativado, avisos ativos irão decair com o tempo.",
  reasonrequireddescription = "Se ativado, administradores devem indicar uma razão ao aplicar um aviso.",
  resetafterbandescription = "Se ativado, os avisos ativos de um utilizador serão redefinidos para 0 após ser banido pelo AWarn3.",
  logevents = "Registar Eventos de Aviso",
  logeventsdescription = "Se ativado, ações no AWarn3 serão registadas num ficheiro de texto.",
  allowwarnadminsdescription = "Se ativado, administradores poderão avisar outros administradores.",
  clientjoinmessagedescription = "Se ativado, jogadores verão uma mensagem no chat ao entrar se tiverem avisos.",
  adminjoinmessagedescription = "Se ativado, administradores verão quando um jogador com avisos entrar.",
  chatprefixdescription = "O comando de chat usado para comandos do AWarn3. Padrão: !warn",
  warningdecayratedescription = "O tempo (em minutos) que o jogador precisa de estar ligado para 1 aviso ativo decair.",
  servernamedescription = "O nome deste servidor. Útil para configurações com múltiplos servidores.",
  selectlanguagedescription = "O idioma em que as mensagens do servidor serão apresentadas.",
  theme = "Tema da Interface",
  themeselect = "Selecionar Tema",
  punishgroup = "Grupo de Punição",
  grouptoset = "Grupo a Definir",
  viewnotes = "Ver Notas do Jogador",
  playernotes = "Notas do Jogador",
  interfacecustomizations = "Personalizações da Interface",
  enableblur = "Ativar Desfoque de Fundo",
  chooseapreset = "Escolhe um preset (Opcional)",
  warningpresets = "Presets",
  addeditpreset = "Adicionar/Editar Preset",
  presetname = "Nome do Preset",
  presetreason = "Razão do Preset",
  customcommand = "Comando Personalizado",
  customcommandplaceholder = "Substituições — %n: Nome do Jogador, %s: SteamID, %i: SteamID64",
  confirm = "Confirmar",
  cancel = "Cancelar",
  deleteconfirmdialogue1 = "Confirmar Eliminação de Todos os Avisos",
  deleteconfirmdialogue2 = "Estás prestes a eliminar todos os avisos deste jogador.",
  deleteconfirmdialogue3 = "Por favor confirma esta ação.",
  removewhendeletewarning = "Remover aviso ativo ao eliminar um aviso",
  removewhendeletewarningdescription = "Se ativado, 1 aviso ativo será removido quando um aviso for eliminado.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
