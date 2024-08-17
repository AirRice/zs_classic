include("shared.lua")

SWEP.PrintName = "메세지 비콘"
SWEP.Description = "범위 안의 다른 아군에게 메세지를 전송한다.\n보조 공격 버튼으로 다른 메세지 선택\n주 공격 버튼으로 설치\n달리기 버튼으로 회수 가능"
SWEP.DrawCrosshair = false

SWEP.Slot = 4
SWEP.SlotPos = 0

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	return true
end

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

function SWEP:PrimaryAttack()
end

function SWEP:DrawWeaponSelection(...)
	return self:BaseDrawWeaponSelection(...)
end

function SWEP:Think()
end

local function okclick(self)
	RunConsoleCommand("setmessagebeaconmessage", self:GetParent().Choice)
	self:GetParent():Close()
end

local function onselect(self, index, value, data)
	self:GetParent().Choice = data
end

local Menu
function SWEP:SecondaryAttack()
	if Menu and Menu:Valid() then
		Menu:SetVisible(true)
		return
	end

	Menu = vgui.Create("DFrame")
	Menu:SetDeleteOnClose(false)
	Menu:SetSize(200, 100)
	Menu:SetTitle("메세지 선택")
	Menu:Center()
	Menu.Choice = 1

	local choice = vgui.Create("DComboBox", Menu)
	for k, v in ipairs(GAMEMODE.ValidBeaconMessages) do
		choice:AddChoice(translate.Get(v), k)
	end
	choice:ChooseOption(GAMEMODE.ValidBeaconMessages[1], 1)
	choice:SizeToContents()
	choice:SetWide(Menu:GetWide() - 16)
	choice:Center()
	choice.OnSelect = onselect

	local ok = EasyButton(Menu, "OK", 8, 4)
	ok:AlignBottom(8)
	ok:CenterHorizontal()
	ok.DoClick = okclick

	Menu:MakePopup()
end
