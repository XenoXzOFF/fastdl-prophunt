AddCSLuaFile()

--[[
      __          __              ____  
     /\ \        / /             |___ \ 
    /  \ \  /\  / /_ _ _ __ _ __   __) |
   / /\ \ \/  \/ / _` | '__| '_ \ |__ < 
  / ____ \  /\  / (_| |  | | | | |___) |
 /_/    \_\/  \/ \__,_|_|  |_| |_|____/ 

	AWarn3 by Mr.President
]]

MsgC(AWARN3_STATECOLOR, "[AWarn3] ", AWARN3_WHITE, "Loading Localization Module\n")

AWarn = AWarn or {}
AWarn.Localization = AWarn.Localization or {}
local Localization = AWarn.Localization

-- Storage
Localization.Languages = Localization.Languages or {}   -- map<lower_lang_code, map<defID, text>>
Localization.LangCodes  = Localization.LangCodes  or {} -- map<lower_lang_code, displayName>
Localization.__normalized = Localization.__normalized or false

-- Canonical English codes (lowercase)
local ENGLISH_CODES = { "en-us", "en" }

-- --- Utilities -------------------------------------------------------------

local function norm(code)
	if not isstring(code) then return nil end
	code = code:Trim()
	if code == "" then return nil end
	return string.lower(code)
end

-- If anything was created before we enforced lowercasing, normalize it now.
local function normalizeExistingOnce()
	if Localization.__normalized then return end

	-- Languages
	local newLangs = {}
	for code, tbl in pairs(Localization.Languages) do
		local n = norm(code)
		if n then
			newLangs[n] = newLangs[n] or {}
			-- migrate keys
			for k, v in pairs(tbl) do
				newLangs[n][k] = v
			end
		end
	end
	Localization.Languages = newLangs

	-- LangCodes (display names)
	local newNames = {}
	for code, name in pairs(Localization.LangCodes) do
		local n = norm(code)
		if n then newNames[n] = name end
	end
	Localization.LangCodes = newNames

	Localization.__normalized = true
end

-- Server default language (lowercased), pref: option → AWarn.DefaultLanguage → nil
local function getConfiguredDefaultLanguage()
	local val
	if SERVER and AWarn and AWarn.GetOption then
		local ok, v = pcall(AWarn.GetOption, AWarn, "awarn_server_language")
		if ok and isstring(v) and v ~= "" then val = v end
	end
	if not val and isstring(AWarn.DefaultLanguage) and AWarn.DefaultLanguage ~= "" then
		val = AWarn.DefaultLanguage
	end
	return norm(val)
end

local function pickEnglishCode()
	-- try canonical codes first
	for _, code in ipairs(ENGLISH_CODES) do
		if Localization.Languages[code] then return code end
	end
	-- heuristic: any registered name containing "english"
	for code, name in pairs(Localization.LangCodes) do
		if isstring(name) and name:lower():find("english", 1, true) then
			return code
		end
	end
	return nil
end

local function lookupIn(code, defID)
	if not code then return nil end
	local t = Localization.Languages[code]
	if t then
		local v = t[defID]
		if v ~= nil then return v end
	end
	return nil
end

-- --- Public API ------------------------------------------------------------

function Localization:RegisterLanguage(langCode, langName)
	normalizeExistingOnce()
	local code = norm(langCode)
	if not code then return end
	if not isstring(langName) or langName == "" then langName = langCode or "" end

	self.Languages[code] = self.Languages[code] or {}
	self.LangCodes[code]  = langName
end

function Localization:AddDefinition(langCode, defID, text)
	normalizeExistingOnce()
	local code = norm(langCode)
	if not code then return end
	if not isstring(defID) or defID == "" then return end
	if text == nil then return end

	self.Languages[code] = self.Languages[code] or {}
	self.Languages[code][defID] = text
end

-- Lookup with fallbacks; langCode is normalized internally.
function Localization:LookupDefinition(langCode, defID)
	normalizeExistingOnce()
	if not isstring(defID) or defID == "" then return "NOT SET" end

	local req = norm(langCode)

	-- 1) requested
	local v = lookupIn(req, defID)
	if v ~= nil then return v end

	-- 2) configured default
	local def = getConfiguredDefaultLanguage()
	if def and def ~= req then
		v = lookupIn(def, defID)
		if v ~= nil then return v end
	end

	-- 3) English
	local eng = pickEnglishCode()
	if eng and eng ~= req and eng ~= def then
		v = lookupIn(eng, defID)
		if v ~= nil then return v end
	end

	-- 4) not found
	return "NOT SET"
end

function Localization:GetTranslation(defID)
	normalizeExistingOnce()
	local start
	if SERVER then
		start = getConfiguredDefaultLanguage()
	else
		start = norm(AWarn.SelectedLanguage) or getConfiguredDefaultLanguage()
	end
	return self:LookupDefinition(start, defID)
end

function Localization:GetLanguageName(langCode)
	normalizeExistingOnce()
	return self.LangCodes[norm(langCode) or ""] or (langCode or "")
end

function Localization:GetAvailableLanguages()
	normalizeExistingOnce()
	local out = {}
	for code in pairs(self.LangCodes) do
		out[#out + 1] = code
	end
	return out
end

function Localization:LoadLanguages()
	normalizeExistingOnce()
	local files = ({ file.Find("localizations/*.lua", "LUA") })[1] or {}
	for _, fname in ipairs(files) do
		local path = "localizations/" .. fname
		include(path)
		if SERVER then AddCSLuaFile(path) end
	end
end

Localization:LoadLanguages()