include("shared.lua")

SWEP.PrintName = "챔 좀비"
SWEP.DrawCrosshair = false

function SWEP:Think()
end

local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
