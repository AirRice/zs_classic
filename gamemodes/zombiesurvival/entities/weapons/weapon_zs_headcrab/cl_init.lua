include("shared.lua")

SWEP.PrintName = "헤드크랩"
SWEP.DrawCrosshair = false

local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber
local GetGlobalBool = GetGlobalBool
local ScrW = ScrW
local ScrH = ScrH

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end
