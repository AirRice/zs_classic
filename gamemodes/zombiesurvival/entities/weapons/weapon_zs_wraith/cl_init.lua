include("shared.lua")

SWEP.PrintName = "망령"
SWEP.ViewModelFOV = 47

--[[function SWEP:Holster()
	if self.Owner:IsValid() and self.Owner == MySelf then
		self.Owner:SetBarricadeGhosting(false)
	end

	return self.BaseClass.Holster(self)
end]]

local Color = Color
local render = render
local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber
local ScrW = ScrW
local ScrH = ScrH
local cam = cam
local GetGlobalBool = GetGlobalBool
local Material = Material
local draw = draw
local IsValid = IsValid
local pairs = pairs
local ipairs = ipairs
local table = table
local type = type
local Matrix = Matrix
local Vector = Vector
local Angle = Angle
local EyePos = EyePos
local EyeAngles = EyeAngles
local ClientsideModel = ClientsideModel
local tostring = tostring
local tonumber = tonumber

function SWEP:PreDrawViewModel(vm)
	self.Owner:CallZombieFunction("PrePlayerDraw")
end

function SWEP:PostDrawViewModel(vm)
	self.Owner:CallZombieFunction("PostPlayerDraw")
end

--[[function SWEP:Think()
	self.BaseClass.Think(self)

	if self.Owner:IsValid() and MySelf == self.Owner then
		self:BarricadeGhostingThink()
	end
end]]
