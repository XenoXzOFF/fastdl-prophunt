--[[
  AWarn3 Localization: TR-TR (Türkçe)
  Notes:
    - Keys unchanged for compatibility.
    - Placeholders (%s, %n, %i) preserved.
    - Neutral Turkish translation.
]]

local LANGUAGE_CODE = "TR-TR"
local LANGUAGE_NAME = "Türkçe"

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
  welcome1 = "AWarn3'e Hoş Geldiniz!",
  insufficientperms = "Bu komutu çalıştırmak için yetkiniz yok.",
  insufficientperms2 = "Bu oyuncunun uyarılarını görüntülemek için yetkiniz yok.",
  commandnonexist = "Bu komut mevcut değil.",
  invalidtargetid = "Geçersiz hedef veya ID.",
  invalidtarget = "Geçersiz hedef.",
  reasonrequired = "Uyarı için bir sebep gereklidir.",
  remove1activewarn = "1 aktif uyarıyı kaldırdınız:",
  deletedwarningid = "Silinen uyarı ID",
  removeallwarnings = "Tüm uyarıları kaldırdınız:",
  deletedwarningsfor = "Tüm uyarılar silindi:",
  cantopenconsole = "Menüyü sunucu konsolundan açamazsınız.",
  invalidoption = "Geçersiz seçenek.",
  invalidoptionvaluetype = "Seçenek için geçersiz değer türü.",
  optionsloaded = "Ayarlar yüklendi!",
  nopunishment = "Bu uyarı sayısı için ceza yok.",
  punishmentsloaded = "Cezalar yüklendi!",
  playernotallowedwarn = "Bu oyuncuya uyarı verilemez.",
  warnmessage1 = "%s tarafından %s sebebiyle uyarıldınız.",
  warnmessage2 = "%s oyuncusunu %s sebebiyle uyardınız.",
  warnmessage3 = "%s, %s tarafından %s sebebiyle uyarıldı.",
  warnmessage4 = "%s tarafından uyarıldınız.",
  warnmessage5 = "%s oyuncusunu uyardınız.",
  warnmessage6 = "%s, %s tarafından uyarıldı.",
  joinmessage1 = "uyarılarla sunucuya katıldı.",
  joinmessage2 = "Son uyarısı şu tarihteydi:",
  joinmessage3 = "Tekrar hoş geldiniz! Daha önce uyarı aldığınız görünüyor.",
  joinmessage4 = "Uyarılarınızı görmek için istediğiniz zaman şunu yazabilirsiniz:",
  joinmessage5 = "Oyuncu aktif uyarılarla katılıyor:",
  closemenu = "Menüyü Kapat",
  searchplayers = "Oyuncu Ara",
  viewwarnings = "Uyarılar",
  configuration = "Ayarlar",
  clientoptions = "Kullanıcı Seçenekleri",
  serveroptions = "Sunucu Seçenekleri",
  colorcustomization = "Renk Özelleştirme",
  colorselection = "Renk Seçimi",
  languageconfiguration = "Dil Ayarları",
  selectlanguage = "Dil Seç",
  enablekickpunish = "Kick Cezasını Etkinleştir",
  enablebanpunish = "Ban Cezasını Etkinleştir",
  enabledecay = "Aktif Uyarıların Zamanla Azalmasını Etkinleştir",
  resetafterban = "Ban Sonrası Aktif Uyarıları Sıfırla",
  allowwarnadmins = "Yöneticilere Uyarı Verilmesine İzin Ver",
  clientjoinmessage = "Oyuncuya girişte uyarı sayısını göster",
  adminjoinmessage = "Oyuncu uyarılarla katıldığında yöneticilere mesaj göster",
  pressenter = "Kaydetmek için Enter'a basın",
  entertosave = "Enter ile Kaydet",
  chatprefix = "Sohbet Ön Eki",
  warningdecayrate = "Uyarı Azalma Oranı",
  serverlanguage = "Sunucu Dili",
  punishmentsconfiguration = "Ceza Yapılandırması",
  addpunishment = "Ceza Ekle",
  warnings = "Uyarılar",
  punishtype = "Ceza Türü",
  punishlength = "Ceza Süresi",
  playermessage = "Oyuncuya Mesaj",
  playername = "Oyuncu Adı",
  messagetoplayer = "Oyuncuya Mesaj",
  servermessage = "Sunucu Mesajı",
  messagetoserver = "Sunucuya Mesaj",
  deletewarning = "Uyarıyı Sil",
  punishaddmenu = "Ceza Ekleme Menüsü",
  inminutes = "Dakika Cinsinden",
  ["0equalperma"] = "0 = Kalıcı",
  ["use%"] = "Oyuncu adını göstermek için %%s kullanın",
  setdefault = "Varsayılan Olarak Ayarla",
  showingownwarnings = "Kendi uyarılarınız görüntüleniyor",
  warnedby = "Uyaran",
  warningserver = "Uyarı Sunucusu",
  warningreason = "Uyarı Sebebi",
  warningdate = "Uyarı Tarihi",
  nothing = "HİÇBİR ŞEY",
  submit = "Onayla",
  connectedplayers = "Bağlı Oyuncular",
  displaywarningsfor = "Şu oyuncunun uyarıları gösteriliyor:",
  activewarnings = "Aktif Uyarılar",
  selectedplayernowarnings = "Seçilen oyuncunun kayıtlı uyarısı yok.",
  selectplayerseewarnings = "Bir oyuncu seçerek uyarılarını görün.",
  warnplayer = "Oyuncuya Uyarı Ver",
  reduceactiveby1 = "Aktif uyarıları 1 azalt",
  playerwarningmenu = "Oyuncu Uyarı Menüsü",
  playersearchmenu = "Oyuncu Arama Menüsü",
  warningplayer = "Oyuncuya Uyarı Veriliyor",
  excludeplayers = "Uyarı geçmişi olmayan oyuncuları hariç tut",
  searchforplayers = "Oyuncuları isim veya SteamID64 ile ara",
  name = "Ad",
  lastplayed = "Son Oynama",
  lastwarned = "Son Uyarı",
  never = "Asla",
  playerid = "Oyuncu ID",
  lookupplayerwarnings = "Bu oyuncunun uyarılarını görüntüle",
  servername = "Sunucu Adı",
  punishmentoptions = "Cezalar",
  kickpunishdescription = "Etkinleştirilirse AWarn3, oyuncuları sunucudan kick ile çıkarabilir.",
  banpunishdescription = "Etkinleştirilirse AWarn3, oyuncuları sunucudan banlayabilir.",
  enabledecaydescription = "Etkinleştirilirse aktif uyarılar zamanla azalır.",
  reasonrequireddescription = "Etkinleştirilirse yöneticiler uyarı verirken bir sebep girmek zorunda kalır.",
  resetafterbandescription = "Etkinleştirilirse, bir oyuncunun aktif uyarıları AWarn3 tarafından banlandıktan sonra sıfırlanır.",
  logevents = "Uyarı Olaylarını Kaydet",
  logeventsdescription = "Etkinleştirilirse AWarn3 içindeki eylemler bir metin dosyasına kaydedilir.",
  allowwarnadminsdescription = "Etkinleştirilirse yöneticiler diğer yöneticilere uyarı verebilir.",
  clientjoinmessagedescription = "Etkinleştirilirse oyuncular giriş yaptığında uyarıları varsa sohbet mesajı görür.",
  adminjoinmessagedescription = "Etkinleştirilirse yöneticiler, uyarıları olan bir oyuncu giriş yaptığında bilgilendirilir.",
  chatprefixdescription = "AWarn3 komutları için sohbet ön eki. Varsayılan: !warn",
  warningdecayratedescription = "Bir oyuncunun 1 aktif uyarısının azalması için bağlı kalması gereken süre (dakika).",
  servernamedescription = "Bu sunucunun adı. Birden fazla sunucu kurulumunda faydalıdır.",
  selectlanguagedescription = "Sunucu mesajlarının görüntüleneceği dil.",
  theme = "Arayüz Teması",
  themeselect = "Tema Seç",
  punishgroup = "Ceza Grubu",
  grouptoset = "Ayarlanacak Grup",
  viewnotes = "Oyuncu Notlarını Gör",
  playernotes = "Oyuncu Notları",
  interfacecustomizations = "Arayüz Özelleştirmeleri",
  enableblur = "Arka Plan Bulanıklığını Etkinleştir",
  chooseapreset = "Bir preset seç (Opsiyonel)",
  warningpresets = "Presetler",
  addeditpreset = "Preset Ekle/Düzenle",
  presetname = "Preset Adı",
  presetreason = "Preset Sebebi",
  customcommand = "Özel Komut",
  customcommandplaceholder = "Değişkenler — %n: Oyuncu Adı, %s: SteamID, %i: SteamID64",
  confirm = "Onayla",
  cancel = "İptal",
  deleteconfirmdialogue1 = "Tüm Uyarıları Silmeyi Onayla",
  deleteconfirmdialogue2 = "Bu oyuncunun tüm uyarılarını silmek üzeresiniz.",
  deleteconfirmdialogue3 = "Lütfen bu işlemi onaylayın.",
  removewhendeletewarning = "Uyarı silindiğinde aktif uyarıyı kaldır",
  removewhendeletewarningdescription = "Etkinleştirilirse, bir uyarı silindiğinde 1 aktif uyarı kaldırılır.",
  _lang_version = "1.0.0",
}

for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
