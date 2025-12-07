-- developed for gmod.store
-- from gmod.one with love <3

AddCSLuaFile()

ENT.Base = "polaroid_frame"
ENT.Category  = "Polaroid"
ENT.Spawnable = true

ENT.PrintName = "Polaroid Frame - Small"
ENT.ModelScale = 0.25

if SERVER then return end

surface.CreateFont("PolaroidCamera.DescriptionSmall", {
	font = "Roboto",
	extended = true,
	size = 30,
	width = 700,
})

ENT.TextFont = "PolaroidCamera.DescriptionSmall"
ENT.MaxDist = 900 ^ 2

ENT.PictureOffsets = {
	up = 0.5,
	right = -11.5,
	forward = -17,
	modifyang = function(ang)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
	end
}

ENT.PictureSize = {
	w = 450,
	h = 450,
	size = 0.05
}

ENT.TextPos = {
	x = 10,
	y = 410
}
