include("shared.lua")

SWEP.PrintName = "포이즌 헤드크랩"
SWEP.ViewModelFOV = 70
SWEP.DrawCrosshair = false

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
