--[[
      __          __              ____
     /\ \        / /             |___ \
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ <
  / ____ \  /\  / (_| | |  | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/

  AWarn3 by Mr.President
  Module: SQL (refactored)
]]

-- ////////////////////////////////////////////////////////////////////////
-- Boot
-- ////////////////////////////////////////////////////////////////////////
MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, "Loading SQL Module (refactor)\n")
include("includes/mysqlite_awarn3.lua")

-- ////////////////////////////////////////////////////////////////////////
-- Connection
-- ////////////////////////////////////////////////////////////////////////

-- EDIT HERE if you want to switch to MySQL.
function AWarn:ConnectToDatabase()
  AWarn3_MySQLite.initialize({
    EnableMySQL       = false,
    Host              = "localhost",
    Database_port     = 3306,
    Username          = "root",
    Password          = "",
    Database_name     = "awarn3",
    Preferred_module  = "mysqloo",  -- or tmysql4
    MultiStatements   = false
  })
end

-- ////////////////////////////////////////////////////////////////////////
-- Small Utilities
-- ////////////////////////////////////////////////////////////////////////

local function logInfo(msg)
  MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, msg .. "\n")
end

local function logErr(err, query)
  -- Keep original tone; add query echo in dev if needed
  MsgC(AWARN3_SERVER, "[AWarn3] ", AWARN3_WHITE, tostring(err) .. "\n")
end

local function now()
  return os.time()
end

local function sql(...) -- safe formatter that applies SQLStr to all string argv
  -- usage: sql("UPDATE t SET name=%s, n=%u WHERE id=%s", "bob", 3, "id64")
  local fmt, args = ..., { select(2, ...) }
  for i = 1, #args do
    if type(args[i]) == "string" then
      args[i] = AWarn3_MySQLite.SQLStr(args[i])
    end
  end
  return string.format(fmt, unpack(args))
end

local function hasPermOrTell(pl, perm, denyKey)
  if AWarn:CheckPermission(pl, perm) then return true end
  AWarn:SendChatMessage({ AWarn.Localization:GetTranslation(denyKey or "insufficientperms") }, pl)
  return false
end

local function clampWarnings(n)
  n = tonumber(n) or 0
  if n < 0 then return 0 end
  return n
end

-- ////////////////////////////////////////////////////////////////////////
-- Schema Creation
-- ////////////////////////////////////////////////////////////////////////

local function createConsolePlayer()
  local id = "[CONSOLE]"
  local q = sql("SELECT 1 FROM awarn3_playertable WHERE PlayerID = %s", id)
  AWarn3_MySQLite.query(q, function(result)
    if result then
      logInfo("Console Player Exists")
    else
      AWarn:CreatePlayerEntry(id, "Console", 0, false)
    end
  end, logErr)
end

local function createWarningTable()
  AWarn3_MySQLite.tableExists("awarn3_warningtable", function(exists)
    if exists then
      logInfo("Warning Table Exists")
      return
    end
    logInfo("Creating Warning Table... Stand by!")

    local isMySQL = AWarn3_MySQLite.isMySQL()
    local autoInc = isMySQL and "AUTO_INCREMENT" or "AUTOINCREMENT"

    local q = table.concat({
      "CREATE TABLE awarn3_warningtable (",
      "  WarningID INTEGER PRIMARY KEY " .. autoInc .. ",",
      "  PlayerID VARCHAR(20),",
      "  AdminID VARCHAR(20),",
      "  WarningReason TEXT,",
      "  WarningServer VARCHAR(255),",
      "  WarningDate INTEGER",
      ")"
    }, " ")

    AWarn3_MySQLite.query(q, function() createWarningTable() end, logErr)
  end, logErr)
end

local function createPlayerTable()
  AWarn3_MySQLite.tableExists("awarn3_playertable", function(exists)
    if exists then
      logInfo("Player Table Exists")
      createConsolePlayer()
      return
    end
    logInfo("Creating Player Table... Stand by!")

    local q = table.concat({
      "CREATE TABLE awarn3_playertable (",
      "  PlayerID VARCHAR(20) PRIMARY KEY,",
      "  PlayerName VARCHAR(32),",
      "  PlayerWarnings SMALLINT,",
      "  LastWarning INTEGER,",
      "  LastPlayed INTEGER,",
      "  LastWarningDecay INTEGER",
      ")"
    }, " ")

    AWarn3_MySQLite.query(q, function() createPlayerTable() end, logErr)
  end, logErr)
end

local function createNotesTable()
  AWarn3_MySQLite.tableExists("awarn3_notestable", function(exists)
    if exists then
      logInfo("Player Notes Table Exists")
      return
    end
    logInfo("Creating Player Notes Table... Stand by!")

    local q = table.concat({
      "CREATE TABLE awarn3_notestable (",
      "  PlayerID VARCHAR(20) PRIMARY KEY,",
      "  PlayerNotes MEDIUMTEXT",
      ")"
    }, " ")

    AWarn3_MySQLite.query(q, function() createNotesTable() end, logErr)
  end, logErr)
end

function AWarn:CreateTables()
  createWarningTable()
  createPlayerTable()
  createNotesTable()
end

-- Safer reset: handle MultiStatements=false by sequencing
function AWarn:ResetToDefaults()
  logInfo("Resetting AWarn3 to factory defaults.")
  local function recreate()
    AWarn:CreateTables()
    logInfo("Reset complete. Please restart your server to continue.")
  end

  if AWarn3_MySQLite.isMySQL() and AWarn3_MySQLite.getConfig and AWarn3_MySQLite.getConfig().MultiStatements then
    local q = "DROP TABLE IF EXISTS awarn3_warningtable; DROP TABLE IF EXISTS awarn3_playertable; DROP TABLE IF EXISTS awarn3_notestable"
    AWarn3_MySQLite.query(q, recreate, logErr)
  else
    AWarn3_MySQLite.query("DROP TABLE IF EXISTS awarn3_warningtable", function()
      AWarn3_MySQLite.query("DROP TABLE IF EXISTS awarn3_playertable", function()
        AWarn3_MySQLite.query("DROP TABLE IF EXISTS awarn3_notestable", recreate, logErr)
      end, logErr)
    end, logErr)
  end
end

hook.Add("AWarn3_DatabaseInitialized", "AWarn3_ConnectToDatabase", function()
  logInfo("Successfully connected to the database!")
  AWarn:CreateTables()
end)

-- ////////////////////////////////////////////////////////////////////////
-- Writes
-- ////////////////////////////////////////////////////////////////////////

function AWarn:CreateWarningID(playerID, adminID, reason)
  -- Defend inputs
  if (not reason or reason == "") and self:GetOption("awarn_reasonrequired") then return end

  reason   = reason and tostring(reason) or "NONE GIVEN"
  adminID  = adminID and tostring(adminID) or "CONSOLE"
  local serverName = AWarn:GetOption("awarn_server_name") or "UNNAMED"
  local tstamp     = now()

  -- Immunity / blacklist checks (if target is online we can validate)
  local pl    = AWarn:GetPlayerFromID64(playerID)
  local admin = AWarn:GetPlayerFromID64(adminID)

  if pl then
    if AWarn.Blacklist and AWarn.Blacklist.IsTargetBlockedFromWarn and AWarn.Blacklist:IsTargetBlockedFromWarn(pl) then
      if admin then AWarn:SendChatMessage({ AWarn.Localization:GetTranslation("playernotallowedwarn") }, admin) end
      return false, "This player is blacklisted from being warned."
    end
    if AWarn:CheckPermission(pl, "awarn_immune") then
      if admin then AWarn:SendChatMessage({ AWarn.Localization:GetTranslation("playernotallowedwarn") }, admin) end
      return
    end
  end

  local q = sql(
    "INSERT INTO awarn3_warningtable (PlayerID, AdminID, WarningReason, WarningServer, WarningDate) VALUES (%s, %s, %s, %s, %u)",
    playerID, adminID, reason, serverName, tstamp
  )

  AWarn3_MySQLite.query(q, function()
    AWarn:BroadcastWarningMessage(playerID, adminID, reason)
    AWarn:AddActiveWarning(playerID, 1)

    local target = AWarn:GetPlayerFromID64(playerID)
    if target then
      hook.Run("AWarnPlayerWarned", target, adminID, reason)
    else
      hook.Run("AWarnPlayerIDWarned", playerID, adminID, reason)
    end
  end, logErr)
end

function AWarn:AddActiveWarning(playerID, delta)
  delta = tonumber(delta) or 0
  local q = sql("SELECT PlayerWarnings FROM awarn3_playertable WHERE PlayerID = %s", playerID)

  AWarn3_MySQLite.query(q, function(result)
    if result and result[1] then
      local current = clampWarnings((tonumber(result[1].PlayerWarnings) or 0) + delta)
      local setLast = (delta > 0)
      AWarn:UpdatePlayerWarnings(playerID, current, setLast, setLast)
    else
      -- Create a new row; if delta < 0 clamp to 0
      AWarn:CreatePlayerEntry(playerID, "UNKNOWN", clampWarnings(delta), delta > 0)
    end
  end, logErr)
end

function AWarn:SavePlayerNotes(playerID, notes)
  notes = notes or ""
  local qCheck = sql("SELECT 1 FROM awarn3_notestable WHERE PlayerID = %s", playerID)

  AWarn3_MySQLite.query(qCheck, function(result)
    if result then
      local q = sql("UPDATE awarn3_notestable SET PlayerNotes = %s WHERE PlayerID = %s", notes, playerID)
      AWarn3_MySQLite.query(q, function() end, logErr)
    else
      local q = sql("INSERT INTO awarn3_notestable (PlayerID, PlayerNotes) VALUES (%s, %s)", playerID, notes)
      AWarn3_MySQLite.query(q, function() end, logErr)
    end
  end, logErr)
end

function AWarn:RemoveWarningID(warningID, admin)
  warningID = tonumber(warningID)
  if not warningID then return end

  local q = string.format("DELETE FROM awarn3_warningtable WHERE WarningID = %u", warningID)
  AWarn3_MySQLite.query(q, function()
    if IsValid(admin) then
      AWarn:SendChatMessage({
        AWarn.Localization:GetTranslation("deletedwarningid") .. " ",
        Color(255, 0, 0), tostring(warningID), AWARN3_WHITE, "."
      }, admin)
    end
  end, logErr)
end

function AWarn:DeleteAllPlayerWarnings(playerID, admin)
  local q = sql("DELETE FROM awarn3_warningtable WHERE PlayerID = %s", playerID)
  AWarn3_MySQLite.query(q, function()
    if IsValid(admin) then
      local tar = AWarn:GetPlayerFromID64(playerID)
      if IsValid(tar) then
        AWarn:SendChatMessage({ AWarn.Localization:GetTranslation("deletedwarningsfor") .. " ", tar:GetTeamColor(), tar:GetName(), AWARN3_WHITE, "." }, admin)
      else
        AWarn:SendChatMessage({ AWarn.Localization:GetTranslation("deletedwarningsfor") .. " ", Color(255,255,0), playerID, AWARN3_WHITE, "." }, admin)
      end
    end
    AWarn:UpdatePlayerWarnings(playerID, 0)
  end, logErr)
end

function AWarn:CreatePlayerEntry(playerID, playerName, warningOverride, setLastWarnTime)
  local warnings = clampWarnings(warningOverride or 0)
  playerName = tostring(playerName or "UNKNOWN"):Left(32)
  local t = now()

  local q
  if setLastWarnTime then
    q = sql(
      "INSERT INTO awarn3_playertable (PlayerID, PlayerName, PlayerWarnings, LastPlayed, LastWarning, LastWarningDecay) VALUES (%s, %s, %u, %u, %u, %u)",
      playerID, playerName, warnings, t, t, t
    )
  else
    q = sql(
      "INSERT INTO awarn3_playertable (PlayerID, PlayerName, PlayerWarnings, LastPlayed) VALUES (%s, %s, %u, %u)",
      playerID, playerName, warnings, t
    )
  end

  AWarn3_MySQLite.query(q, function() end, logErr)
end

function AWarn:UpdatePlayerName(playerID, playerName)
  playerName = tostring(playerName or "UNKNOWN"):Left(32)
  local q = sql("UPDATE awarn3_playertable SET PlayerName = %s, LastPlayed = %u WHERE PlayerID = %s", playerName, now(), playerID)
  AWarn3_MySQLite.query(q, function() end, logErr)
end

function AWarn:InitialSpawnPlayer(pl)
  if not IsValid(pl) then return end
  local id64 = AWarn:SteamID64(pl)
  local q = sql("SELECT * FROM awarn3_playertable WHERE PlayerID = %s", id64)

  AWarn3_MySQLite.query(q, function(result)
    if result and result[1] then
      local row = result[1]
      AWarn:SetPlayerActiveWarnings(pl, row.PlayerWarnings, false)
      AWarn:UpdatePlayerName(id64, pl:GetName())
      AWarn:InitialSpawnCheckDecay(pl, row.LastWarningDecay)
      if row.LastWarning and not (row.LastWarning == "NULL") then
        timer.Simple(1, function()
          if not IsValid(pl) then return end
          AWarn:AlertAdmins(pl, row.LastWarning, row.PlayerWarnings or 0)
          AWarn:WelcomeBackPlayer(pl)
        end)
      end
    else
      AWarn:SetPlayerActiveWarnings(pl, 0, false)
      AWarn:CreatePlayerEntry(id64, pl:GetName())
      AWarn:InitialSpawnCheckDecay(pl, 0)
    end
  end, logErr)
end

function AWarn:UpdatePlayerWarnings(playerID, count, setLastWarnTime, checkPunishment)
  count = clampWarnings(count)

  local q
  if count == 0 then
    q = sql("UPDATE awarn3_playertable SET PlayerWarnings = 0, LastWarning = NULL, LastWarningDecay = NULL WHERE PlayerID = %s", playerID)
  elseif setLastWarnTime then
    local t = now()
    q = sql("UPDATE awarn3_playertable SET PlayerWarnings = %u, LastWarning = %u, LastWarningDecay = %u WHERE PlayerID = %s", count, t, t, playerID)
  else
    q = sql("UPDATE awarn3_playertable SET PlayerWarnings = %u WHERE PlayerID = %s", count, playerID)
  end

  AWarn3_MySQLite.query(q, function()
    if checkPunishment then
      local pl = AWarn:GetPlayerFromID64(playerID)
      if not IsValid(pl) then return end
      AWarn:CheckForPunishment(pl, count)
      AWarn:ResetDecayTimer(pl)
    end
  end, logErr)

  local pl = AWarn:GetPlayerFromID64(playerID)
  if IsValid(pl) then
    AWarn:SetPlayerActiveWarnings(pl, count, false)
  end
end

function AWarn:DecayWarning(playerID, newCount)
  newCount = clampWarnings(newCount)
  local q = sql("UPDATE awarn3_playertable SET PlayerWarnings = %u, LastWarningDecay = %u WHERE PlayerID = %s", newCount, now(), playerID)

  AWarn3_MySQLite.query(q, function()
    local pl = AWarn:GetPlayerFromID64(playerID)
    if IsValid(pl) then
      AWarn:SetPlayerActiveWarnings(pl, newCount, false)
    end
  end, logErr)
end

function AWarn:SetPlayerLastWarned(playerID)
  local q = sql("UPDATE awarn3_playertable SET LastWarning = %u WHERE PlayerID = %s", now(), playerID)
  AWarn3_MySQLite.query(q, function() end, logErr)
end

-- ////////////////////////////////////////////////////////////////////////
-- Reads
-- ////////////////////////////////////////////////////////////////////////

function AWarn:GetPlayerActiveWarningsFromDatabase(pl)
  if not IsValid(pl) then return end
  local q = sql("SELECT PlayerWarnings FROM awarn3_playertable WHERE PlayerID = %s", AWarn:SteamID64(pl))

  AWarn3_MySQLite.queryValue(q, function(result)
    if not IsValid(pl) then return end
    pl.awarn3 = pl.awarn3 or {}
    pl.awarn3.activewarnings = tonumber(result)
  end, logErr)
end

function AWarn:GetPlayerWarnings(playerID, adminPl)
  local pid = playerID

  local q1 = sql([[
    SELECT w.WarningID, w.AdminID, w.WarningReason, w.WarningServer, w.WarningDate, p.PlayerName
    FROM awarn3_warningtable w
    INNER JOIN awarn3_playertable p ON w.AdminID = p.PlayerID
    WHERE w.PlayerID = %s
    ORDER BY w.WarningID DESC
  ]], pid)

  AWarn3_MySQLite.query(q1, function(result)
    if not IsValid(adminPl) then return end
    net.Start("awarn3_requestplayerwarnings")
    net.WriteString("warnings")
    net.WriteTable(result or {})
    net.Send(adminPl)
  end, logErr)

  local q2 = sql("SELECT PlayerName, PlayerWarnings, LastWarning FROM awarn3_playertable WHERE PlayerID = %s", pid)
  AWarn3_MySQLite.query(q2, function(result)
    if not IsValid(adminPl) then return end
    net.Start("awarn3_requestplayerwarnings")
    net.WriteString("info")
    net.WriteTable(result or {})
    net.Send(adminPl)
  end, logErr)
end

function AWarn:GetOwnWarnings(pl)
  local q = sql([[
    SELECT w.WarningID, w.AdminID, w.WarningReason, w.WarningServer, w.WarningDate, p.PlayerName
    FROM awarn3_warningtable w
    INNER JOIN awarn3_playertable p ON w.AdminID = p.PlayerID
    WHERE w.PlayerID = %s
  ]], pl:SteamID64())

  AWarn3_MySQLite.query(q, function(result)
    if not IsValid(pl) then return end
    net.Start("awarn3_requestownwarnings")
    net.WriteTable(result or {})
    net.Send(pl)
  end, logErr)
end

-- Chunked streamer for large search results
local function streamTableToClient(rows, pl)
  if not IsValid(pl) then return end
  local chunk = 100
  local total = math.ceil((#rows) / chunk)
  if total <= 1 then
    net.Start("awarn3_requestplayersearchdata")
    net.WriteInt(1, 8)
    net.WriteTable(rows)
    net.Send(pl)
    return
  end

  for i = 1, total do
    local startIdx = (i - 1) * chunk + 1
    local endIdx   = math.min(i * chunk, #rows)
    local slice = {}
    for j = startIdx, endIdx do slice[#slice + 1] = rows[j] end

    timer.Simple(i * 0.3, function()
      if not IsValid(pl) then return end
      net.Start("awarn3_requestplayersearchdata")
      net.WriteInt(i, 8)
      net.WriteTable(slice)
      net.Send(pl)
    end)
  end
end

function AWarn:GetSearchPlayerInfo(search, excludeOnlyWarned, adminPl)
  -- Support STEAM_ -> 64 conversion
  if search and search:Left(6) == "STEAM_" then
    local converted = util.SteamIDTo64(search)
    if converted and converted ~= "0" then search = converted end
  end

  local base = "SELECT PlayerID, PlayerName, PlayerWarnings, LastWarning, LastPlayed FROM awarn3_playertable"
  local whereParts = {}
  local params = {}

  if excludeOnlyWarned then
    table.insert(whereParts, "LastWarning <> 'NULL'")
  end

  if search and search ~= "" then
    local like = "%" .. search .. "%"
    table.insert(whereParts, "(PlayerID LIKE %s OR PlayerName LIKE %s)")
    params[#params + 1] = like
    params[#params + 1] = like
  end

  local q
  if #whereParts > 0 then
    q = sql(base .. " WHERE " .. table.concat(whereParts, " AND "), unpack(params))
  else
    q = base
  end

  AWarn3_MySQLite.query(q, function(result)
    if not IsValid(adminPl) then return end
    streamTableToClient(result or {}, adminPl)
  end, logErr)
end

function AWarn:RequestPlayerNotes(pl, playerID)
  local q = sql("SELECT PlayerNotes FROM awarn3_notestable WHERE PlayerID = %s", playerID)
  AWarn3_MySQLite.query(q, function(result)
    local notes = ""
    if result and result[1] and result[1].PlayerNotes then
      notes = tostring(result[1].PlayerNotes)
    end
    net.Start("awarn3_notesrequest")
    net.WriteString(notes)
    net.WriteString(playerID)
    net.Send(pl)
  end, logErr)
end

-- ////////////////////////////////////////////////////////////////////////
-- Networking
-- ////////////////////////////////////////////////////////////////////////

net.Receive("awarn3_createwarningid", function(_, pl)
  if not hasPermOrTell(pl, "awarn_warn", "insufficientperms") then return end
  local pid   = net.ReadString() or ""
  local aid   = net.ReadString() or "CONSOLE"
  local reas  = net.ReadString() or ""
  if pid == "" then return end
  AWarn:CreateWarningID(pid, aid, reas)
end)

net.Receive("awarn3_updateplayernotes", function(_, pl)
  if not hasPermOrTell(pl, "awarn_warn", "insufficientperms") then return end
  local pid  = net.ReadString() or ""
  local note = net.ReadString() or ""
  if pid == "" then return end
  AWarn:SavePlayerNotes(pid, note)
end)

net.Receive("awarn3_notesrequest", function(_, pl)
  if not hasPermOrTell(pl, "awarn_warn", "insufficientperms") then return end
  local pid = net.ReadString() or ""
  if pid == "" then return end
  AWarn:RequestPlayerNotes(pl, pid)
end)

net.Receive("awarn3_addactivewarning", function(_, pl)
  if not hasPermOrTell(pl, "awarn_remove", "insufficientperms") then return end
  local targetID = net.ReadString() or ""
  local delta    = net.ReadInt(8) or 0
  if targetID == "" then return end

  AWarn:AddActiveWarning(targetID, delta)

  local disp = AWarn:GetPlayerFromID64(targetID)
  AWarn:SendChatMessage({
    AWarn.Localization:GetTranslation("remove1activewarn") .. " ",
    Color(255, 0, 0), (disp and disp:Nick()) or targetID
  }, pl)
end)

net.Receive("awarn3_deletesinglewarning", function(_, pl)
  if not hasPermOrTell(pl, "awarn_delete", "insufficientperms") then return end
  local id = net.ReadInt(32)
  if not id then return end
  AWarn:RemoveWarningID(id, pl)
end)

net.Receive("awarn3_deleteallplayerwarnings", function(_, pl)
  if not hasPermOrTell(pl, "awarn_delete", "insufficientperms") then return end
  local pid = net.ReadString() or ""
  if pid == "" then return end
  AWarn:DeleteAllPlayerWarnings(pid, pl)
end)

net.Receive("awarn3_requestplayerwarnings", function(_, pl)
  if not IsValid(pl) then return end
  if not hasPermOrTell(pl, "awarn_view", "insufficientperms2") then return end
  local pid = net.ReadString() or ""
  if pid == "" then return end
  AWarn:GetPlayerWarnings(pid, pl)
end)

-- Throttle config
local OWN_REQ_WINDOW = 5  -- seconds
local OWN_REQ_LIMIT  = 10 -- within window

net.Receive("awarn3_requestownwarnings", function(_, pl)
  if not IsValid(pl) then return end
  local nowt = CurTime()
  pl.totalOwnRequestsInTime = (pl.totalOwnRequestsInTime or 0) + 1

  if (pl.lastOwnRequest or 0) > (nowt - OWN_REQ_WINDOW) then
    if pl.totalOwnRequestsInTime >= OWN_REQ_LIMIT then
      AWarn:Kick(pl, "You were kicked for trying to exploit/crash the server", "%s was kicked for trying to exploit/crash the server")
    end
    return
  end

  AWarn:GetOwnWarnings(pl)
  pl.lastOwnRequest = nowt
  pl.totalOwnRequestsInTime = 0
end)

net.Receive("awarn3_requestplayersearchdata", function(_, pl)
  if not IsValid(pl) then return end
  if not hasPermOrTell(pl, "awarn_view", "insufficientperms") then return end
  local search = net.ReadString() or ""
  local exclude = net.ReadBool() or false
  AWarn:GetSearchPlayerInfo(search, exclude, pl)
end)

-- ////////////////////////////////////////////////////////////////////////
-- Go
-- ////////////////////////////////////////////////////////////////////////

AWarn:ConnectToDatabase()
