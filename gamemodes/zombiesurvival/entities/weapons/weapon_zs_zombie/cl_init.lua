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

include("shared.lua")

SWEP.PrintName = "좀비"
SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false

function SWEP:Reload()
end

function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber
local GetGlobalBool = GetGlobalBool
local ScrW = ScrW
local ScrH = ScrH
local Material = Material
local draw = draw

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
