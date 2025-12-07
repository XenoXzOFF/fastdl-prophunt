local colors = {
	background = Color(220, 70, 40),
	backgroundWhite = Color(250, 220, 195),
	dark = Color(51, 51, 51)
}

local Dummy = {}

function Dummy:Init()
	self:Dock(TOP)
	self:SetTall(28)
	self:DockMargin(0, 4, 4, 0)
	self:SetCursor("hand")
end

function Dummy:Setup(editor, icon, desc)
	self.editor = editor
	self.icon = icon
	self:SetTooltip(desc)
end

function Dummy:Paint(w, h)
	local x, y = 0, 0
	local isActive = self:IsActive()

	if isActive and IsValid(self.editor.popup) then
		x, y = 2, 2
		w, h = w - 4, h - 4
	end

	draw.RoundedBox(4, x, y, w, h, self:IsHovered() and colors.whiteHover or colors.backgroundWhite)

	surface.SetDrawColor(isActive and colors.background or colors.dark)
	surface.SetMaterial(self.icon)
	surface.DrawTexturedRect(x + 2, y + 2, w - 4, h - 4)
end

function Dummy:OnMousePressed(mcode)
	if mcode ~= MOUSE_LEFT then return end
	self.down = true
end

function Dummy:OnMouseReleased(mcode)
	if self.down and mcode == MOUSE_LEFT then
		self.down = false

		if IsValid(self.editor.popup) then
			self.editor.popup:Remove()
			if self:IsActive() then return end
		end

		self.editor.activeTool = self
		if self.Open and IsValid(self.editor.popup) == false then self:Open() end
	end
end

function Dummy:IsActive()
	return self.editor.activeTool == self
end

vgui.Register("gmod.one/polaroid/editor/tool/dummy", Dummy, "EditablePanel")

local Tool = {}

function Tool:RenderAt(layer, x, y)
	local oldRenderData = self.lastRenderData
	local newRenderData = {
		frame = FrameNumber(),
		pos = Vector(x, y)
	}
	self.lastRenderData = newRenderData

	layer:PushRender()
		if oldRenderData and oldRenderData.frame + 1 == newRenderData.frame then
			self:InterpolateRender(layer, oldRenderData.pos, newRenderData.pos)
		end

		self:Render(x, y)
	layer:PopRender()
end

function Tool:InterpolateRender(layer, oldPos, curPos)
	local dist = oldPos:Distance(curPos)
	local radius = self:GetRadius()

	if dist <= radius * 0.75 then return end

	local ang = math.deg(math.atan2(curPos.y - oldPos.y, curPos.x - oldPos.x))
	local dir = Angle(0, ang, 0):Forward() * radius * 0.5

	local pos = oldPos

	for i = 1, dist / radius * 2 do
		pos = pos + dir
		self:Render(pos.x, pos.y)
	end
end

vgui.Register("gmod.one/polaroid/editor/tool", Tool, "gmod.one/polaroid/editor/tool/dummy")
