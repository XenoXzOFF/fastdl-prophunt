--[[
  AWarn3 Localization: EN-US (American English)
  Notes:
    - Keys are unchanged for compatibility.
    - Instructional strings that include % now use %% to avoid accidental string.format issues.
    - Grammar/punctuation normalized; minor typos fixed.
    - Light guards added around AWarn.Localization usage.
]]

local LANGUAGE_CODE = "EN-US"
local LANGUAGE_NAME = "American English"

local L = AWarn and AWarn.Localization
if not L then
  -- Fallback stub prevents errors if this file loads early.
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

-- Register language
L:RegisterLanguage(LANGUAGE_CODE, LANGUAGE_NAME)

-- Centralized defs (keys preserved)
local defs = {
  welcome1 = "Welcome to AWarn3!",
  insufficientperms = "Insufficient permissions to run this command.",
  insufficientperms2 = "Insufficient permissions to view this player's warnings.",
  commandnonexist = "This command does not exist.",
  invalidtargetid = "Invalid target or ID.",
  invalidtarget = "Invalid target.",
  reasonrequired = "Warning reason is required.",
  remove1activewarn = "You removed 1 active warning from",
  deletedwarningid = "Deleted warning ID",
  removeallwarnings = "You removed all warnings from",
  deletedwarningsfor = "Deleted all warnings for",
  cantopenconsole = "You can't open the menu from the server console.",
  invalidoption = "Invalid option.",
  invalidoptionvaluetype = "Invalid option value type.",
  optionsloaded = "Options loaded!",
  nopunishment = "No punishment for this warning count.",
  punishmentsloaded = "Punishments loaded!",
  playernotallowedwarn = "This player is not allowed to be warned.",
  warnmessage1 = "You were warned by %s for %s.",
  warnmessage2 = "You warned %s for %s.",
  warnmessage3 = "%s was warned by %s for %s.",
  warnmessage4 = "You were warned by %s.",
  warnmessage5 = "You warned %s.",
  warnmessage6 = "%s was warned by %s.",
  joinmessage1 = "has joined the server with warnings.",
  joinmessage2 = "Their last warning was on:",
  joinmessage3 = "Welcome back to the server! It appears you have been warned in the past.",
  joinmessage4 = "You can view your warnings at any time by typing",
  joinmessage5 = "Player is joining with active warnings:",
  closemenu = "Close Menu",
  searchplayers = "Search Players",
  viewwarnings = "Warnings",
  configuration = "Configuration",
  clientoptions = "User Options",
  serveroptions = "Server Options",
  colorcustomization = "Color Customization",
  colorselection = "Color Selection",
  languageconfiguration = "Language Customization",
  selectlanguage = "Select a Language",
  enablekickpunish = "Enable Kick Punishment",
  enablebanpunish = "Enable Ban Punishment",
  enabledecay = "Enable Active Warning Decay",
  resetafterban = "Reset Active Warnings After Ban",
  allowwarnadmins = "Allow Warn Admins",
  clientjoinmessage = "Display warning count to player on join",
  adminjoinmessage = "Display message to admins when a player joins with warnings",
  pressenter = "Press Enter to save change",
  entertosave = "Enter to Save",
  chatprefix = "Chat Prefix",
  warningdecayrate = "Warning Decay Rate",
  serverlanguage = "Server Language",
  punishmentsconfiguration = "Punishment Configuration",
  addpunishment = "Add Punishment",
  warnings = "Warnings",
  punishtype = "Punishment Type",
  punishlength = "Punishment Length",
  playermessage = "Player Message",
  playername = "Player Name",
  messagetoplayer = "Message to Player",
  servermessage = "Server Message",
  messagetoserver = "Message to Server",
  deletewarning = "Delete Warning",
  punishaddmenu = "Punishment Add Menu",
  inminutes = "In Minutes",
  ["0equalperma"] = "0 = Permanent",
  -- Escaped to avoid accidental formatting when displayed literally:
  ["use%"] = "Use %%s to show the player's name",
  setdefault = "Set Default",
  showingownwarnings = "Showing your own warnings",
  warnedby = "Warned By",
  warningserver = "Warning Server",
  warningreason = "Warning Reason",
  warningdate = "Warning Date",
  nothing = "NOTHING",
  submit = "Submit",
  connectedplayers = "Connected Players",
  displaywarningsfor = "Displaying Warnings For",
  activewarnings = "Active Warnings",
  selectedplayernowarnings = "Selected player has no warnings on record.",
  selectplayerseewarnings = "Select a player to see their warnings.",
  warnplayer = "Warn Player",
  reduceactiveby1 = "Reduce active warnings by 1",
  playerwarningmenu = "Player Warning Menu",
  playersearchmenu = "Player Search Menu",
  warningplayer = "Warning Player",
  excludeplayers = "Exclude players with no warning history",
  searchforplayers = "Search for players by name or SteamID64",
  name = "Name",
  lastplayed = "Last Played",
  lastwarned = "Last Warned",
  never = "Never",
  playerid = "Player ID",
  lookupplayerwarnings = "Lookup this player's warnings",
  servername = "Server Name",
  punishmentoptions = "Punishments",
  kickpunishdescription = "If enabled, AWarn3 can kick players from the server as a punishment.",
  banpunishdescription = "If enabled, AWarn3 can ban players from the server as a punishment.",
  enabledecaydescription = "If enabled, active warnings will decay over time.",
  reasonrequireddescription = "If enabled, admins will be required to provide a reason in their warning.",
  resetafterbandescription = "If enabled, a user's active warnings will reset to 0 after they are banned by AWarn3.",
  logevents = "Log Warning Events",
  logeventsdescription = "If enabled, actions within AWarn3 will be logged to a text file.",
  allowwarnadminsdescription = "If enabled, admins will be able to warn other admins.",
  clientjoinmessagedescription = "If enabled, users who join the server will see a chat message if they have warnings.",
  adminjoinmessagedescription = "If enabled, admins on the server will see when any player joins who has warnings.",
  chatprefixdescription = "The chat command used for AWarn3 commands. Default: !warn",
  warningdecayratedescription = "The time (in minutes) a player needs to be connected for one active warning to decay.",
  servernamedescription = "The name of this server. This is useful for multiple-server setups.",
  selectlanguagedescription = "This is the language that server messages will be displayed in.",
  theme = "Interface Theme",
  themeselect = "Select Theme",
  punishgroup = "Punishment Group",
  grouptoset = "Group to Set",
  viewnotes = "View Player Notes",
  playernotes = "Player Notes",
  interfacecustomizations = "Interface Customizations",
  enableblur = "Enable Background Blur",
  chooseapreset = "Choose a preset (optional)",
  warningpresets = "Presets",
  addeditpreset = "Add/Edit Preset",
  presetname = "Preset Name",
  presetreason = "Preset Reason",
  customcommand = "Custom Command",
  customcommandplaceholder = "Replacements — %n: Player Name, %s: SteamID, %i: SteamID64",
  confirm = "Confirm",
  cancel = "Cancel",
  deleteconfirmdialogue1 = "Confirm Delete All Warnings",
  deleteconfirmdialogue2 = "You are about to delete all of this player's warnings.",
  deleteconfirmdialogue3 = "Please confirm this action.",
  removewhendeletewarning = "Remove active warning when deleting warning",
  removewhendeletewarningdescription = "If enabled, 1 active warning will be removed from a player when a warning is deleted.",
  -- Optional meta (can be useful for diagnostics)
  _lang_version = "1.1.0",
}

-- Bulk register
for key, value in pairs(defs) do
  L:AddDefinition(LANGUAGE_CODE, key, value)
end
