-- developed for gmod.store
-- from gmod.one with love <3

ENT.TextFont = "PolaroidCamera.DescriptionLarge"
ENT.TextColr = Color(220, 220, 220)
ENT.MaxDist = 1500 ^ 2

ENT.rtSize = Vector(1024, 576)
ENT.rtRotate = Angle(0, 90, 0)

-----------------

ENT.rtTranslate1 = Vector(ENT.rtSize.y, ENT.rtSize.x) * 0.5
ENT.rtTranslate2 = ENT.rtSize * -0.5

-----------------

include("shared.lua")

surface.CreateFont("PolaroidCamera.DescriptionLarge", {
	font = "Roboto",
	size = 24,
	width = 700,
	extended = true,
	shadow = true
})
