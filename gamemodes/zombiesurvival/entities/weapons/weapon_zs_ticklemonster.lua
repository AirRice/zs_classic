AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "티클 몬스터"
end

SWEP.Base = "weapon_zs_zombie"

SWEP.Primary.Delay = 1.2
SWEP.MeleeDelay = 0.74
SWEP.MeleeDamage = 22
SWEP.MeleeReach = 160
SWEP.MeleeSize = 5
SWEP.Rage = nil
function SWEP:Reload()
	self:SecondaryAttack()
end

function SWEP:Think()
	self.BaseClass.Think(self)
	if self.Owner:Health()<self.Owner:GetMaxHealth()*0.2 then
		self.Rage = true
	else self.Rage = nil 
	end
	if self.Rage then
		self.MeleeDamage= 33
	else 
		self.MeleeDamage=22
	end
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end
SWEP.PlayIdleSound = SWEP.PlayAlertSound

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_bark"..math.random(2)..".wav")
end

if not CLIENT then return end

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

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("Models/Charple/Charple1_sheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
