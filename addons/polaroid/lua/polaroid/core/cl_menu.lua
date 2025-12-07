-- developed for gmod.store
-- from gmod.one with love <3

local Polaroid = g1_Polaroid

local IsKeyDown = input.IsKeyDown
local KEY_X, KEY_ESCAPE, CENTER = KEY_X, KEY_ESCAPE, TEXT_ALIGN_CENTER
local RoundedBox, RoundedBoxEx = draw.RoundedBox, draw.RoundedBoxEx
local SetDrawColor, DrawRect, SetMaterial, DrawTexturedRect, SimpleText, floor = surface.SetDrawColor, surface.DrawRect, surface.SetMaterial, surface.DrawTexturedRect, draw.SimpleText, math.floor

local Colors = {
	Background = Color(220, 70, 40),
	White = Color(255, 255, 255),
	WhiteBG = Color(250, 220, 195),
	Hover = Color(219, 193, 167),
	Dark = Color(51, 51, 51),
	Shadow = Color(5, 5, 15, 125),
	ShadowD = Color(5, 5, 5, 30),
}

local Material = {
	Close = Material("polaroid/close.png", "smooth"),
	Down = Material("polaroid/down.png", "smooth"),
	Ramp = Material("polaroid/ramp.png", "smooth"),
	Question = Material("polaroid/question.png", "smooth"),
	Label = Material("polaroid/label.png", "smooth"),
	Frame = Material("polaroid/frame.png", "smooth"),
}

local PANEL = {}

PANEL.Icon = Material.Question
PANEL.Title = Polaroid.translate("What are we going to do?")
PANEL.Desc = Polaroid.translate("please, select an action")

surface.CreateFont("gmod.one/polaroid/title", {
    font = "Roboto",
    extended = true,
    size = 26,
    weight = 700,
})

surface.CreateFont("gmod.one/polaroid/desc", {
    font = "Roboto",
    extended = true,
    size = 20,
    weight = 300,
})

function PANEL:Init()
	self.TranslatedElements = {}

	self.Title = Polaroid.translate("What are we going to do?")
	self.Desc = Polaroid.translate("please, select an action")

	hook.Add("Polaroid/LangsLoaded", self, function()
		self.Title = Polaroid.translate("What are we going to do?")
		self.Desc = Polaroid.translate("please, select an action")

		for i, elem in ipairs(self.TranslatedElements) do
			if IsValid(elem) and elem._LangPhrase then
				elem:SetText(Polaroid.translate(elem._LangPhrase))
			end
		end
	end)

	self:SetAlpha(0)
	self:AlphaTo(255, 0.2)
	self:SetSize(512, 450)

	self.Shadow = self:Add("EditablePanel")
	self.Shadow:SetPos(0, 32)
	self.Shadow:SetSize(self:GetWide() - 24, self:GetTall() - 32)
	self.Shadow.Paint = function(me, w, h)
		RoundedBox(9, 0, 0, w, h, Colors.Shadow)
	end

	self.WorkSpace = self:Add("EditablePanel")
	self.WorkSpace:SetPos(12, 16)
	self.WorkSpace:SetSize(self:GetWide() - 24, self:GetTall() - 32)
	self.WorkSpace.Paint = function(me, w, h)
		RoundedBox(9, 0, 0, w, h, Colors.Background)

		local _h = h / 1.5 - 8

		SetDrawColor(Colors.ShadowD)
		SetMaterial(Material.Ramp)
		DrawTexturedRect(0, 0, w, _h)

		local q_size = _h * 0.4

		if self.IcoMult then
			q_size = q_size * self.IcoMult
		end

		local qx, qy = w*0.5 - q_size*0.5, _h*0.5 - q_size*0.85

		if self.IcoYAdd then
			qy = qy + self.IcoYAdd
		end

		SetMaterial(self.Icon)
		SetDrawColor(Colors.Shadow)
		DrawTexturedRect(qx - 4, qy + 8, q_size, q_size + 2)

		SetDrawColor(Colors.WhiteBG)
		DrawTexturedRect(qx, qy, q_size, q_size)

		RoundedBoxEx(9, 0, _h - 1, w, h, Colors.ShadowD, false, false, true, true)

		local t_add = self.TextYAdd or 0

		local tw, th = SimpleText(self.Title, "gmod.one/polaroid/title", w*0.5, h*0.45 + t_add, Colors.WhiteBG, CENTER, CENTER)
		SimpleText(self.Desc, "gmod.one/polaroid/desc", w*0.5, h*0.45 + t_add + th, Colors.WhiteBG, CENTER, CENTER)
	end

	self.WorkSpace.Head = self.WorkSpace:Add("EditablePanel")
	self.WorkSpace.Head:SetSize(self.WorkSpace:GetWide(), self.WorkSpace:GetTall() / 1.5)

	self.WorkSpace.Foot = self.WorkSpace:Add("EditablePanel")
	self.WorkSpace.Foot.X = 3
	self.WorkSpace.Foot.Y = self.WorkSpace.Head:GetTall()
	self.WorkSpace.Foot:SetSize(self.WorkSpace:GetWide() - 6, self.WorkSpace:GetTall() - self.WorkSpace.Foot.Y - 3)
	self.WorkSpace.Foot.Paint = function(me, w, h)
		RoundedBoxEx(6, 0, 0, w, h, Colors.WhiteBG, false, false, true, true)

		local mw, mh = 33, 15
		local x = w*0.5 - mw*0.5

		SetMaterial(Material.Down)

		SetDrawColor(Colors.Shadow)
		DrawTexturedRect(x - 5, 0, mw + 5, mh + 3)

		SetDrawColor(Colors.Background)
		DrawTexturedRect(x, 0, mw, mh)

		SetDrawColor(Colors.ShadowD)
		DrawTexturedRect(x, 0, mw, mh)
	end

	self.CloseShadow = self:Add("EditablePanel")
	self.CloseShadow:SetSize(48, 48)
	self.CloseShadow.X = self:GetWide() - self.CloseShadow:GetWide() - 4
	self.CloseShadow.Y = 6
	self.CloseShadow.Paint = function(me, w, h)
		SetDrawColor(Colors.Shadow)
		SetMaterial(Material.Close)
		DrawTexturedRect(0, 0, w, h)
	end

	self.CloseButton = self:Add("EditablePanel")
	self.CloseButton:SetMouseInputEnabled(true)
	self.CloseButton:SetCursor("hand")
	self.CloseButton:SetSize(48, 48)
	self.CloseButton.X = self:GetWide() - self.CloseButton:GetWide()
	self.CloseButton.OnMouseReleased = function(me, mcode)
		if mcode == MOUSE_LEFT then
			self:Close()
		end
	end
	self.CloseButton.Paint = function(me, w, h)
		SetDrawColor(me:IsHovered() and Colors.Hover or Colors.WhiteBG)
		SetMaterial(Material.Close)
		DrawTexturedRect(0, 0, w, h)
	end
end

function PANEL:Close()
	self:AlphaTo(0, 0.2, 0, function()
		self:Remove()
	end)
end

function PANEL:Think()
	if IsKeyDown(KEY_X) then
		if (LastTextInputFocus or 0) + 0.15 > CurTime() then return end
		self:Close()
	end

	if IsKeyDown(KEY_ESCAPE) then
		self:Remove()
	end
end

function PANEL:CreateButtons(lang_phrase1, lang_phrase2, parent, ent)
	local btn = parent:Add("gmod.one/polaroid/button")
	btn.DoClick = function()
		self:SetMode(ent, 2)
	end

	local btn2 = parent:Add("gmod.one/polaroid/button")
	btn2.DoClick = function()
		self:Close()
		net.Start("gmod.one/polaroid/entity")
			net.WriteEntity(ent)
			net.WriteBool(true)
		net.SendToServer()
	end

	btn.OnPerformLayout = function()
		local summ_w = btn:GetWide() + btn2:GetWide() + 16

		local y = parent:GetTall()*0.5 - btn:GetTall()*0.5
		local x = parent:GetWide()*0.5 - summ_w*0.5

		btn:SetPos(x, y)
		btn2:SetPos(x + btn:GetWide() + 16, y)
	end

	btn:SetText( Polaroid.translate(lang_phrase1) )
	btn._LangPhrase = lang_phrase1

	btn2:SetText( Polaroid.translate(lang_phrase2) )
	btn2._LangPhrase = lang_phrase2

	table.insert(self.TranslatedElements, btn)
	table.insert(self.TranslatedElements, btn2)
end

PANEL.ModeList = {
	[1] = function(self, parent, ent)
		self:CreateButtons("Change Title", "Pull Photo", parent, ent)
	end,
	[2] = function(self, parent, ent)
		self.Icon = Material.Label
		self.Title = Polaroid.translate("Title editing..")
		self.Desc = Polaroid.translate("please, enter a new title")

		local text = ""
		if ent.IsPolaroidPhoto then
			text = ent:GetDesc()
		end

		local input = parent:Add("gmod.one/polaroid/input")
		input:SetSize(parent:GetWide()*0.75, parent:GetTall()*0.35)
		input:SetPos(parent:GetWide()*0.5 - input:GetWide()*0.5, parent:GetTall()*0.5 - input:GetTall()*0.5)
		input:SetTextDarkest(0, 225)
		input:SetText(text)

		local ok_color = Color(0, 0, 0, 225)

		input:SetWide(input:GetWide() - input:GetTall())
		input.btn = parent:Add("EditablePanel")
		input.btn:SetMouseInputEnabled(true)
		input.btn:SetCursor("hand")
		input.btn._Text = ""
		input.btn.SetText = function(me, str)
			me._Text = str
		end
		input.btn.GetText = function(me)
			return me._Text
		end
		input.btn:SetSize(input:GetTall(), input:GetTall())
		input.btn.Y = input.Y
		input.btn.X = input.X + input:GetWide()
		input.btn:SetText(Polaroid.translate("OK"))
		input.btn._LangPhrase = "OK"
		input.btn.Paint = function(me, w, h)
			RoundedBox(0, 0, 0, w, h, input.CurrentColor)

			SimpleText(me:GetText(), "gmod.one/polaroid/title", w*0.5, h*0.5, ok_color, CENTER, CENTER)
		end
		input.btn.OnMouseReleased = function(me, mcode)
			if mcode ~= MOUSE_LEFT then return end

			me:DoClick()
		end
		input.btn.DoClick = function(me)
			self:Close()
			net.Start("gmod.one/polaroid/entity")
				net.WriteEntity(ent)
				net.WriteBool(false)
				net.WriteString(input:GetText())
			net.SendToServer()
		end

		input.OnEnter = input.btn.DoClick

		table.insert(self.TranslatedElements, input.btn)
	end,
	[3] = function(self, parent, ent)
		self:CreateButtons("Change Title", "Tear", parent, ent)
	end,
	[4] = function(self, parent, ent)
		self.Icon = Material.Frame
		self.Title = Polaroid.translate("Picture Frame")
		self.Desc = Polaroid.translate("please, put a photo in me")
		self.IcoMult = 2.75
		self.IcoYAdd = 64
		self.TextYAdd = 64
		self:SetTall(self:GetTall()*0.65)
		self.WorkSpace:SetTall(self:GetTall() - 32)
		self.Shadow:SetTall(self:GetTall() - 32)
		self.WorkSpace.Foot:Remove()
		self:Center()
		-- a lot of hacks ;d

		hook.Add("Polaroid/LangsLoaded", self, function()
			self.Title = Polaroid.translate("Picture Frame")
			self.Desc = Polaroid.translate("please, put a photo in me")

			for i, elem in ipairs(self.TranslatedElements) do
				if IsValid(elem) and elem._LangPhrase then
					elem:SetText(Polaroid.translate(elem._LangPhrase))
				end
			end
		end)
	end
}

function PANEL:SetMode(ent, mode)
	local parent = self.WorkSpace.Foot

	for k, child in pairs(parent:GetChildren()) do
		if IsValid(child) then
			child:Remove()
		end
	end

	mode = self.ModeList[mode]
	if mode then mode(self, parent, ent) end
end

vgui.Register("gmod.one/polaroid/menu", PANEL, "EditablePanel")

local PANEL = {}

PANEL.Text = "me:SetText(text, font)"
PANEL.Font = "gmod.one/polaroid/title"

function PANEL:Init()
	self.Shadow = self:Add("EditablePanel")
	self.Shadow.Y = 9
	self.Shadow.Paint = function(me, w, h)
		RoundedBox(8, 0, 0, w, h, Colors.Shadow)
	end

	self.Button = self:Add("EditablePanel")
	self.Button:SetMouseInputEnabled(true)
	self.Button:SetCursor("hand")
	self.Button.X = 6
	self.Button:SetText("")
	self.Button.Paint = function(me, w, h)
		RoundedBox(8, 0, 0, w, h, Colors.Background)
		if me:IsHovered() then
			RoundedBox(8, 0, 0, w, h, Colors.ShadowD)
		end

		SimpleText(self.Text, self.Font, w*0.5, h*0.5, Colors.WhiteBG, CENTER, CENTER)
	end
	self.Button.OnMouseReleased = function(me, mcode)
		if mcode == MOUSE_LEFT then
			self:DoClick()
		end
	end
end

function PANEL:SetText(text, font)
	self.Text = text or ""
	if font then
		self.Font = font
	end

	surface.SetFont(self.Font)
	local tw, th = surface.GetTextSize(self.Text)

	self:SetWide(tw + 32 + 6)
	self:SetTall(th + 16 + 8)
end

function PANEL:DoClick() end

function PANEL:PerformLayout(w, h)
	self.Shadow:SetSize(w - self.Button.X*2, h - self.Shadow.Y)
	self.Button:SetSize(w - self.Button.X, h - 8)

	self:OnPerformLayout(w, h)
end

function PANEL:OnPerformLayout(w, h) end

vgui.Register("gmod.one/polaroid/button", PANEL, "EditablePanel")

local PANEL = {}

PANEL.BackgroundColor = Color(0, 0, 0, 100)
PANEL.FocusedBackgroundColor = Color(30, 30, 30, 125)

PANEL.CurrentColor = PANEL.BackgroundColor

PANEL.BottomLineSize = 3

function PANEL:Paint(w, h)
	if self.m_bBackground then
		self.CurrentColor = self:HasFocus() and self.FocusedBackgroundColor or self.BackgroundColor

		surface.SetDrawColor(self.CurrentColor)
		surface.DrawRect(0, h - self.BottomLineSize, w, self.BottomLineSize)
	end

	if self.m_bAlwaysShowCursor and self:HasFocus() == false then
		surface.SetDrawColor(self:GetCursorColor())
		surface.DrawRect(w - 1, 0, 1, h)
	end

	-- Hack on a hack, but this produces the most close appearance to what it will actually look if text was actually there
	if self.GetPlaceholderText and self.GetPlaceholderColor and self:GetPlaceholderText() and self:GetPlaceholderText():Trim() ~= "" and self:GetPlaceholderColor() and (not self:GetText() or self:GetText() == "") then
		local oldText = self:GetText()

		local str = self:GetPlaceholderText()
		if str:StartWith("#") then str = str:sub(2) end
		str = language.GetPhrase(str)

		self:SetText(str)
		self:DrawTextEntryText(self:GetPlaceholderColor(), self:GetHighlightColor(), self:GetCursorColor())
		self:SetText(oldText)

		return
	end

	self:DrawTextEntryText(self:GetTextColor(), self:GetHighlightColor(), self:GetCursorColor())
end

function PANEL:Init()
	self:SetDrawLanguageID(false)
	self:SetKeyBoardInputEnabled(true)

	local SetFont = self.SetFont
	self.SetFont = function(me, font)
		SetFont(self, font)
		self.m_FontName = font
		self:SetFontInternal(font)
	end

	self:SetFont("gmod.one/polaroid/title")
	self:SetPlaceholderColor(Color(255, 255, 255, 150))
	self:SetTextColor(Color(255, 255, 255, 150))
end

function PANEL:OnMousePressed(mcode)
	if mcode == MOUSE_RIGHT then
		return true
	end
end

function PANEL:SetTextDarkest(num, alpha)
	num = num or 0
	self:SetPlaceholderColor(Color(num, num, num, alpha or 150))
	self:SetTextColor(Color(num, num, num, alpha or 150))
end

function PANEL:Think()
	if self:HasFocus() then
		LastTextInputFocus = CurTime()
	end
end

vgui.Register("gmod.one/polaroid/input", PANEL, "DTextEntry")
