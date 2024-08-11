AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "좀바인"
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
end

SWEP.Base = "weapon_zs_zombie"

SWEP.MeleeDamage = 45
SWEP.MeleeForceScale = 1.25

SWEP.Primary.Delay = 1.4
SWEP.AttackMotion = 39
SWEP.DuringModeChange = false
SWEP.DuringShieldUp = false
function SWEP:DrawWorldModel()
end
SWEP.DrawWorldModelTranslucent = SWEP.DrawWorldModel
function SWEP:SetupDataTables()
	self:NetworkVar( "Float", 10, "NextModeSwitch" )
	self:NetworkVar( "Int", 10, "MovementMode" )
	self:NetworkVar("Float",11, "AttackAnimTime")
	self:NetworkVar("Float",12, "ShieldTime")
end
function SWEP:Initialize()
	self:SetShieldTime(CurTime())
	self:SetAttackAnimTime(CurTime())
end

function SWEP:IsInAttackAnim()
	return self:GetAttackAnimTime() > 0 and CurTime() < self:GetAttackAnimTime()
end
function SWEP:IsInShield()
	return self:GetShieldTime() > 0 and CurTime() < self:GetShieldTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:StartSwinging()
		self.AttackMotion = math.random(39,44)
		if self:IsSwinging() then
			self:SetAttackAnimTime(CurTime() + self.Primary.Delay)
		end
end

function SWEP:Reload()
	if CurTime() < self:GetNextModeSwitch() or CurTime() < self:GetShieldTime() then return end
	self:SetNextModeSwitch(CurTime() + 4)
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end	
	self.DuringModeChange = true
	if self:GetNWInt("MovementMode", 0) == 1 then
		self:SetNWInt("MovementMode",0)
	elseif self:GetNWInt("MovementMode", 0) == 0 then
		self:SetNWInt("MovementMode",1)
	end

	self.Owner:EmitSound("zombiesurvival/zombine/zombine_charge"..math.random(2)..".wav",75,120)
	self.Owner:EmitSound("npc/combine_soldier/die"..math.random(3)..".wav",75,70)
	timer.Simple(1.3, 
	function() if self.Owner:IsValid() and self.Owner:Alive() and self:IsValid() then self.DuringModeChange = false end self:SetNextPrimaryFire(CurTime()) end)
end
function SWEP:SecondaryAttack()
	if self.DuringModeChange or self:GetNWInt("MovementMode", 0) == 1 then return end
	if CurTime() < self:GetNextSecondaryFire() then return end
	local owner = self.Owner
	self:SetNextSecondaryFire(CurTime() + 15)
	self.DuringShieldUp = true
	self.Owner:EmitSound("zombiesurvival/zombine/zombine_readygrenade2.wav",75,120)
	self.Owner:EmitSound("npc/combine_soldier/die"..math.random(3)..".wav",75,120)
	timer.Simple(2, 
	function() if self.Owner:IsValid() and self.Owner:Alive() and self:IsValid() then self.DuringShieldUp = false self:SetShieldTime(CurTime() + 5) end end)
end

function SWEP:PlayAlertSound()
	self.Owner:EmitSound("zombiesurvival/zombine/zombine_alert"..math.random(1,7)..".wav")
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("zombiesurvival/zombine/zombine_idle"..math.random(4)..".wav")
end
function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(2)..".wav",90, 90)
end
function SWEP:CanPrimaryAttack()
	if self.DuringModeChange or self:GetNWInt("MovementMode", 0) == 1 or self:GetShieldTime() > CurTime() then return false else return true end
end
function SWEP:ForceChangeMode()
	if self:GetNWInt("MovementMode", 0) == 1 then
		self:SetNextModeSwitch(CurTime() + 10)
		self:SetNWInt("MovementMode", 0)
		self.Owner:EmitSound("npc/combine_solder/die"..math.random(3)..".wav",75,150)
	end
end

function SWEP:SetNextModeSwitch(time)
	self:SetNWFloat("NextModeSwitch", time)
end

function SWEP:GetNextModeSwitch()
	return self:GetNWFloat("NextModeSwitch", CurTime())
end

if CLIENT then
function SWEP:DrawHUD()
	surface.SetFont("ZSHUDFontSmall")
	local text = self:GetNWInt("MovementMode", 0) == 1 and "추격중" or "공격중"
	local nTEXW, nTEXH = surface.GetTextSize(text)

	draw.SimpleTextBlurry(text, "ZSHUDFont", ScrW() - nTEXW * 0.5 - 48, ScrH() - nTEXH * 2 - 48, COLOR_BLUE, TEXT_ALIGN_CENTER)

	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/zombie_poison/poisonzombie_sheet")
local matSpawnEffect = Material("effects/combine_binocoverlay")
function SWEP:PreDrawViewModel(vm)
	if self:IsInShield() then
		render.ModelMaterialOverride(matSpawnEffect)
	else
		render.ModelMaterialOverride(matSheet)
	end
end
end