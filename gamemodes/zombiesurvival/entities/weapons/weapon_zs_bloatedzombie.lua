AddCSLuaFile()

util.PrecacheSound("weapons/bugbait/bugbait_squeeze1.wav")
util.PrecacheSound("weapons/bugbait/bugbait_squeeze2.wav")
util.PrecacheSound("weapons/bugbait/bugbait_squeeze3.wav")

if CLIENT then
	SWEP.PrintName = "부푼 좀비"
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

SWEP.MeleeDamage = 30
SWEP.MeleeForceScale = 1.25

SWEP.Primary.Delay = 1.75
SWEP.Secondary.Delay = 12
SWEP.ShootPower = 990
SWEP.ShootDelay = 1
SWEP.Radius = 215 // Def. 225
SWEP.PushVel = 375 // Def. 450
SWEP.MaxDmg = 1 // Def. 4
SWEP.NextSecondary = 0

function SWEP:Reload()
	self.BaseClass.SecondaryAttack(self)
end

function SWEP:PlayAlertSound()
	self:PlayAttackSound()
end

function SWEP:PlayIdleSound()
	self.Owner:EmitSound("npc/barnacle/barnacle_tongue_pull"..math.random(3)..".wav")
end

function SWEP:PlayAttackSound()
	self.Owner:EmitSound("npc/ichthyosaur/attack_growl"..math.random(3)..".wav", 70, math.Rand(145, 155))
end


function SWEP:SecondaryAttack()
	-- if !self:CanSecondaryAttack() then return end
	if (self.NextSecondary or 0) > CurTime() then
		return
	end
	
	local owner = self.Owner
	if !IsValid(owner) or !owner:IsPlayer() then
		return
	end
	self:EmitSound("weapons/bugbait/bugbait_squeeze" .. tostring(math.random(1, 3)) .. ".wav")
	if SERVER then 
		owner:SetWalkSpeed(owner:GetWalkSpeed() * 0.75)
		owner:SetDuckSpeed(owner:GetDuckSpeed() * 0.75)
		local ent = ents.Create("projectile_siegeball")
		ent:SetPos(owner:GetShootPos() + owner:GetAimVector() * 10)
		ent.ShootPower = self.ShootPower
		ent.Radius = self.Radius
		ent.ShootTime = CurTime() + self.ShootDelay
		ent.PushVel = self.PushVel
		ent.MaxDmg = self.MaxDmg
		ent:SetOwner(owner)
		ent:Spawn()
	end
	self.NextSecondary = CurTime() + self.Secondary.Delay
end

if not CLIENT then return end

function SWEP:DrawHUD()
	if GAMEMODE:GetWaveActive() then
	local scrW = ScrW()
	local scrH = ScrH()
	local width = 200
	local height = 20
	local x = scrW / 2 - width / 2
	local y = scrH - height / 2 - 100
	local ratio = math.max((self.NextSecondary - CurTime()) / self.Secondary.Delay,0)
	surface.SetDrawColor(Color(0, 0, 255, 80))
	if ratio >= 0.01 then
		surface.DrawOutlinedRect(x - 1, y - 1, width + 2, height + 2)
		draw.RoundedBox(0, x, y, width*ratio, height, Color(255, 0, 0, 80))
	end
	end

	if self.BaseClass.DrawHUD then
		self.BaseClass.DrawHUD(self)
	end
end

function SWEP:ViewModelDrawn()
	render.ModelMaterialOverride(0)
end

local matSheet = Material("models/weapons/v_zombiearms/ghoulsheet")
function SWEP:PreDrawViewModel(vm)
	render.ModelMaterialOverride(matSheet)
end
