--[[
  AWarn3 Localization: PT-BR (Português do Brasil)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Brazilian Portuguese.
]]

local LANGUAGE_CODE = "PT-BR"
local LANGUAGE_NAME = "Português (Brasil)"

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
  reasonrequired = "É necessário informar um motivo para o aviso.",
  remove1activewarn = "Você removeu 1 aviso ativo de",
  deletedwarningid = "ID de aviso excluído",
  removeallwarnings = "Você removeu todos os avisos de",
  deletedwarningsfor = "Todos os avisos excluídos para",
  cantopenconsole = "Você não pode abrir o menu pelo console do servidor.",
  invalidoption = "Opção inválida.",
  invalidoptionvaluetype = "Tipo de valor da opção inválido.",
  optionsloaded = "Opções carregadas!",
  nopunishment = "Nenhuma punição para essa quantidade de avisos.",
  punishmentsloaded = "Punições carregadas!",
  playernotallowedwarn = "Este jogador não pode ser avisado.",
  warnmessage1 = "Você foi avisado por %s por %s.",
  warnmessage2 = "Você avisou %s por %s.",
  warnmessage3 = "%s foi avisado por %s por %s.",
  warnmessage4 = "Você foi avisado por %s.",
  warnmessage5 = "Você avisou %s.",
  warnmessage6 = "%s foi avisado por %s.",
  joinmessage1 = "entrou no servidor com avisos.",
  joinmessage2 = "Seu último aviso foi em:",
  joinmessage3 = "Bem-vindo de volta! Parece que você já recebeu avisos antes.",
  joinmessage4 = "Você pode ver seus avisos a qualquer momento digitando",
  joinmessage5 = "Jogador entrando com avisos ativos:",
  closemenu = "Fechar Menu",
  searchplayers = "Pesquisar Jogadores",
  viewwarnings = "Avisos",
  configuration = "Configurações",
  clientoptions = "Opções do Usuário",
  serveroptions = "Opções do Servidor",
  colorcustomization = "Personalização de Cores",
  colorselection = "Seleção de Cor",
  languageconfiguration = "Configurações de Idioma",
  selectlanguage = "Selecionar um Idioma",
  enablekickpunish = "Ativar punição de Kick",
  enablebanpunish = "Ativar punição de Ban",
  enabledecay = "Ativar decadência de avisos ativos",
  resetafterban = "Redefinir avisos ativos após Ban",
  allowwarnadmins = "Permitir avisar administradores",
  clientjoinmessage = "Exibir quantidade de avisos ao jogador ao entrar",
  adminjoinmessage = "Exibir mensagem aos administradores quando um jogador entra com avisos",
  pressenter = "Pressione Enter para salvar",
  entertosave = "Enter para Salvar",
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
  deletewarning = "Excluir Aviso",
  punishaddmenu = "Menu de Adição de Punição",
  inminutes = "Em Minutos",
  ["0equalperma"] = "0 = Permanente",
  ["use%"] = "Use %%s para mostrar o nome do jogador",
  setdefault = "Definir como Padrão",
  showingownwarnings = "Exibindo seus próprios avisos",
  warnedby = "Avisado Por",
  warningserver = "Servidor do Aviso",
  warningreason = "Motivo do Aviso",
  warningdate = "Data do Aviso",
  nothing = "NADA",
  submit = "Confirmar",
  connectedplayers = "Jogadores Conectados",
  displaywarningsfor = "Exibindo Avisos de",
  activewarnings = "Avisos Ativos",
  selectedplayernowarnings = "O jogador selecionado não possui avisos registrados.",
  selectplayerseewarnings = "Selecione um jogador para ver seus avisos.",
  warnplayer = "Avisar Jogador",
  reduceactiveby1 = "Reduzir avisos ativos em 1",
  playerwarningmenu = "Menu de Avisos do Jogador",
  playersearchmenu = "Menu de Pesquisa de Jogadores",
  warningplayer = "Avisando Jogador",
  excludeplayers = "Excluir jogadores sem histórico de avisos",
  searchforplayers = "Pesquisar jogadores por nome ou SteamID64",
  name = "Nome",
  lastplayed = "Última Partida",
  lastwarned = "Último Aviso",
  never = "Nunca",
  playerid = "ID do Jogador",
  lookupplayerwarnings = "Ver avisos deste jogador",
  servername = "Nome do Servidor",
  punishmentoptions = "Punições",
  kickpunishdescription = "Se ativado, o AWarn3 pode expulsar jogadores do servidor como punição.",
  banpunishdescription = "Se ativado, o AWarn3 pode banir jogadores do servidor como punição.",
  enabledecaydescription = "Se ativado, avisos ativos irão decair com o tempo.",
  reasonrequireddescription = "Se ativado, administradores precisam informar um motivo ao aplicar um aviso.",
  resetafterbandescription = "Se ativado, os avisos ativos de um usuário serão redefinidos para 0 após ser banido pelo AWarn3.",
  logevents = "Registrar Eventos de Aviso",
  logeventsdescription = "Se ativado, ações no AWarn3 serão registradas em um arquivo de texto.",
  allowwarnadminsdescription = "Se ativado, administradores poderão avisar outros administradores.",
  clientjoinmessagedescription = "Se ativado, jogadores verão uma mensagem no chat ao entrar se tiverem avisos.",
  adminjoinmessagedescription = "Se ativado, administradores verão quando um jogador com avisos entrar.",
  chatprefixdescription = "O comando de chat usado para comandos do AWarn3. Padrão: !warn",
  warningdecayratedescription = "O tempo (em minutos) que o jogador precisa ficar conectado para 1 aviso ativo decair.",
  servernamedescription = "O nome deste servidor. Útil para configurações com múltiplos servidores.",
  selectlanguagedescription = "O idioma em que as mensagens do servidor serão exibidas.",
  theme = "Tema da Interface",
  themeselect = "Selecionar Tema",
  punishgroup = "Grupo de Punição",
  grouptoset = "Grupo a Definir",
  viewnotes = "Ver Notas do Jogador",
  playernotes = "Notas do Jogador",
  interfacecustomizations = "Personalizações da Interface",
  enableblur = "Ativar Desfoque de Fundo",
  chooseapreset = "Escolha um preset (Opcional)",
  warningpresets = "Presets",
  addeditpreset = "Adicionar/Editar Preset",
  presetname = "Nome do Preset",
  presetreason = "Motivo do Preset",
  customcommand = "Comando Personalizado",
  customcommandplaceholder = "Substituições — %n: Nome do Jogador, %s: SteamID, %i: SteamID64",
  confirm = "Confirmar",
  cancel = "Cancelar",
  deleteconfirmdialogue1 = "Confirmar Exclusão de Todos os Avisos",
  deleteconfirmdialogue2 = "Você está prestes a excluir todos os avisos deste jogador.",
  deleteconfirmdialogue3 = "Por favor, confirme esta ação.",
  removewhendeletewarning = "Remover aviso ativo ao excluir um aviso",
  removewhendeletewarningdescription = "Se ativado, 1 aviso ativo será removido quando um aviso for excluído.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
