local Polaroid = g1_Polaroid

Polaroid.util = {}
local UTIL = Polaroid.util

do
	local random, gsub, format = math.random, string.gsub, string.format
	local x = {x = true}
	local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

	function UTIL.RandomString()
		return gsub(template, "[xy]", function(c)
			local v = x[c] and random(0, 0xf) or random(8, 0xb)
			return format("%x", v)
		end)
	end
end

do
	local fileTemplate = "polaroid_%s_%s.jpg"
	local headerTemplate = "Content-Disposition: form-data; name=\"files[]\"; filename=\"%s\"\r\nContent-Type: image/jpeg\r\n"
	local contentTemplate = "--%s\r\n%s\r\n%s\r\n--%s--"

	function UTIL.MakeMultipartFromData(binary)
		local fileName = fileTemplate:format(LocalPlayer():SteamID64(), os.time())
		local boundary = "----WebKitFormBoundary" .. UTIL.RandomString()
		local header = headerTemplate:format(fileName)

		return boundary, contentTemplate:format(boundary, header, binary, boundary)
	end
end

-- v2
do
	local fileTemplate = "polaroid_%s_%s.jpg"
	local headerTemplate = "Content-Disposition: form-data; name=\"files[]\"; filename=\"%s\"\r\nContent-Type: image/jpeg\r\n"
	local contentTemplate = "--%s\r\n%s\r\n%s\r\n--%s--"

	function UTIL.MakeMultipartFromData(binary)
		local fileName = fileTemplate:format(LocalPlayer():SteamID64(), os.time())
		local boundary = "----WebKitFormBoundary" .. util.CRC(binary)
		local header = headerTemplate:format(fileName)

		return boundary, contentTemplate:format(boundary, header, binary, boundary)
	end
end

--[[ method previously used for https://x0.at/ & https://imgur.com/ (just 4 history)
local function GetBoundary(content)
    local fname = "polaroid_".. LocalPlayer():SteamID64() .."_".. math.floor(SysTime()) ..".jpg"

    local boundary = "fboundary".. math.random(1, 100)
    local header_bound = "Content-Disposition: form-data; name=\"file\"; filename=\"".. fname .."\"\r\nContent-Type: application/octet-stream\r\n"

    content =  "--".. boundary .."\r\n".. header_bound .."\r\n".. content .."\r\n--".. boundary .."--\r\n"
    return boundary, content
end
]]--

do
	function UTIL.ValidateJPEG(jpeg)
		if jpeg:sub(1, 2) ~= "\xff\xd8" then return false end
		return jpeg:find("\xff\xd9", 1, true) ~= nil
	end
end
