--[[
  AWarn3 Localization: JA-JP (日本語)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Japanese translation.
]]

local LANGUAGE_CODE = "JA-JP"
local LANGUAGE_NAME = "日本語"

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
  welcome1 = "AWarn3へようこそ！",
  insufficientperms = "このコマンドを実行する権限がありません。",
  insufficientperms2 = "このプレイヤーの警告を見る権限がありません。",
  commandnonexist = "このコマンドは存在しません。",
  invalidtargetid = "無効な対象またはIDです。",
  invalidtarget = "無効な対象です。",
  reasonrequired = "警告の理由が必要です。",
  remove1activewarn = "次のプレイヤーのアクティブ警告を1件削除しました：",
  deletedwarningid = "削除された警告ID",
  removeallwarnings = "次のプレイヤーのすべての警告を削除しました：",
  deletedwarningsfor = "すべての警告を削除しました：",
  cantopenconsole = "サーバーコンソールからメニューを開くことはできません。",
  invalidoption = "無効なオプションです。",
  invalidoptionvaluetype = "オプションの値の種類が無効です。",
  optionsloaded = "オプションを読み込みました！",
  nopunishment = "この警告数に対する処罰はありません。",
  punishmentsloaded = "処罰を読み込みました！",
  playernotallowedwarn = "このプレイヤーは警告できません。",
  warnmessage1 = "%s から警告を受けました。理由：%s。",
  warnmessage2 = "%s を警告しました。理由：%s。",
  warnmessage3 = "%s が %s から警告を受けました。理由：%s。",
  warnmessage4 = "%s から警告を受けました。",
  warnmessage5 = "%s を警告しました。",
  warnmessage6 = "%s が %s から警告を受けました。",
  joinmessage1 = "警告を持ったままサーバーに参加しました。",
  joinmessage2 = "最後の警告は次の日付です：",
  joinmessage3 = "おかえりなさい！以前に警告を受けているようです。",
  joinmessage4 = "次のコマンドを入力するといつでも自分の警告を確認できます：",
  joinmessage5 = "アクティブな警告を持つプレイヤーが参加：",
  closemenu = "メニューを閉じる",
  searchplayers = "プレイヤー検索",
  viewwarnings = "警告",
  configuration = "設定",
  clientoptions = "ユーザーオプション",
  serveroptions = "サーバーオプション",
  colorcustomization = "カラー設定",
  colorselection = "カラー選択",
  languageconfiguration = "言語設定",
  selectlanguage = "言語を選択",
  enablekickpunish = "キック処罰を有効化",
  enablebanpunish = "BAN処罰を有効化",
  enabledecay = "警告の自動減少を有効化",
  resetafterban = "BAN後にアクティブ警告をリセット",
  allowwarnadmins = "管理者に警告を許可",
  clientjoinmessage = "参加時にプレイヤーへ警告数を表示",
  adminjoinmessage = "警告を持つプレイヤーが参加した時に管理者へ通知",
  pressenter = "Enterを押して保存",
  entertosave = "Enterで保存",
  chatprefix = "チャットプレフィックス",
  warningdecayrate = "警告減少速度",
  serverlanguage = "サーバー言語",
  punishmentsconfiguration = "処罰設定",
  addpunishment = "処罰を追加",
  warnings = "警告",
  punishtype = "処罰の種類",
  punishlength = "処罰の長さ",
  playermessage = "プレイヤーへのメッセージ",
  playername = "プレイヤー名",
  messagetoplayer = "プレイヤーへのメッセージ",
  servermessage = "サーバーメッセージ",
  messagetoserver = "サーバーへのメッセージ",
  deletewarning = "警告を削除",
  punishaddmenu = "処罰追加メニュー",
  inminutes = "分単位",
  ["0equalperma"] = "0 = 永久",
  ["use%"] = "%%s を使用してプレイヤー名を表示",
  setdefault = "デフォルトに設定",
  showingownwarnings = "自分の警告を表示中",
  warnedby = "警告者",
  warningserver = "警告サーバー",
  warningreason = "警告理由",
  warningdate = "警告日",
  nothing = "なし",
  submit = "送信",
  connectedplayers = "接続中のプレイヤー",
  displaywarningsfor = "警告を表示：",
  activewarnings = "アクティブ警告",
  selectedplayernowarnings = "選択したプレイヤーには警告がありません。",
  selectplayerseewarnings = "警告を確認するにはプレイヤーを選択してください。",
  warnplayer = "プレイヤーを警告",
  reduceactiveby1 = "アクティブ警告を1減らす",
  playerwarningmenu = "プレイヤー警告メニュー",
  playersearchmenu = "プレイヤー検索メニュー",
  warningplayer = "プレイヤーを警告中",
  excludeplayers = "警告履歴のないプレイヤーを除外",
  searchforplayers = "名前またはSteamID64でプレイヤーを検索",
  name = "名前",
  lastplayed = "最終プレイ",
  lastwarned = "最後の警告",
  never = "なし",
  playerid = "プレイヤーID",
  lookupplayerwarnings = "このプレイヤーの警告を表示",
  servername = "サーバー名",
  punishmentoptions = "処罰",
  kickpunishdescription = "有効化すると、AWarn3はプレイヤーをサーバーからキックできます。",
  banpunishdescription = "有効化すると、AWarn3はプレイヤーをサーバーからBANできます。",
  enabledecaydescription = "有効化すると、アクティブ警告は時間とともに減少します。",
  reasonrequireddescription = "有効化すると、管理者は警告時に理由を入力する必要があります。",
  resetafterbandescription = "有効化すると、プレイヤーがAWarn3によってBANされた後、アクティブ警告が0にリセットされます。",
  logevents = "警告イベントを記録",
  logeventsdescription = "有効化すると、AWarn3の操作はテキストファイルに記録されます。",
  allowwarnadminsdescription = "有効化すると、管理者は他の管理者を警告できます。",
  clientjoinmessagedescription = "有効化すると、プレイヤーは参加時に警告がある場合チャットで通知を受けます。",
  adminjoinmessagedescription = "有効化すると、管理者は警告を持つプレイヤーが参加した時に通知を受けます。",
  chatprefixdescription = "AWarn3のコマンドに使用するチャットプレフィックス。デフォルト: !warn",
  warningdecayratedescription = "アクティブ警告を1減少させるためにプレイヤーが接続している必要がある時間（分）。",
  servernamedescription = "このサーバーの名前。複数サーバー構成に便利です。",
  selectlanguagedescription = "サーバーメッセージが表示される言語。",
  theme = "インターフェーステーマ",
  themeselect = "テーマを選択",
  punishgroup = "処罰グループ",
  grouptoset = "設定するグループ",
  viewnotes = "プレイヤーノートを見る",
  playernotes = "プレイヤーノート",
  interfacecustomizations = "インターフェースのカスタマイズ",
  enableblur = "背景のぼかしを有効化",
  chooseapreset = "プリセットを選択（任意）",
  warningpresets = "プリセット",
  addeditpreset = "プリセットの追加/編集",
  presetname = "プリセット名",
  presetreason = "プリセット理由",
  customcommand = "カスタムコマンド",
  customcommandplaceholder = "置換 — %n: プレイヤー名, %s: SteamID, %i: SteamID64",
  confirm = "確認",
  cancel = "キャンセル",
  deleteconfirmdialogue1 = "すべての警告を削除することを確認",
  deleteconfirmdialogue2 = "このプレイヤーのすべての警告を削除しようとしています。",
  deleteconfirmdialogue3 = "この操作を確認してください。",
  removewhendeletewarning = "警告を削除する際にアクティブ警告を減らす",
  removewhendeletewarningdescription = "有効化すると、警告を削除する際に1つのアクティブ警告が減少します。",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
