--[[
  AWarn3 Localization: KO-KR (한국어)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Korean translation.
]]

local LANGUAGE_CODE = "KO-KR"
local LANGUAGE_NAME = "한국어"

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
  welcome1 = "AWarn3에 오신 것을 환영합니다!",
  insufficientperms = "이 명령어를 실행할 권한이 없습니다.",
  insufficientperms2 = "이 플레이어의 경고를 볼 권한이 없습니다.",
  commandnonexist = "이 명령어는 존재하지 않습니다.",
  invalidtargetid = "잘못된 대상 또는 ID입니다.",
  invalidtarget = "잘못된 대상입니다.",
  reasonrequired = "경고 사유를 입력해야 합니다.",
  remove1activewarn = "다음 플레이어의 활성 경고 1개를 제거했습니다:",
  deletedwarningid = "삭제된 경고 ID",
  removeallwarnings = "다음 플레이어의 모든 경고를 제거했습니다:",
  deletedwarningsfor = "모든 경고가 삭제되었습니다:",
  cantopenconsole = "서버 콘솔에서는 메뉴를 열 수 없습니다.",
  invalidoption = "잘못된 옵션입니다.",
  invalidoptionvaluetype = "잘못된 옵션 값 유형입니다.",
  optionsloaded = "옵션이 로드되었습니다!",
  nopunishment = "이 경고 횟수에는 처벌이 없습니다.",
  punishmentsloaded = "처벌이 로드되었습니다!",
  playernotallowedwarn = "이 플레이어는 경고할 수 없습니다.",
  warnmessage1 = "%s님에게 %s 사유로 경고를 받았습니다.",
  warnmessage2 = "%s님에게 %s 사유로 경고를 주었습니다.",
  warnmessage3 = "%s님이 %s님에게 %s 사유로 경고를 받았습니다.",
  warnmessage4 = "%s님에게 경고를 받았습니다.",
  warnmessage5 = "%s님에게 경고를 주었습니다.",
  warnmessage6 = "%s님이 %s님에게 경고를 받았습니다.",
  joinmessage1 = "경고가 있는 상태로 서버에 접속했습니다.",
  joinmessage2 = "마지막 경고 날짜:",
  joinmessage3 = "다시 오신 것을 환영합니다! 이전에 경고를 받은 적이 있습니다.",
  joinmessage4 = "아래 명령어를 입력하면 언제든지 자신의 경고를 확인할 수 있습니다:",
  joinmessage5 = "활성 경고가 있는 플레이어가 접속 중:",
  closemenu = "메뉴 닫기",
  searchplayers = "플레이어 검색",
  viewwarnings = "경고",
  configuration = "설정",
  clientoptions = "사용자 옵션",
  serveroptions = "서버 옵션",
  colorcustomization = "색상 사용자 정의",
  colorselection = "색상 선택",
  languageconfiguration = "언어 설정",
  selectlanguage = "언어 선택",
  enablekickpunish = "강퇴 처벌 활성화",
  enablebanpunish = "차단 처벌 활성화",
  enabledecay = "활성 경고 자동 감소 활성화",
  resetafterban = "차단 후 활성 경고 초기화",
  allowwarnadmins = "관리자에게도 경고 허용",
  clientjoinmessage = "플레이어 접속 시 경고 수 표시",
  adminjoinmessage = "경고가 있는 플레이어 접속 시 관리자에게 알림",
  pressenter = "저장하려면 Enter를 누르세요",
  entertosave = "Enter로 저장",
  chatprefix = "채팅 접두사",
  warningdecayrate = "경고 감소 속도",
  serverlanguage = "서버 언어",
  punishmentsconfiguration = "처벌 설정",
  addpunishment = "처벌 추가",
  warnings = "경고",
  punishtype = "처벌 유형",
  punishlength = "처벌 기간",
  playermessage = "플레이어에게 보낼 메시지",
  playername = "플레이어 이름",
  messagetoplayer = "플레이어에게 보낼 메시지",
  servermessage = "서버 메시지",
  messagetoserver = "서버에 보낼 메시지",
  deletewarning = "경고 삭제",
  punishaddmenu = "처벌 추가 메뉴",
  inminutes = "분 단위",
  ["0equalperma"] = "0 = 영구",
  ["use%"] = "플레이어 이름을 표시하려면 %%s를 사용하세요",
  setdefault = "기본값으로 설정",
  showingownwarnings = "자신의 경고 표시 중",
  warnedby = "경고한 사람",
  warningserver = "경고 서버",
  warningreason = "경고 사유",
  warningdate = "경고 날짜",
  nothing = "없음",
  submit = "확인",
  connectedplayers = "접속 중인 플레이어",
  displaywarningsfor = "경고 표시 대상:",
  activewarnings = "활성 경고",
  selectedplayernowarnings = "선택한 플레이어는 경고 기록이 없습니다.",
  selectplayerseewarnings = "플레이어를 선택하면 경고를 볼 수 있습니다.",
  warnplayer = "플레이어에게 경고",
  reduceactiveby1 = "활성 경고 1개 감소",
  playerwarningmenu = "플레이어 경고 메뉴",
  playersearchmenu = "플레이어 검색 메뉴",
  warningplayer = "플레이어 경고 중",
  excludeplayers = "경고 기록이 없는 플레이어 제외",
  searchforplayers = "이름 또는 SteamID64로 플레이어 검색",
  name = "이름",
  lastplayed = "마지막 플레이",
  lastwarned = "마지막 경고",
  never = "없음",
  playerid = "플레이어 ID",
  lookupplayerwarnings = "이 플레이어의 경고 확인",
  servername = "서버 이름",
  punishmentoptions = "처벌",
  kickpunishdescription = "활성화 시 AWarn3는 플레이어를 서버에서 강퇴할 수 있습니다.",
  banpunishdescription = "활성화 시 AWarn3는 플레이어를 서버에서 차단할 수 있습니다.",
  enabledecaydescription = "활성화 시 활성 경고가 시간이 지나면 자동으로 감소합니다.",
  reasonrequireddescription = "활성화 시 관리자는 경고를 줄 때 반드시 사유를 입력해야 합니다.",
  resetafterbandescription = "활성화 시 플레이어가 AWarn3에 의해 차단되면 활성 경고가 0으로 초기화됩니다.",
  logevents = "경고 이벤트 기록",
  logeventsdescription = "활성화 시 AWarn3 동작이 텍스트 파일에 기록됩니다.",
  allowwarnadminsdescription = "활성화 시 관리자가 다른 관리자를 경고할 수 있습니다.",
  clientjoinmessagedescription = "활성화 시 플레이어는 접속 시 경고가 있으면 채팅 메시지를 봅니다.",
  adminjoinmessagedescription = "활성화 시 관리자는 경고가 있는 플레이어가 접속하면 알림을 받습니다.",
  chatprefixdescription = "AWarn3 명령어에 사용되는 채팅 접두사. 기본값: !warn",
  warningdecayratedescription = "플레이어가 연결된 상태를 유지해야 하는 시간(분) — 활성 경고 1개가 줄어듭니다.",
  servernamedescription = "이 서버의 이름. 여러 서버 환경에서 유용합니다.",
  selectlanguagedescription = "서버 메시지가 표시될 언어입니다.",
  theme = "인터페이스 테마",
  themeselect = "테마 선택",
  punishgroup = "처벌 그룹",
  grouptoset = "설정할 그룹",
  viewnotes = "플레이어 노트 보기",
  playernotes = "플레이어 노트",
  interfacecustomizations = "인터페이스 사용자 정의",
  enableblur = "배경 흐림 효과 활성화",
  chooseapreset = "프리셋 선택 (선택 사항)",
  warningpresets = "프리셋",
  addeditpreset = "프리셋 추가/편집",
  presetname = "프리셋 이름",
  presetreason = "프리셋 사유",
  customcommand = "사용자 지정 명령어",
  customcommandplaceholder = "치환 — %n: 플레이어 이름, %s: SteamID, %i: SteamID64",
  confirm = "확인",
  cancel = "취소",
  deleteconfirmdialogue1 = "모든 경고 삭제 확인",
  deleteconfirmdialogue2 = "이 플레이어의 모든 경고를 삭제하려고 합니다.",
  deleteconfirmdialogue3 = "이 작업을 확인해 주세요.",
  removewhendeletewarning = "경고 삭제 시 활성 경고도 제거",
  removewhendeletewarningdescription = "활성화 시 경고가 삭제될 때 활성 경고 1개가 제거됩니다.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
