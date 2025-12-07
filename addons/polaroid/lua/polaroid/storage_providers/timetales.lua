-- https://cdn.voltcity.de/
-- chibisafe hosted by my dude (fair use)

local Polaroid = g1_Polaroid
local Provider = {}

Provider.maxFileSize = 1000 * 1024 -- 1000kb (script will reduce photo quality if data size out of limits)
Provider.encode = false -- encode photos to base64

function Provider:Upload(image, onSuccess, onFailure)
	local boundary, content = Polaroid.util.MakeMultipartFromData(image)

	HTTP({
		url = "https://cdn.voltcity.de/api/upload",
		method = "post",
		type = "multipart/form-data; boundary=" .. boundary,
		body = content,
		success = function(code, body)
			if code ~= 200 then
				onFailure("Request error! Code: " .. code .. ", body: " .. body)
				return
			end

			local response = util.JSONToTable(body)
			if not (response and response.name) then
				onFailure("Request error! Wrong response! Body: " .. body)
				return
			end

			local uid = response.name:match("([^/]+)$-.jpg")
			if uid == nil or #uid == 0 then
				onFailure("Request error! Code: " .. code .. ", body: " .. body)
				return
			end

			onSuccess(uid)
		end,
		failed = function(reason)
			onFailure("Failed to request! " .. reason)
		end
	})
end

function Provider:GetURL(uid)
	return "https://cdn.voltcity.de/" .. uid .. ".jpg"
end

function Provider:Download(uid, onSuccess, onFailure)
	http.Fetch(self:GetURL(uid), function(body, _, _, code)
		if code ~= 200 then
			onFailure("Request error! Code: " .. code .. ", body: " .. body)
			return
		end

		onSuccess(body)
	end, function(reason)
		onFailure("Failed to request! " .. reason)
	end)
end

return Provider
