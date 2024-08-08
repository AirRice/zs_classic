
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

SWEP.PrintName = "적외선 레이저 터렛"
SWEP.Description = "이 자동화 터렛은 탄약을 계속 보급해주고 유지/보수만 잘 해준다면 거점 방어에 매우 유용하다.\n주 공격 버튼으로 설치\n보조 공격 버튼 및 재장전 버튼으로 회전\n설치된 터렛에 사용 키를 눌러 보유중인 SMG 탄환을 터렛에 충전\n주인이 없는 터렛(파란 빛)에 사용 키를 눌러 소유권 획득"
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

function SWEP:Deploy()
	self.IdleAnimation = CurTime() + self:SequenceDuration()

	return true
end

function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
	if self.Owner:KeyDown(IN_ATTACK2) then
		self:RotateGhost(FrameTime() * 60)
	end
	if self.Owner:KeyDown(IN_RELOAD) then
		self:RotateGhost(FrameTime() * -60)
	end
end

local nextclick = 0
function SWEP:RotateGhost(amount)
	if nextclick <= RealTime() then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = RealTime() + 0.3
	end
	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
