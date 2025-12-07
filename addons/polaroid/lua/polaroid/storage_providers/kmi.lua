-- https://kmi.aeza.net/ - pastebin like thing
-- limits: 10 uploads per minute (per player), max upload size 512kb
-- The only bad thing about this service is: it doesnt accept requests with a body. Due this we should encode photos to base64, which costs some cpu time & increases data size.

local Provider = {}

Provider.maxFileSize = 500 * 1024 -- 500kb (script will reduce photo quality if data size out of limits)
Provider.encode = true -- encode photos to base64

function Provider:Upload(image, onSuccess, onFailure)
	http.Post("https://kmi.aeza.net/", {kmi = image}, function(body, _, _, code)
		if code ~= 200 then
			onFailure("Request error! Code: " .. code .. ", body: " .. body)
			return
		end

		local uid = body:match("https://kmi.aeza.net/(.+)\n")
		if uid == nil or #uid == 0 then
			onFailure("Request error! Code: " .. code .. ", body: " .. body)
			return
		end

		onSuccess(uid)
	end, function(reason)
		onFailure("Failed to request! " .. reason)
	end)
end

function Provider:GetURL(uid)
	return "https://kmi.aeza.net/" .. uid
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
