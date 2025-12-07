--[[
  AWarn3 Localization: ZH-CN (简体中文)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Simplified Chinese translation.
]]

local LANGUAGE_CODE = "ZH-CN"
local LANGUAGE_NAME = "简体中文"

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
  welcome1 = "欢迎使用 AWarn3！",
  insufficientperms = "权限不足，无法执行此命令。",
  insufficientperms2 = "权限不足，无法查看该玩家的警告。",
  commandnonexist = "该命令不存在。",
  invalidtargetid = "无效的目标或ID。",
  invalidtarget = "无效的目标。",
  reasonrequired = "必须提供警告原因。",
  remove1activewarn = "你移除了 1 条来自以下玩家的活跃警告：",
  deletedwarningid = "已删除的警告ID",
  removeallwarnings = "你移除了以下玩家的所有警告：",
  deletedwarningsfor = "已删除以下玩家的所有警告：",
  cantopenconsole = "不能从服务器控制台打开菜单。",
  invalidoption = "无效的选项。",
  invalidoptionvaluetype = "无效的选项值类型。",
  optionsloaded = "选项已加载！",
  nopunishment = "此警告数量没有处罚。",
  punishmentsloaded = "处罚已加载！",
  playernotallowedwarn = "该玩家不能被警告。",
  warnmessage1 = "你被 %s 警告，原因：%s。",
  warnmessage2 = "你警告了 %s，原因：%s。",
  warnmessage3 = "%s 被 %s 警告，原因：%s。",
  warnmessage4 = "你被 %s 警告。",
  warnmessage5 = "你警告了 %s。",
  warnmessage6 = "%s 被 %s 警告。",
  joinmessage1 = "进入了服务器，并带有警告。",
  joinmessage2 = "他的最后一次警告是在：",
  joinmessage3 = "欢迎回来！看起来你之前已经被警告过。",
  joinmessage4 = "你可以随时输入以下命令查看你的警告：",
  joinmessage5 = "玩家加入时有活跃警告：",
  closemenu = "关闭菜单",
  searchplayers = "搜索玩家",
  viewwarnings = "警告",
  configuration = "配置",
  clientoptions = "用户选项",
  serveroptions = "服务器选项",
  colorcustomization = "颜色自定义",
  colorselection = "颜色选择",
  languageconfiguration = "语言设置",
  selectlanguage = "选择语言",
  enablekickpunish = "启用踢出惩罚",
  enablebanpunish = "启用封禁惩罚",
  enabledecay = "启用警告衰减",
  resetafterban = "封禁后重置活跃警告",
  allowwarnadmins = "允许警告管理员",
  clientjoinmessage = "在玩家加入时显示其警告数量",
  adminjoinmessage = "当玩家带有警告加入时向管理员显示消息",
  pressenter = "按 Enter 保存更改",
  entertosave = "Enter 保存",
  chatprefix = "聊天前缀",
  warningdecayrate = "警告衰减速率",
  serverlanguage = "服务器语言",
  punishmentsconfiguration = "处罚配置",
  addpunishment = "添加处罚",
  warnings = "警告",
  punishtype = "处罚类型",
  punishlength = "处罚时长",
  playermessage = "发送给玩家的消息",
  playername = "玩家名称",
  messagetoplayer = "发送给玩家的消息",
  servermessage = "服务器消息",
  messagetoserver = "发送给服务器的消息",
  deletewarning = "删除警告",
  punishaddmenu = "添加处罚菜单",
  inminutes = "以分钟为单位",
  ["0equalperma"] = "0 = 永久",
  ["use%"] = "使用 %%s 来显示玩家的名字",
  setdefault = "设为默认",
  showingownwarnings = "正在显示你自己的警告",
  warnedby = "警告来自",
  warningserver = "警告服务器",
  warningreason = "警告原因",
  warningdate = "警告日期",
  nothing = "无",
  submit = "提交",
  connectedplayers = "已连接玩家",
  displaywarningsfor = "显示以下玩家的警告：",
  activewarnings = "活跃警告",
  selectedplayernowarnings = "所选玩家没有警告记录。",
  selectplayerseewarnings = "选择一个玩家以查看其警告。",
  warnplayer = "警告玩家",
  reduceactiveby1 = "减少 1 条活跃警告",
  playerwarningmenu = "玩家警告菜单",
  playersearchmenu = "玩家搜索菜单",
  warningplayer = "正在警告玩家",
  excludeplayers = "排除没有警告记录的玩家",
  searchforplayers = "通过名字或 SteamID64 搜索玩家",
  name = "名字",
  lastplayed = "上次游戏",
  lastwarned = "上次警告",
  never = "从未",
  playerid = "玩家ID",
  lookupplayerwarnings = "查看该玩家的警告",
  servername = "服务器名称",
  punishmentoptions = "处罚",
  kickpunishdescription = "启用后，AWarn3 可以将玩家踢出服务器作为处罚。",
  banpunishdescription = "启用后，AWarn3 可以封禁玩家作为处罚。",
  enabledecaydescription = "启用后，活跃警告会随时间衰减。",
  reasonrequireddescription = "启用后，管理员在发出警告时必须填写原因。",
  resetafterbandescription = "启用后，玩家在被 AWarn3 封禁后活跃警告会重置为 0。",
  logevents = "记录警告事件",
  logeventsdescription = "启用后，AWarn3 的操作将记录到文本文件中。",
  allowwarnadminsdescription = "启用后，管理员可以警告其他管理员。",
  clientjoinmessagedescription = "启用后，玩家进入服务器时若有警告会在聊天中显示消息。",
  adminjoinmessagedescription = "启用后，管理员会看到玩家带有警告加入时的提示。",
  chatprefixdescription = "用于 AWarn3 命令的聊天前缀。默认: !warn",
  warningdecayratedescription = "玩家需要保持连接的时间（分钟），以减少 1 条活跃警告。",
  servernamedescription = "此服务器的名称。在多服务器环境下很有用。",
  selectlanguagedescription = "服务器消息显示的语言。",
  theme = "界面主题",
  themeselect = "选择主题",
  punishgroup = "处罚组",
  grouptoset = "设置的组",
  viewnotes = "查看玩家备注",
  playernotes = "玩家备注",
  interfacecustomizations = "界面自定义",
  enableblur = "启用背景模糊",
  chooseapreset = "选择一个预设（可选）",
  warningpresets = "预设",
  addeditpreset = "添加/编辑预设",
  presetname = "预设名称",
  presetreason = "预设原因",
  customcommand = "自定义命令",
  customcommandplaceholder = "替换 — %n: 玩家名字, %s: SteamID, %i: SteamID64",
  confirm = "确认",
  cancel = "取消",
  deleteconfirmdialogue1 = "确认删除所有警告",
  deleteconfirmdialogue2 = "你即将删除该玩家的所有警告。",
  deleteconfirmdialogue3 = "请确认此操作。",
  removewhendeletewarning = "删除警告时移除活跃警告",
  removewhendeletewarningdescription = "启用后，当删除一条警告时，会移除 1 条活跃警告。",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
