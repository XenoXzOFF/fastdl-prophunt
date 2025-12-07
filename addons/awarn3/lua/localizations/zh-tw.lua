--[[
  AWarn3 Localization: ZH-TW (繁體中文)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Traditional Chinese translation.
]]

local LANGUAGE_CODE = "ZH-TW"
local LANGUAGE_NAME = "繁體中文"

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
  welcome1 = "歡迎使用 AWarn3！",
  insufficientperms = "權限不足，無法執行此指令。",
  insufficientperms2 = "權限不足，無法查看該玩家的警告。",
  commandnonexist = "此指令不存在。",
  invalidtargetid = "無效的目標或ID。",
  invalidtarget = "無效的目標。",
  reasonrequired = "必須提供警告原因。",
  remove1activewarn = "你移除了 1 條來自以下玩家的有效警告：",
  deletedwarningid = "已刪除的警告ID",
  removeallwarnings = "你移除了以下玩家的所有警告：",
  deletedwarningsfor = "已刪除以下玩家的所有警告：",
  cantopenconsole = "無法從伺服器主控台開啟選單。",
  invalidoption = "無效的選項。",
  invalidoptionvaluetype = "無效的選項值類型。",
  optionsloaded = "選項已載入！",
  nopunishment = "此警告數量沒有處罰。",
  punishmentsloaded = "處罰已載入！",
  playernotallowedwarn = "該玩家無法被警告。",
  warnmessage1 = "你被 %s 警告，原因：%s。",
  warnmessage2 = "你警告了 %s，原因：%s。",
  warnmessage3 = "%s 被 %s 警告，原因：%s。",
  warnmessage4 = "你被 %s 警告。",
  warnmessage5 = "你警告了 %s。",
  warnmessage6 = "%s 被 %s 警告。",
  joinmessage1 = "已進入伺服器，並帶有警告。",
  joinmessage2 = "他的最後一次警告是在：",
  joinmessage3 = "歡迎回來！看起來你之前已經被警告過。",
  joinmessage4 = "你可以隨時輸入以下指令查看你的警告：",
  joinmessage5 = "玩家加入時有有效警告：",
  closemenu = "關閉選單",
  searchplayers = "搜尋玩家",
  viewwarnings = "警告",
  configuration = "設定",
  clientoptions = "使用者選項",
  serveroptions = "伺服器選項",
  colorcustomization = "顏色自訂",
  colorselection = "顏色選擇",
  languageconfiguration = "語言設定",
  selectlanguage = "選擇語言",
  enablekickpunish = "啟用踢出處罰",
  enablebanpunish = "啟用封禁處罰",
  enabledecay = "啟用警告衰減",
  resetafterban = "封禁後重設有效警告",
  allowwarnadmins = "允許警告管理員",
  clientjoinmessage = "在玩家進入時顯示其警告數量",
  adminjoinmessage = "當玩家帶有警告加入時向管理員顯示訊息",
  pressenter = "按 Enter 以儲存更改",
  entertosave = "Enter 儲存",
  chatprefix = "聊天前綴",
  warningdecayrate = "警告衰減速率",
  serverlanguage = "伺服器語言",
  punishmentsconfiguration = "處罰設定",
  addpunishment = "新增處罰",
  warnings = "警告",
  punishtype = "處罰類型",
  punishlength = "處罰時長",
  playermessage = "發送給玩家的訊息",
  playername = "玩家名稱",
  messagetoplayer = "發送給玩家的訊息",
  servermessage = "伺服器訊息",
  messagetoserver = "發送給伺服器的訊息",
  deletewarning = "刪除警告",
  punishaddmenu = "新增處罰選單",
  inminutes = "以分鐘為單位",
  ["0equalperma"] = "0 = 永久",
  ["use%"] = "使用 %%s 以顯示玩家名稱",
  setdefault = "設為預設",
  showingownwarnings = "正在顯示你自己的警告",
  warnedby = "警告來自",
  warningserver = "警告伺服器",
  warningreason = "警告原因",
  warningdate = "警告日期",
  nothing = "無",
  submit = "提交",
  connectedplayers = "已連線玩家",
  displaywarningsfor = "顯示以下玩家的警告：",
  activewarnings = "有效警告",
  selectedplayernowarnings = "所選玩家沒有任何警告記錄。",
  selectplayerseewarnings = "選擇一位玩家以查看其警告。",
  warnplayer = "警告玩家",
  reduceactiveby1 = "減少 1 條有效警告",
  playerwarningmenu = "玩家警告選單",
  playersearchmenu = "玩家搜尋選單",
  warningplayer = "正在警告玩家",
  excludeplayers = "排除沒有警告紀錄的玩家",
  searchforplayers = "依名稱或 SteamID64 搜尋玩家",
  name = "名稱",
  lastplayed = "上次遊玩",
  lastwarned = "上次警告",
  never = "從未",
  playerid = "玩家ID",
  lookupplayerwarnings = "查看該玩家的警告",
  servername = "伺服器名稱",
  punishmentoptions = "處罰",
  kickpunishdescription = "啟用後，AWarn3 可以將玩家踢出伺服器作為處罰。",
  banpunishdescription = "啟用後，AWarn3 可以封禁玩家作為處罰。",
  enabledecaydescription = "啟用後，有效警告會隨時間衰減。",
  reasonrequireddescription = "啟用後，管理員在發出警告時必須提供原因。",
  resetafterbandescription = "啟用後，玩家被 AWarn3 封禁後其有效警告將會重設為 0。",
  logevents = "記錄警告事件",
  logeventsdescription = "啟用後，AWarn3 的操作將被記錄到文字檔案中。",
  allowwarnadminsdescription = "啟用後，管理員可以警告其他管理員。",
  clientjoinmessagedescription = "啟用後，玩家進入伺服器時若有警告會在聊天中顯示訊息。",
  adminjoinmessagedescription = "啟用後，管理員會看到玩家帶有警告加入時的提示。",
  chatprefixdescription = "用於 AWarn3 指令的聊天前綴。預設: !warn",
  warningdecayratedescription = "玩家需要保持連線的時間（分鐘），以減少 1 條有效警告。",
  servernamedescription = "此伺服器的名稱。在多伺服器環境下很有用。",
  selectlanguagedescription = "伺服器訊息顯示的語言。",
  theme = "介面主題",
  themeselect = "選擇主題",
  punishgroup = "處罰群組",
  grouptoset = "要設定的群組",
  viewnotes = "查看玩家備註",
  playernotes = "玩家備註",
  interfacecustomizations = "介面自訂",
  enableblur = "啟用背景模糊",
  chooseapreset = "選擇一個預設（可選）",
  warningpresets = "預設",
  addeditpreset = "新增/編輯預設",
  presetname = "預設名稱",
  presetreason = "預設原因",
  customcommand = "自訂指令",
  customcommandplaceholder = "替換 — %n: 玩家名稱, %s: SteamID, %i: SteamID64",
  confirm = "確認",
  cancel = "取消",
  deleteconfirmdialogue1 = "確認刪除所有警告",
  deleteconfirmdialogue2 = "你即將刪除該玩家的所有警告。",
  deleteconfirmdialogue3 = "請確認此操作。",
  removewhendeletewarning = "刪除警告時移除有效警告",
  removewhendeletewarningdescription = "啟用後，當刪除一條警告時，會移除 1 條有效警告。",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
