--[[
  AWarn3 Localization: TH-TH (ภาษาไทย)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Thai translation for servers.
]]

local LANGUAGE_CODE = "TH"
local LANGUAGE_NAME = "ไทย"

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
  welcome1 = "ยินดีต้อนรับสู่ AWarn3!",
  insufficientperms = "ไม่มีสิทธิ์เพียงพอในการรันคำสั่งนี้.",
  insufficientperms2 = "ไม่มีสิทธิ์เพียงพอในการดูคำเตือนของผู้เล่นคนนี้.",
  commandnonexist = "คำสั่งนี้ไม่มีอยู่.",
  invalidtargetid = "เป้าหมายหรือไอดีไม่ถูกต้อง.",
  invalidtarget = "เป้าหมายไม่ถูกต้อง.",
  reasonrequired = "ต้องระบุเหตุผลในการเตือน.",
  remove1activewarn = "คุณลบคำเตือนที่ใช้งานอยู่ 1 รายการจาก",
  deletedwarningid = "ลบคำเตือนรหัส",
  removeallwarnings = "คุณลบคำเตือนทั้งหมดจาก",
  deletedwarningsfor = "ลบคำเตือนทั้งหมดของ",
  cantopenconsole = "ไม่สามารถเปิดเมนูจากคอนโซลเซิร์ฟเวอร์ได้.",
  invalidoption = "ตัวเลือกไม่ถูกต้อง.",
  invalidoptionvaluetype = "ประเภทค่าของตัวเลือกไม่ถูกต้อง.",
  optionsloaded = "โหลดตัวเลือกแล้ว!",
  nopunishment = "ไม่มีโทษสำหรับจำนวนคำเตือนนี้.",
  punishmentsloaded = "โหลดโทษแล้ว!",
  playernotallowedwarn = "ผู้เล่นรายนี้ไม่สามารถถูกเตือนได้.",
  warnmessage1 = "คุณถูกเตือนโดย %s เนื่องจาก %s.",
  warnmessage2 = "คุณเตือน %s เนื่องจาก %s.",
  warnmessage3 = "%s ถูกเตือนโดย %s เนื่องจาก %s.",
  warnmessage4 = "คุณถูกเตือนโดย %s.",
  warnmessage5 = "คุณเตือน %s.",
  warnmessage6 = "%s ถูกเตือนโดย %s.",
  joinmessage1 = "ได้เข้าร่วมเซิร์ฟเวอร์พร้อมมีคำเตือน.",
  joinmessage2 = "คำเตือนล่าสุดคือ:",
  joinmessage3 = "ยินดีต้อนรับกลับ! ดูเหมือนว่าคุณเคยถูกเตือนมาก่อน.",
  joinmessage4 = "คุณสามารถดูคำเตือนของคุณได้ทุกเมื่อโดยพิมพ์",
  joinmessage5 = "ผู้เล่นกำลังเข้าร่วมพร้อมคำเตือนที่ยังใช้งาน:",
  closemenu = "ปิดเมนู",
  searchplayers = "ค้นหาผู้เล่น",
  viewwarnings = "คำเตือน",
  configuration = "การตั้งค่า",
  clientoptions = "ตัวเลือกผู้ใช้",
  serveroptions = "ตัวเลือกเซิร์ฟเวอร์",
  colorcustomization = "ปรับแต่งสี",
  colorselection = "เลือกสี",
  languageconfiguration = "ปรับแต่งภาษา",
  selectlanguage = "เลือกภาษา",
  enablekickpunish = "เปิดใช้โทษการเตะ",
  enablebanpunish = "เปิดใช้โทษการแบน",
  enabledecay = "เปิดใช้การลดคำเตือนอัตโนมัติ",
  resetafterban = "รีเซ็ตคำเตือนที่ใช้งานหลังการแบน",
  allowwarnadmins = "อนุญาตให้เตือนผู้ดูแล",
  clientjoinmessage = "แสดงจำนวนคำเตือนให้ผู้เล่นเมื่อเข้าร่วม",
  adminjoinmessage = "แจ้งผู้ดูแลเมื่อมีผู้เล่นที่มีคำเตือนเข้าร่วม",
  pressenter = "กด Enter เพื่อบันทึกการเปลี่ยนแปลง",
  entertosave = "Enter เพื่อบันทึก",
  chatprefix = "คำขึ้นต้นแชท",
  warningdecayrate = "อัตราการลดคำเตือน",
  serverlanguage = "ภาษาของเซิร์ฟเวอร์",
  punishmentsconfiguration = "การตั้งค่าโทษ",
  addpunishment = "เพิ่มโทษ",
  warnings = "คำเตือน",
  punishtype = "ประเภทโทษ",
  punishlength = "ระยะเวลาโทษ",
  playermessage = "ข้อความถึงผู้เล่น",
  playername = "ชื่อผู้เล่น",
  messagetoplayer = "ข้อความถึงผู้เล่น",
  servermessage = "ข้อความเซิร์ฟเวอร์",
  messagetoserver = "ข้อความถึงเซิร์ฟเวอร์",
  deletewarning = "ลบคำเตือน",
  punishaddmenu = "เมนูเพิ่มโทษ",
  inminutes = "เป็นนาที",
  ["0equalperma"] = "0 = ถาวร",
  ["use%"] = "ใช้ %%s เพื่อแสดงชื่อผู้เล่น",
  setdefault = "ตั้งเป็นค่าเริ่มต้น",
  showingownwarnings = "แสดงคำเตือนของคุณเอง",
  warnedby = "เตือนโดย",
  warningserver = "เซิร์ฟเวอร์ที่เตือน",
  warningreason = "เหตุผลการเตือน",
  warningdate = "วันที่เตือน",
  nothing = "ไม่มีอะไร",
  submit = "ยืนยัน",
  connectedplayers = "ผู้เล่นที่เชื่อมต่อ",
  displaywarningsfor = "แสดงคำเตือนของ",
  activewarnings = "คำเตือนที่ใช้งาน",
  selectedplayernowarnings = "ผู้เล่นที่เลือกไม่มีคำเตือนในบันทึก.",
  selectplayerseewarnings = "เลือกผู้เล่นเพื่อดูคำเตือนของเขา.",
  warnplayer = "เตือนผู้เล่น",
  reduceactiveby1 = "ลดคำเตือนที่ใช้งานลง 1",
  playerwarningmenu = "เมนูคำเตือนผู้เล่น",
  playersearchmenu = "เมนูค้นหาผู้เล่น",
  warningplayer = "กำลังเตือนผู้เล่น",
  excludeplayers = "ไม่รวมผู้เล่นที่ไม่มีประวัติคำเตือน",
  searchforplayers = "ค้นหาผู้เล่นตามชื่อหรือ SteamID64",
  name = "ชื่อ",
  lastplayed = "เล่นล่าสุด",
  lastwarned = "เตือนล่าสุด",
  never = "ไม่เคย",
  playerid = "ไอดีผู้เล่น",
  lookupplayerwarnings = "ดูคำเตือนของผู้เล่นคนนี้",
  servername = "ชื่อเซิร์ฟเวอร์",
  punishmentoptions = "โทษ",
  kickpunishdescription = "หากเปิดใช้ AWarn3 สามารถเตะผู้เล่นออกจากเซิร์ฟเวอร์เป็นการลงโทษ.",
  banpunishdescription = "หากเปิดใช้ AWarn3 สามารถแบนผู้เล่นจากเซิร์ฟเวอร์เป็นการลงโทษ.",
  enabledecaydescription = "หากเปิดใช้ คำเตือนที่ใช้งานจะค่อย ๆ ลดลงตามเวลา.",
  reasonrequireddescription = "หากเปิดใช้ ผู้ดูแลต้องระบุเหตุผลเมื่อทำการเตือน.",
  resetafterbandescription = "หากเปิดใช้ คำเตือนที่ใช้งานของผู้ใช้จะถูกรีเซ็ตเป็น 0 หลังถูกแบนโดย AWarn3.",
  logevents = "บันทึกเหตุการณ์คำเตือน",
  logeventsdescription = "หากเปิดใช้ การกระทำภายใน AWarn3 จะถูกบันทึกลงไฟล์ข้อความ.",
  allowwarnadminsdescription = "หากเปิดใช้ ผู้ดูแลสามารถเตือนผู้ดูแลคนอื่นได้.",
  clientjoinmessagedescription = "หากเปิดใช้ ผู้เล่นที่เข้าร่วมจะเห็นข้อความในแชทหากมีคำเตือน.",
  adminjoinmessagedescription = "หากเปิดใช้ ผู้ดูแลจะเห็นเมื่อผู้เล่นที่มีคำเตือนเข้าร่วม.",
  chatprefixdescription = "คำสั่งแชทที่ใช้กับคำสั่งของ AWarn3 ค่าเริ่มต้น: !warn",
  warningdecayratedescription = "ระยะเวลา (นาที) ที่ผู้เล่นต้องเชื่อมต่อต่อเนื่องเพื่อให้คำเตือนที่ใช้งานลดลง 1.",
  servernamedescription = "ชื่อของเซิร์ฟเวอร์นี้ มีประโยชน์เมื่อมีหลายเซิร์ฟเวอร์.",
  selectlanguagedescription = "ภาษาที่จะแสดงข้อความของเซิร์ฟเวอร์.",
  theme = "ธีมส่วนติดต่อ",
  themeselect = "เลือกธีม",
  punishgroup = "กลุ่มโทษ",
  grouptoset = "กลุ่มที่จะตั้งค่า",
  viewnotes = "ดูบันทึกของผู้เล่น",
  playernotes = "บันทึกของผู้เล่น",
  interfacecustomizations = "ปรับแต่งส่วนติดต่อ",
  enableblur = "เปิดใช้การเบลอพื้นหลัง",
  chooseapreset = "เลือกพรีเซ็ต (ไม่บังคับ)",
  warningpresets = "พรีเซ็ต",
  addeditpreset = "เพิ่ม/แก้ไขพรีเซ็ต",
  presetname = "ชื่อพรีเซ็ต",
  presetreason = "เหตุผลพรีเซ็ต",
  customcommand = "คำสั่งกำหนดเอง",
  customcommandplaceholder = "การแทนที่ — %n: ชื่อผู้เล่น, %s: SteamID, %i: SteamID64",
  confirm = "ยืนยัน",
  cancel = "ยกเลิก",
  deleteconfirmdialogue1 = "ยืนยันการลบคำเตือนทั้งหมด",
  deleteconfirmdialogue2 = "คุณกำลังจะลบคำเตือนทั้งหมดของผู้เล่นคนนี้.",
  deleteconfirmdialogue3 = "โปรดยืนยันการดำเนินการนี้.",
  removewhendeletewarning = "ลบคำเตือนที่ใช้งานเมื่อมีการลบคำเตือน",
  removewhendeletewarningdescription = "หากเปิดใช้ จะลบคำเตือนที่ใช้งาน 1 รายการเมื่อคำเตือนถูกลบ.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
