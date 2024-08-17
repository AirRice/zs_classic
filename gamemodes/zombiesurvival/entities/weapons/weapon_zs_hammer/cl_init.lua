include("shared.lua")

SWEP.PrintName = "목수의 망치"
SWEP.Description = "가성비 최강의 서바이벌 용품. 프롭에 못을 박아 바리케이드를 건설할 수 있게 해준다.\n보조 공격 버튼으로 못 박기. 바라보는 프롭과 그 뒤의 프롭 또는 월드가 고정된다.\n재장전 버튼으로 못 뽑기\n주 공격 버튼으로 좀비의 머리통 깨기, 혹은 못 수리\n내구도가 상한 못을 수리하면 포인트를 얻지만, 다른 플레이어의 못을 제거하면 포인트를 잃는다."

SWEP.ViewModelFOV = 75

local surface = surface
local RealTime = RealTime
local RunConsoleCommand = RunConsoleCommand
local math = math
local GetConVarNumber = GetConVarNumber
local GetGlobalBool = GetGlobalBool
local ScrW = ScrW
local ScrH = ScrH

function SWEP:DrawHUD()
	if GetGlobalBool("classicmode") then return end

	surface.SetFont("ZSHUDFontSmall")
	local text = translate.Get("right_click_to_hammer_nail")
	local nails = self:GetPrimaryAmmoCount()
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleTextBlurry(translate.Format("nails_x", nails), "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 3, nails > 0 and COLOR_LIMEGREEN or COLOR_RED, TEXT_ALIGN_CENTER)

	draw.SimpleTextBlurry(text, "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 2, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
