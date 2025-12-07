-- developed for gmod.store
-- from gmod.one with love <3

AddCSLuaFile()

ENT.Base = "polaroid_frame"
ENT.Category  	= "Polaroid"
ENT.Spawnable = true

ENT.PrintName = "Polaroid Frame - Medium"
ENT.ModelScale = 0.5

if SERVER then return end

surface.CreateFont("PolaroidCamera.DescriptionMedium", {
	font = "Roboto",
	extended = true,
	size = 40,
	width = 700,
})

ENT.TextFont = "PolaroidCamera.DescriptionMedium"
ENT.MaxDist = 1000 ^ 2

ENT.PictureOffsets = {
	up = 0.5,
	right = -23,
	forward = -34,
	modifyang = function(ang)
		ang:RotateAroundAxis(ang:Right(), 90)
		ang:RotateAroundAxis(ang:Up(), -90)
	end
}

ENT.PictureSize = {
	w = 900,
	h = 900,
	size = 0.05
}

ENT.TextPos = {
	x = 10,
	y = 830
}
