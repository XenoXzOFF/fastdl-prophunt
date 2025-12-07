local Polaroid = g1_Polaroid

local colors = {
	background = Color(220, 70, 40),
	backgroundHover = Color(175, 55, 30),
	backgroundUnfocus = Color(220, 70, 40, 175),
	backgroundWhite = Color(250, 220, 195),
	backgroundWhiteDisabled = Color(250, 220, 195, 100),
	white = Color(255, 255, 255),
	whiteHover = Color(250, 200, 160),
	hover = Color(219, 193, 167),
	dark = Color(51, 51, 51),
	shadow = Color(5, 5, 15, 125)
}

local pallete = {
	Color(241, 196, 15),
	Color(230, 126, 34),
	Color(46, 204, 113),
	Color(26, 188, 156),
	Color(52, 152, 219),
	Color(87, 95, 207),
	Color(155, 89, 182),
	Color(142, 68, 173)
}

local materials = {
	close = Material("polaroid/close.png", "smooth mips"),
	brush = Material("polaroid/brush.png", "smooth mips"),
	fountain_pen = Material("polaroid/fountain_pen.png", "smooth mips"),
	pen = Material("polaroid/pen.png", "smooth mips"),
	eraser = Material("polaroid/eraser.png", "smooth mips"),
	printer = Material("polaroid/printer.png", "smooth mips"),
	knob = Material("polaroid/knob.png", "smooth"),
	pipette = Material("polaroid/pipette.png", "smooth"),
	layers = Material("polaroid/layers.png", "smooth mips"),
	eye = Material("polaroid/eye.png", "smooth"),
	trashbin = Material("polaroid/trashbin.png", "smooth"),
	arrow = Material("polaroid/arrow.png", "smooth")
}

surface.CreateFont("gmod.one/polaroid/slider", {
	font = "Roboto",
	extended = true,
	size = 14,
	weight = 300,
})

surface.CreateFont("gmod.one/polaroid/layerName", {
	font = "Roboto",
	extended = true,
	size = 16,
	weight = 400,
})

surface.CreateFont("gmod.one/polaroid/newLayer", {
	font = "Roboto",
	extended = true,
	size = 12,
	weight = 400,
})

surface.CreateFont("gmod.one/polaroid/colorPicker", {
	font = "Roboto",
	extended = true,
	size = 14,
	weight = 400,
})

local function BeautifyScroll(scroll)
	local vbar = scroll:GetVBar()

	vbar:SetWide(8)

	vbar.Paint = function(me, w, h)
		draw.RoundedBox(4, 0, 0, w, h, colors.background)
	end
	vbar.btnGrip.Paint = function(me, w, h)
		draw.RoundedBox(4, 0, 3, w, h - 6, colors.dark)
	end

	vbar.btnUp:SetAlpha(0)
	vbar.btnDown:SetAlpha(0)
	vbar.btnUp:SetTall(0)
	vbar.btnDown:SetTall(0)

	local PerformLayout = vbar.PerformLayout
	vbar.PerformLayout = function(me, w, h)
		PerformLayout(me, w, h)

		me.btnUp:SetTall(0)
		me.btnDown:SetTall(0)
	end
end

--------

local Editor = {}

function Editor:Init()
	self.brushColor = pallete[math.random(1, #pallete)]
	self.brushSize = 8
	self.penSize = 32
	self.fountainSize = 16
	self.fountainThickness = 2
	self.eraserSize = 64
	self.fontSize = 26
	self.fontWeight = 4

	self.activeLayer = 1
	self.disableDraw = false
	self.disableTools = input.IsMouseDown(MOUSE_LEFT)

	self.layersMap = {}

	local w = 4 + 28 + 36 + 4
	local h = 4 + 4 + 34 + 4

	local img_w = math.min(1280, ScrW() - w - 32 - 16)
	local img_h = math.min(720, ScrH() - h - 32 - 16)

	w = w + img_w + 32
	h = h + img_h + 32

	self:SetAlpha(0)
	self:AlphaTo(255, 0.15, 0.7)
	self:SetSize(w, h)
	self:Center()
	self:MakePopup()

	local shadow = self:Add("EditablePanel")
	shadow:SetPos(0, 32)
	shadow:SetSize(w - 24, h - 32)
	shadow.Paint = function(me, w, h)
		draw.RoundedBox(9, 0, 0, w, h, colors.shadow)
	end

	self.window = self:Add("EditablePanel")
	self.window:SetPos(12, 16)
	self.window:SetSize(w - 24, h - 32)
	self.window.Paint = function(me, w, h)
		draw.RoundedBox(9, 0, 0, w, h, colors.background)
		draw.RoundedBox(9, 4, 4, w - 8, h - 8, colors.backgroundWhite)
	end

	self.canvas = self.window:Add("EditablePanel")
	self.canvas:SetSize(img_w, img_h)
	self.canvas:SetPos(58, 16)
	self.canvas.Paint = function(me, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.photo)
		surface.DrawTexturedRect(0, 0, w, h)

		self.layers:PaintManual()
	end

	self.layers = self.canvas:Add("EditablePanel")
	self.layers:SetSize(self.canvas:GetSize())
	self.layers:SetPaintedManually(true)

	self.overlay = self.canvas:Add("EditablePanel")
	self.overlay:SetSize(self.canvas:GetSize())
	self.overlay:SetMouseInputEnabled(false)
	self.overlay.Paint = function(me, w, h)
		local DrawCursor = self.activeTool.DrawCursor
		if DrawCursor == nil then return end

		local layer = self:GetActiveLayer()
		if (IsValid(layer) and layer:IsHovered()) == false then return end

		local x, y = me:LocalCursorPos()
		DrawCursor(self.activeTool, x, y, w, h)
	end

	self.tools = self.window:Add("EditablePanel")
	self.tools:Dock(LEFT)
	self.tools:DockMargin(4, 4, 0, 4)
	self.tools:SetWide(32)
	self.tools.Paint = function(me, w, h)
		surface.SetDrawColor(colors.background)
		surface.DrawRect(0, 0, w, h)
	end

	local closeShadow = self:Add("EditablePanel")
	closeShadow:SetSize(48, 48)
	closeShadow.x = w - closeShadow:GetWide() - 4
	closeShadow.y = 6
	closeShadow:SetMouseInputEnabled(false)
	closeShadow.Paint = function(me, w, h)
		surface.SetDrawColor(colors.shadow)
		surface.SetMaterial(materials.close)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	local closeButton = self:Add("EditablePanel")
	closeButton:SetMouseInputEnabled(true)
	closeButton:SetCursor("hand")
	closeButton:SetSize(48, 48)
	closeButton.x = w - closeButton:GetWide()
	closeButton.OnMousePressed = function(me, mcode)
		if mcode ~= MOUSE_LEFT then return end
		me.down = true
	end
	closeButton.OnMouseReleased = function(me, mcode)
		if me.down and mcode == MOUSE_LEFT then
			me.down = false
			self:Close()
		end
	end
	closeButton.Paint = function(me, w, h)
		surface.SetDrawColor(me:IsHovered() and colors.hover or colors.backgroundWhite)
		surface.SetMaterial(materials.close)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	closeButton.TestHover = function(me, x, y)
		x, y = me:ScreenToLocal(x, y)

		local radius = me:GetWide() * 0.5
		return math.Distance(x, y, radius, radius) <= radius
	end

	self:CreateLayer()
	self:CreateTools()
end

function Editor:CreateLayer(name)
	local layer = self.layers:Add("EditablePanel")
	layer:SetSize(self.canvas:GetSize())

	self.NextLayerIndex = (self.NextLayerIndex or 1) + 1
	layer.LayerIndex = self.NextLayerIndex - 1
	layer:SetZPos(layer.LayerIndex)

	layer.LayerName = "Layer " .. layer.LayerIndex
	self.layersMap[layer.LayerIndex] = layer

	local rtName = "Polaroid/Layer/" .. layer.LayerIndex
	local rt = GetRenderTarget(rtName, layer:GetSize())
	local mat = CreateMaterial(rtName, "UnlitGeneric", {
		["$basetexture"] = rtName,
		["$translucent"] = 1
	})

	layer.Paint = function(me, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	layer.PushRender = function()
		render.PushRenderTarget(rt)
		cam.Start2D()
	end
	layer.PopRender = function()
		cam.End2D()
		render.PopRenderTarget()
	end

	layer.Clear = function()
		render.PushRenderTarget(rt)
			render.Clear(0, 0, 0, 0, true, true)
		render.PopRenderTarget()
	end

	layer.OnRemove = function(me)
		me:Clear()
		self.layersMap[me.LayerIndex] = nil

		hook.Run("gmod.one/polaroid/editor/layersUpdate")

		if self.activeLayer ~= me.LayerIndex then return end

		local dist, target = math.huge, nil

		for _, new in ipairs(self.layers:GetChildren()) do
			if new == me then continue end

			local delta = math.abs(me.LayerIndex - new.LayerIndex)

			if delta < dist then
				dist = delta
				target = new
			end
		end

		if target == nil then return end

		self.activeLayer = target.LayerIndex
	end

	layer:Clear()

	if #self.layers:GetChildren() == 1 then
		self.activeLayer = layer.LayerIndex
	else
		layer:SetMouseInputEnabled(false)
	end

	hook.Run("gmod.one/polaroid/editor/layersUpdate")
	return layer
end

function Editor:CreatePopup(parent)
	if IsValid(self.popup) then self.popup:Remove() end

	local popup = self.window:Add("EditablePanel")
	self.popup = popup

	popup:SetSize(128, 256)
	popup:SetPos(39, parent.y + 6)
	popup.Paint = function(me, w, h)
		me.y = parent.y + 6
		draw.RoundedBox(4, 0, 0, w, h, colors.background)
		draw.RoundedBox(4, 2, 2, w - 4, h - 4, colors.backgroundWhite)
	end

	return popup
end

function Editor:CreateSlider(parent, title, getter, setter, mins, maxs, getName, nonEditable)
	local sliderParent = parent:Add("EditablePanel")
	sliderParent:SetSize(parent:GetWide(), 46)
	sliderParent:Dock(TOP)
	sliderParent.PaintOver = function(me, w, h)
		draw.SimpleText(title, "gmod.one/polaroid/slider", 8, 6, colors.dark)
	end

	local slider = sliderParent:Add("DSlider")
	slider:Dock(TOP)
	slider:DockMargin(8, 24, 8, 0)
	slider.Paint = function(me, w, h)
		surface.SetDrawColor(colors.dark)
		surface.DrawRect(0, h * 0.5 - 10, w, 6)
	end
	slider.Knob.Paint = function(me, w, h)
		surface.SetDrawColor(colors.background)
		surface.SetMaterial(materials.knob)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	slider.Knob:SetSize(10, 10)
	slider:SetCursor("hand")
	slider.Think = function(me)
		local old = me.oldEditing
		local new = me:IsEditing()
		me.oldEditing = new

		if new == old then return end

		self.disableDraw = new or false
	end

	local input = sliderParent:Add("gmod.one/polaroid/input")
	sliderParent.entry = input
	input:SetSize(42, 16)
	input:SetTextDarkest(50, 255)
	input:SetNumeric(true)
	input.m_bBackground = true
	input.FocusedBackgroundColor = colors.background
	input.BackgroundColor = colors.background
	input.BottomLineSize = 1

	input:SetFont("gmod.one/polaroid/slider")
	input.m_FontName = "gmod.one/polaroid/slider"
	input:SetFontInternal("gmod.one/polaroid/slider")

	local Paint = input.Paint
	input.Paint = function(me, w, h)
		surface.SetDrawColor(colors.backgroundWhite)
		surface.DrawRect(0, 0, w, h)

		Paint(me, w, h)
	end

	input.y = 4
	input.x = sliderParent:GetWide() - input:GetWide() - 8

	input:SetText(getName and getName() or getter())
	slider:SetSlideX(getter() / maxs)
	slider.TranslateValues = function(me, x, y)
		local num = math.max(mins, math.floor(maxs * x))

		setter(num)
		input:SetText(getName and getName() or getter())

		return x, y
	end

	if nonEditable then
		local blocker = input:Add("EditablePanel")
		blocker:Dock(FILL)
		blocker:SetCursor("no")
		blocker:SetTooltip("This field is view-only. Use slider!")
	else
		input:SetUpdateOnType(true)
		input.OnKeyCode = function(me, key)
			if #me:GetText() == 1 and key == KEY_BACKSPACE then
				me:SetText(mins)
				setter(mins)
			end
		end
		input.AllowInput = function(me, v)
			if me:CheckNumeric(v) then return true end

			local new = tonumber(me:GetText() .. v)
			return new > maxs or new < mins
		end
		input.OnValueChange = function(_, v)
			v = tonumber(v) or mins
			setter(v)
			slider:SetSlideX(v / maxs)
		end

		--[[
		input.SetValue = function(me, v)
			local num = math.Clamp(tonumber(v) or 0, mins, maxs)
			local changed = num ~= tonumber(me:GetValue())

			if me:HasFocus() == false then
				me:SetText(string.format("%i", val))
			end

			if changed then
				me:OnValueChange(num)
			end
		end
		]]
	end

	return sliderParent
end

function Editor:CreateSliderPopup(parent, title, getter, setter)
	local popup = self:CreatePopup(parent)
	popup:SetSize(160, 46)
	self:CreateSlider(popup, title, getter, setter, 1, 256)
end

function Editor:GetActiveLayer()
	return self.layersMap[self.activeLayer]
end

local function CreateCircle(x, y, radius, density)
	local circle, tmp = {}, 0
	local quality = math.max(5, math.floor(2 * math.pi * radius * density))

	for i = 1, quality do
		tmp = math.rad(i * 360) / quality
		circle[i] = {
			x = x + math.cos(tmp) * radius,
			y = y + math.sin(tmp) * radius
		}
	end

	return circle
end

local function CreateEllipse(x, y, radiusX, radiusY, density)
	local ellipse, tmp = {}, 0
	local quality = math.Clamp(math.floor(2 * math.pi * math.max(radiusX, radiusY) * density), 5, 256)

	for i = 1, quality do
		tmp = math.rad(i * 360) / quality
		ellipse[i] = {
			x = x + math.cos(tmp) * radiusX,
			y = y + math.sin(tmp) * radiusY
		}
	end

	return ellipse
end

function Editor:CreateTools()
	do
		local brush = self.tools:Add("gmod.one/polaroid/editor/tool")
		brush.GetRadius = function() return self.brushSize end
		brush.Open = function(me)
			self:CreateSliderPopup(me, "Brush size:", function()
				return self.brushSize
			end, function(new)
				self.brushSize = new
			end)
		end
		brush.Render = function(_, x, y)
			local circle = CreateCircle(x, y, self.brushSize, 1)

			surface.SetDrawColor(self.brushColor)
			draw.NoTexture()
			surface.DrawPoly(circle)
		end
		brush.DrawCursor = function(_, x, y, w, h)
			surface.DrawCircle(x, y, self.brushSize, 255, 255, 255, 100)
		end
		brush:Setup(self, materials.brush, "Brush")
	end

	----------------------

	do
		local brush = self.tools:Add("gmod.one/polaroid/editor/tool")
		brush.GetRadius = function()
			return math.min(self.fountainSize, self.fountainThickness)
		end
		brush.Open = function(me)
			local popup = self:CreatePopup(me)
			popup:SetSize(160, 46 * 2)

			self:CreateSlider(popup, "Size:", function()
				return self.fountainSize
			end, function(new)
				self.fountainSize = new
			end, 1, 256)

			self:CreateSlider(popup, "Thickness:", function()
				return self.fountainThickness
			end, function(new)
				self.fountainThickness = new
			end, 1, 256)
		end
		brush.Render = function(_, x, y)
			local elipse = CreateEllipse(x, y, self.fountainSize, self.fountainThickness, 1)

			surface.SetDrawColor(self.brushColor)
			draw.NoTexture()
			surface.DrawPoly(elipse)
		end
		brush.DrawCursor = function(_, x, y, w, h)
			surface.SetDrawColor(255, 255, 255, 100)

			local x, y, radiusX, radiusY, density = x, y, self.fountainSize, self.fountainThickness, 1
			local quality = math.max(5, math.floor(2 * math.pi * math.max(radiusX, radiusY) * density))
			local prev

			for i = 1, quality do
				local tmp = math.rad(i * 360) / quality
				local new = {
					x = x + math.cos(tmp) * radiusX,
					y = y + math.sin(tmp) * radiusY
				}

				if prev then
					surface.DrawLine(prev.x, prev.y, new.x, new.y)
				end

				prev = new
			end
		end
		brush:Setup(self, materials.fountain_pen, "Fountain pen")

		self.activeTool = brush
		brush:Open()
	end

	----------------------

	do
		local pen = self.tools:Add("gmod.one/polaroid/editor/tool")
		pen.GetRadius = function() return self.penSize end
		pen.Open = function(me)
			self:CreateSliderPopup(me, "Pen size:", function()
				return self.penSize
			end, function(new)
				self.penSize = new
			end)
		end
		pen.Render = function(_, x, y)
			local size = self.penSize
			local sizeHalf = size * 0.5

			surface.SetDrawColor(self.brushColor)
			surface.DrawRect(x - sizeHalf, y - sizeHalf, size, size)
		end
		pen.DrawCursor = function(_, x, y, w, h)
			surface.SetDrawColor(255, 255, 255, 100)

			local size = self.penSize
			local sizeHalf = size * 0.5

			surface.DrawRect(x - sizeHalf, y - sizeHalf, size, 1)
			surface.DrawRect(x - sizeHalf, y - sizeHalf, 1, size)

			surface.DrawRect(x - sizeHalf, y + sizeHalf - 1, size, 1)
			surface.DrawRect(x + sizeHalf - 1, y - sizeHalf, 1, size)
		end
		pen:Setup(self, materials.pen, "Pen")
	end

	----------------------

	do
		local eraser = self.tools:Add("gmod.one/polaroid/editor/tool")
		eraser.GetRadius = function() return self.eraserSize end
		eraser.Open = function(me)
			self:CreateSliderPopup(me, "Eraser size:", function()
				return self.eraserSize
			end, function(new)
				self.eraserSize = new
			end)
		end
		eraser.Render = function(_, x, y)
			local size = self.eraserSize
			local sizeHalf = size * 0.5
			x, y = x - sizeHalf, y - sizeHalf

			render.SetScissorRect(x, y, x + size, y + size, true)
				render.Clear(0, 0, 0, 0, true, true)
			render.SetScissorRect(0, 0, ScrW(), ScrH(), false)
		end
		eraser.DrawCursor = function(_, x, y, w, h)
			surface.SetDrawColor(255, 255, 255, 100)

			local size = self.eraserSize
			local sizeHalf = size * 0.5

			surface.DrawRect(x - sizeHalf, y - sizeHalf, size, 1)
			surface.DrawRect(x - sizeHalf, y - sizeHalf, 1, size)

			surface.DrawRect(x - sizeHalf, y + sizeHalf - 1, size, 1)
			surface.DrawRect(x + sizeHalf - 1, y - sizeHalf, 1, size)
		end
		eraser:Setup(self, materials.eraser, "Eraser")
	end

	do
		local pipette = self.tools:Add("gmod.one/polaroid/editor/tool")
		pipette:Setup(self, materials.pipette, "Pipette")

		hook.Add("PostRenderVGUI", pipette, function(me)
			if me:IsActive() == false or me.overColor == nil then return end

			local x, y = input.GetCursorPos()

			local wide = 16 + 12
			local tall = 28

			local text = me.overColor.r .. ", " .. me.overColor.g .. ", " .. me.overColor.b

			surface.SetFont("DermaDefault")
			wide = wide + surface.GetTextSize(text) + 6

			x = x + 8
			y = y + 8

			draw.RoundedBox(5, x, y, wide, tall, colors.background)
			draw.RoundedBox(5, x + 1, y + 2, wide - 2, tall - 4, colors.backgroundWhite)

			draw.RoundedBox(5, x + 5, y + 5, 18, 18, colors.dark)
			draw.RoundedBox(5, x + 6, y + 6, 16, 16, me.overColor)

			draw.SimpleText(text, "DermaDefault", x + wide - 6, y + tall * 0.5, colors.dark, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end)

		local apply = false

		hook.Add("PostRender", pipette, function(me)
			if me:IsActive() == false then return end

			local x, y = input.GetCursorPos()
			local oldW, oldH = ScrW(), ScrH()

			render.SetViewPort(x, y, 1, 1)
			render.CapturePixels()
			render.SetViewPort(0, 0, oldW, oldH)

			local r, g, b = render.ReadPixel(x, y)
			me.overColor = Color(r, g, b)

			if input.IsMouseDown(MOUSE_LEFT)
			and self.tools:IsChildHovered() == false then
				self.brushColor = me.overColor
			end
		end)
	end

	self:CreateColorPicker()

	----------------------

	self:CreateToolSpacer()
	self:CreateLayersTool()

	----------------------

	self:CreateToolSpacer()

	do
		local printer = self.tools:Add("gmod.one/polaroid/editor/tool")
		printer:Setup(self, materials.printer, "Print photo")
		printer.Open = function()
			self:Print()
			self:Close()
		end
	end
end

function Editor:Print()
	if self.printed then return end
	self.printed = true

	local image = self:Capture()

	Polaroid:Upload(image, function(uid)
		net.Start("gmod.one/polaroid")
			net.WriteString(uid)
		net.SendToServer()
	end)
end

function Editor:Capture()
	local size = Polaroid.config.PhotoResolution
	local rt = GetRenderTarget("Polaroid/EditorPrint/" .. size.x .. "x" .. size.y, size.x, size.y)

	---------

	local layersOffset = Vector(self.layers:LocalToScreen(0, 0))
	local matrix = Matrix()
	matrix:Scale(Vector(
		size.x / self.layers:GetWide(),
		size.y / self.layers:GetTall(),
		1
	))
	matrix:Translate(Vector(-layersOffset.x, -layersOffset.y, 0))

	---------

	local image

	render.PushRenderTarget(rt)
		render.Clear(0, 0, 0, 0, true, true)

		cam.Start2D()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.photo)
			surface.DrawTexturedRect(0, 0, size.x, size.y)

			cam.PushModelMatrix(matrix)
				self.layers:PaintManual()
			cam.PopModelMatrix()
		cam.End2D()

		image = Polaroid:CaptureImage()
	render.PopRenderTarget()

	return image
end

function Editor:CreateLayersTool()
	local layersTool = self.tools:Add("gmod.one/polaroid/editor/tool/dummy")
	layersTool:Setup(self, materials.layers, "Layers")
	layersTool.Open = function(me)
		local popup = self:CreatePopup(me)
		popup:SetSize(200, 256)

		local createLayer

		local creator = popup:Add("DButton")
		creator:Dock(BOTTOM)
		creator:DockMargin(4, 4, 4, 4)
		creator:SetText("Add layer")
		creator:SetFont("gmod.one/polaroid/newLayer")
		creator:SizeToContents()
		creator:SetTall(creator:GetTall() + 4)
		creator.Paint = function(me, w, h)
			surface.SetDrawColor(me:IsHovered() and colors.backgroundHover or colors.background)
			surface.DrawRect(0, 0, w, h)
		end
		creator.DoClick = function()
			createLayer(
				self:CreateLayer()
			)
		end

		local scroll = popup:Add("DScrollPanel")
		BeautifyScroll(scroll)
		scroll:Dock(FILL)
		scroll:DockMargin(2, 2, 2, 2)

		function createLayer(layer)
			local item = scroll:Add("EditablePanel")
			layer.controlPanel = item
			item:SetZPos(layer:GetZPos())
			item:Dock(TOP)
			item:DockMargin(2, 2, 2, 2)
			item:SetTall(32)
			item.Paint = function(_, w, h)
				surface.SetDrawColor(self.activeLayer == layer.LayerIndex and colors.background or colors.backgroundUnfocus)
				surface.DrawRect(0, 0, w, h)

				draw.SimpleText(layer.LayerName, "gmod.one/polaroid/layerName", 8, h * 0.5, colors.backgroundWhite, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			item:SetCursor("hand")
			item.OnMousePressed = function(me, mcode)
				if mcode ~= MOUSE_LEFT then return end
				me.down = true
			end
			item.OnMouseReleased = function(me, mcode)
				if me.down and mcode == MOUSE_LEFT then
					me.down = false

					local old = self:GetActiveLayer()
					if IsValid(old) then
						old:SetMouseInputEnabled(false)
					end

					self.activeLayer = layer.LayerIndex
					layer:SetMouseInputEnabled(true)
				end
			end

			------------------------

			local iconSize = 14
			local iconGap = 6

			local buttons = item:Add("EditablePanel")
			buttons:Dock(RIGHT)
			buttons:SetWide(iconSize * 3 + iconGap * 2)
			buttons:DockMargin(0, 0, 8, 0)

			local container = buttons:Add("EditablePanel")
			container:SetSize(buttons:GetWide(), iconSize)

			buttons.PerformLayout = function(me, _, h)
				container.y = h * 0.5 - container:GetTall() * 0.5
			end

			local arrows = container:Add("EditablePanel")
			arrows:Dock(LEFT)
			arrows:SetWide(iconSize)
			arrows.Move = function(me, dir)
				if dir == TOP and IsValid(me.prevLayer) then
					me:SwapWith(me.prevLayer)
				elseif dir == BOTTOM and IsValid(me.nextLayer) then
					me:SwapWith(me.nextLayer)
				end
			end
			arrows.Update = function(me)
				if IsValid(layer) == false then return end

				local nextLayer, prevLayer
				local zpos = layer:GetZPos()

				for _, layer2 in ipairs(self.layers:GetChildren()) do
					if layer2:GetZPos() > zpos then
						if nextLayer and layer2:GetZPos() > nextLayer:GetZPos() then continue end
						nextLayer = layer2
					elseif layer2:GetZPos() < zpos then
						if prevLayer and layer2:GetZPos() < prevLayer:GetZPos() then continue end
						prevLayer = layer2
					end
				end

				me.prevLayer = prevLayer
				me.nextLayer = nextLayer

				me.up.disabled = IsValid(prevLayer) == false
				me.down.disabled = IsValid(nextLayer) == false

				me.up:SetCursor(me.up.disabled and "no" or "hand")
				me.down:SetCursor(me.down.disabled and "no" or "hand")
			end
			arrows.SwapWith = function(me, layer2)
				local a, b = layer:GetZPos(), layer2:GetZPos()

				layer:SetZPos(b)
				layer.controlPanel:SetZPos(b)

				layer2:SetZPos(a)
				layer2.controlPanel:SetZPos(a)

				hook.Run("gmod.one/polaroid/editor/layersUpdate")
			end

			arrows.up = arrows:Add("EditablePanel")
			arrows.up:Dock(TOP)
			arrows.up:SetTall(5)
			arrows.up:SetTooltip("Move up")
			arrows.up.Paint = function(me, w, h)
				surface.SetDrawColor(me.disabled and colors.backgroundWhiteDisabled or colors.backgroundWhite)
				surface.SetMaterial(materials.arrow)
				surface.DrawTexturedRectRotated(w * 0.5, h * 0.5, w, h, 180)
			end
			arrows.up.OnMousePressed = function(me, mcode)
				if mcode ~= MOUSE_LEFT then return end
				me.down = true
			end
			arrows.up.OnMouseReleased = function(me, mcode)
				if me.down and mcode == MOUSE_LEFT then
					me.down = false
					arrows:Move(TOP)
				end
			end

			arrows.down = arrows:Add("EditablePanel")
			arrows.down:Dock(BOTTOM)
			arrows.down:SetTall(5)
			arrows.down:SetTooltip("Move down")
			arrows.down.Paint = function(me, w, h)
				surface.SetDrawColor(me.disabled and colors.backgroundWhiteDisabled or colors.backgroundWhite)
				surface.SetMaterial(materials.arrow)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			arrows.down.OnMousePressed = function(me, mcode)
				if mcode ~= MOUSE_LEFT then return end
				me.down = true
			end
			arrows.down.OnMouseReleased = function(me, mcode)
				if me.down and mcode == MOUSE_LEFT then
					me.down = false
					arrows:Move(BOTTOM)
				end
			end

			arrows:Update()
			hook.Add("gmod.one/polaroid/editor/layersUpdate", arrows, function(me)
				me:Update()
			end)

			local check = container:Add("EditablePanel")
			check:Dock(LEFT)
			check:DockMargin(iconGap, 0, 0, 0)
			check:SetWide(iconSize)
			check:SetCursor("hand")
			check.Paint = function(me, w, h)
				surface.SetDrawColor(colors.backgroundWhite)

				if layer:IsVisible() then
					surface.SetMaterial(materials.eye)
					surface.DrawTexturedRect(0, 0, w, h)
				else
					surface.DrawRect(0, 0, w, 1)
					surface.DrawRect(0, 0, 1, h)
					surface.DrawRect(0, h - 1, w, 1)
					surface.DrawRect(w - 1, 0, 1, h)
				end
			end
			check.OnMousePressed = function(me, mcode)
				if mcode ~= MOUSE_LEFT then return end
				me.down = true
			end
			check.OnMouseReleased = function(me, mcode)
				if me.down and mcode == MOUSE_LEFT then
					me.down = false
					layer:SetVisible(not layer:IsVisible())
				end
			end

			------------------------

			local trashbin = container:Add("EditablePanel")
			trashbin:Dock(LEFT)
			trashbin:DockMargin(iconGap, 0, 0, 0)
			trashbin:SetCursor("hand")
			trashbin:SetWide(iconSize)
			trashbin.Paint = function(me, w, h)
				surface.SetDrawColor(colors.backgroundWhite)
				surface.SetMaterial(materials.trashbin)
				surface.DrawTexturedRect(0, 0, w, h)
			end
			trashbin.OnMousePressed = function(me, mcode)
				if mcode ~= MOUSE_LEFT then return end
				me.down = true
			end
			trashbin.OnMouseReleased = function(me, mcode)
				if me.down and mcode == MOUSE_LEFT then
					me.down = false
					item:Remove()
					layer:Remove()
				end
			end
		end

		for _, layer in ipairs(self.layers:GetChildren()) do
			createLayer(layer)
		end
	end
end

function Editor:CreateColorPicker()
	local picker = self.tools:Add("gmod.one/polaroid/editor/tool/dummy")
	picker:Setup(self, nil, "Color picker")
	picker.Open = function(me)
		local popup = self:CreatePopup(me)
		popup:SetSize(168, 144 + 8 + 16 + 8 + 16)

		local palleteRow = popup:Add("EditablePanel")
		palleteRow:Dock(TOP)
		palleteRow:SetTall(16)
		palleteRow:DockMargin(8, 8, 8, 0)

		local manualChannels

		local cube = popup:Add("DColorMixer")
		cube:SetColor(self.brushColor)
		cube:SetPalette(false)
		cube:SetAlphaBar(false)
		cube:SetWangs(false)
		cube:Dock(TOP)
		cube:SetTall(144 - 16)
		cube:DockMargin(8, 8, 8, 8)
		cube.ValueChanged = function(me, col)
			self.brushColor = col

			for _, chan in ipairs(manualChannels:GetChildren()) do
				local new = tostring(col[chan.channel])
				if new ~= chan:GetText() then
					chan:SetText(new)
				end
			end
		end

		local size = palleteRow:GetTall()
		local freeSpace = (popup:GetWide() - 16) - size * #pallete
		local gap = freeSpace / (#pallete - 1)
		local x = 0

		for _, col in ipairs(pallete) do
			local btn = palleteRow:Add("EditablePanel")
			btn:SetSize(size, size)
			btn.x = x

			btn.Paint = function(_, w, h)
				surface.SetDrawColor(col)
				surface.DrawRect(0, 0, w, h)
			end

			btn:SetCursor("hand")
			btn.OnMousePressed = function(me, mcode)
				if mcode ~= MOUSE_LEFT then return end
				me.down = true
			end
			btn.OnMouseReleased = function(me, mcode)
				if me.down and mcode == MOUSE_LEFT then
					me.down = false
					self.brushColor = col
					cube:SetColor(col)
				end
			end

			x = x + size + gap
		end

		manualChannels = popup:Add("EditablePanel")
		manualChannels:Dock(TOP)
		manualChannels:DockMargin(8, 0, 8, 8)
		manualChannels:SetTall(16)

		local manualGap = 8
		local manualWide = (popup:GetWide() - 16 - manualGap * 2) / 3

		for i, channel in ipairs({"r", "g", "b"}) do
			local chan = manualChannels:Add("gmod.one/polaroid/input")
			chan.channel = channel
			chan:Dock(LEFT)
			chan:SetWide(manualWide)
			chan:SetText(self.brushColor[channel])
			chan:SetPlaceholderText("0")
			chan:SetNumeric(true)
			chan:SetUpdateOnType(true)

			chan:SetFont("gmod.one/polaroid/slider")
			chan.m_FontName = "gmod.one/polaroid/slider"
			chan:SetFontInternal("gmod.one/polaroid/slider")

			chan:SetTextDarkest(50, 255)
			chan.m_bBackground = true
			chan.FocusedBackgroundColor = colors.background
			chan.BackgroundColor = colors.background
			chan.BottomLineSize = 1

			local Paint = chan.Paint
			chan.Paint = function(me, w, h)
				surface.SetDrawColor(colors.backgroundWhite)
				surface.DrawRect(0, 0, w, h)

				Paint(me, w, h)
			end

			if i ~= 1 then chan:DockMargin(manualGap, 0, 0, 0) end

			chan.AllowInput = function(me, v)
				if me:CheckNumeric(v) then return true end

				local new = tonumber(me:GetText() .. v)
				new = new and math.floor(new)

				return new == nil or (
					new > 255 or new < 0
				)
			end
			chan.OnValueChange = function(me, v)
				local num = math.Clamp(tonumber(v) or 0, 0, 255)

				if v ~= tostring(num) then
					me:SetText(num)
				end

				self.brushColor[channel] = num
				cube:SetColor(self.brushColor)
			end
		end
	end
	picker.Paint = function(me, w, h)
		local x, y = 0, 0
		if me:IsActive() then
			x, y = 2, 2
			w, h = w - 4, h - 4
		end

		draw.RoundedBox(4, x, y, w, h, self.brushColor)
	end
end

function Editor:CreateToolSpacer()
	local spacer = self.tools:Add("EditablePanel")
	spacer:Dock(TOP)
	spacer:SetTall(12)
end

function Editor:CreateTool(name, icon, cback)
	local tool = self.tools:Add("EditablePanel")
	if name then
		tool:SetTooltip(name)
	end
	tool:Dock(TOP)
	tool:SetTall(28)
	tool:DockMargin(0, 4, 4, 0)
	tool:SetCursor("hand")
	tool.Paint = icon and function(me, w, h)
		local x, y = 0, 0
		local isActive = self.activeTool == me

		if isActive then
			x, y = 2, 2
			w, h = w - 4, h - 4
		end

		draw.RoundedBox(4, x, y, w, h, me:IsHovered() and colors.whiteHover or colors.backgroundWhite)

		surface.SetDrawColor(isActive and colors.background or colors.dark)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(x + 2, y + 2, w - 4, h - 4)
	end
	tool.OnMousePressed = function(me, mcode)
		if mcode ~= MOUSE_LEFT then return end
		me.down = true
	end
	tool.OnMouseReleased = function(me, mcode)
		if me.down and mcode == MOUSE_LEFT then
			me.down = false

			if self.activeTool == me then return end

			self.activeTool = me
			if IsValid(self.popup) then self.popup:Remove() end

			if cback then cback(me) end
		end
	end

	if self.activeTool == nil then
		self.activeTool = tool
		if cback then cback(tool) end
	end

	return tool
end

function Editor:Close()
	if self._Closing then return end
	self._Closing = true

	self:AlphaTo(0, 0.2, 0, function()
		self:Remove()
	end)
end

function Editor:Think()
	if input.IsKeyDown(KEY_ESCAPE) or IsValid(self.swep) == false then
		self:Remove()
		return
	end

	if self.disableTools then -- w8 4 mouse release if its down on ui open
		if input.IsMouseDown(MOUSE_LEFT) == false then
			self.disableTools = false
		end

		return
	end

	if input.IsMouseDown(MOUSE_LEFT) and self.disableDraw == false then
		local tool = self.activeTool
		if tool.Render == nil then return end

		local layer = self:GetActiveLayer()
		if (IsValid(layer) and layer:IsHovered()) == false then return end

		tool:RenderAt(layer, layer:LocalCursorPos())
	end
end

vgui.Register("gmod.one/polaroid/editor", Editor, "EditablePanel")

-- if IsValid(_editorTest) then _editorTest:Remove() end
-- _editorTest = vgui.Create("gmod.one/polaroid/editor")
-- _editorTest.photo = Material("polaroid/wip/883853bdd23a31dc14a622ff5cca606e045690d08401df20b3f779f0680adb35.jpg")
