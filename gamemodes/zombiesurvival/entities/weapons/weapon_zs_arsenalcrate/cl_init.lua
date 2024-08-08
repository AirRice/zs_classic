include("shared.lua")

SWEP.PrintName = "상점 상자"
SWEP.Description = "생존에 있어 매우 귀중한 상자. 새로운 무기, 도구, 탄약 및 기타 등등을 구입할 수 있다.\n소유자는 타인이 구입한 구매액의 7% 수수료를 받는다.\n주 공격 버튼으로 설치.\n보조 공격 버튼, 재장전 버튼으로 회전."
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

local GetConVarNumber = GetConVarNumber

function SWEP:DrawHUD()
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end

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

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber

local nextclick = 0
function SWEP:RotateGhost(amount)
	local realTime = RealTime()
	if nextclick <= realTime then
		surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
		nextclick = realTime + 0.3
	end

	RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
end
