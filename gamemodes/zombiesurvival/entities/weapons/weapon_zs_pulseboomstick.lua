AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'오버차지' 펄스 방출기"
	SWEP.Description = "주 공격 버튼을 눌러 최대 20개까지의 펄스 배터리를 저장한 후 방출할 수 있다."
	SWEP.Slot = 3
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "Base"
	SWEP.HUD3DPos = Vector(7.791, -2.597, -7.792)
	SWEP.HUD3DScale = 0.04
	SWEP.ViewModelFOV = 60
	SWEP.ViewModelFlip = false
	SWEP.VElements = {
		["Body+"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "Base", rel = "", pos = Vector(0, 1.552, 0.061), angle = Angle(-90, 0, -90), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Handle"] = { type = "Model", model = "models/weapons/w_stunbaton.mdl", bone = "Base", rel = "", pos = Vector(6.916, 3.855, -6.791), angle = Angle(0, -7.356, 0), size = Vector(0.559, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Hose"] = { type = "Model", model = "models/props_pipes/pipe01_lcurve01_long.mdl", bone = "Base", rel = "", pos = Vector(1.608, 6.772, -18.417), angle = Angle(151.322, 94.557, -91.644), size = Vector(0.731, 0.731, 0.731), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Monitor"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "Base", rel = "", pos = Vector(-5.292, 4.018, -5.196), angle = Angle(-180, 0, -90), size = Vector(0.194, 0.194, 0.112), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Body"] = { type = "Model", model = "models/props_lab/incubatorplug.mdl", bone = "Base", rel = "", pos = Vector(0, 1.552, 10.987), angle = Angle(-90, 0, 180), size = Vector(0.3, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Nozzle"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "Base", rel = "", pos = Vector(-0.08, 1.621, 13.421), angle = Angle(0, -16.151, 90), size = Vector(1.925, 1.925, 1.925), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["Body+"] = { type = "Model", model = "models/props_wasteland/laundry_washer003.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Body", pos = Vector(10.072, -0.39, -0.39), angle = Angle(0, 0, -90), size = Vector(0.15, 0.15, 0.15), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Hose"] = { type = "Model", model = "models/props_pipes/pipe01_lcurve01_long.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Body+", pos = Vector(9.923, 5.432, -0.174), angle = Angle(-71.009, 62.321, 0), size = Vector(0.731, 0.731, 0.731), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Nozzle"] = { type = "Model", model = "models/props_lab/rotato.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.172, -1.989, -5.038), angle = Angle(-0.297, 100.821, 4.447), size = Vector(1.925, 1.925, 1.925), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Monitor"] = { type = "Model", model = "models/props_combine/breenconsole.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Body+", pos = Vector(-1.392, -4.771, -1.816), angle = Angle(0, 90, 0), size = Vector(0.135, 0.125, 0.081), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Body"] = { type = "Model", model = "models/props_lab/incubatorplug.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(15.807, -1.431, -4.975), angle = Angle(176.563, 9.548, 76.704), size = Vector(0.3, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Handle"] = { type = "Model", model = "models/weapons/w_stunbaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "Body+", pos = Vector(-0.438, -1.186, 2.081), angle = Angle(125.697, -87.166, 8.175), size = Vector(0.531, 0.531, 0.531), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_pulseboom.Single",
	channel = CHAN_WEAPON,
	volume = 1.0,
	soundlevel = 100,
	sound = "weapons/gauss/fire1.wav"
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physics.mdl"
SWEP.UseHands = true
SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.CSMuzzleFlashes = false

SWEP.ReloadDelay = 0.15

SWEP.ReloadSound = Sound("weapons/ar2/ar2_reload_push.wav")
SWEP.Primary.Sound = Sound("Weapon_pulseboom.Single")
SWEP.Recoil = 3.5
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 1

SWEP.Primary.ClipSize = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
SWEP.Primary.DefaultClip = 40
SWEP.PreHolsterClip1 = 0

SWEP.ConeMax = 0.12
SWEP.ConeMin = 0.005

SWEP.ChargeSound = "items/suitchargeok1.wav"
SWEP.LastCharge = 0
SWEP.WalkSpeed = SPEED_SLOWEST
SWEP.TracerName = "AirboatGunHeavyTracer"

function SWEP:SetIronsights()
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 5, "IsCharging")
	if self.BaseClass.SetupDataTables then
		self.BaseClass.SetupDataTables(self)
	end
end

function SWEP:Deploy()
	self:SetIsCharging(false)
	return self.BaseClass.Deploy(self)
end

function SWEP:CanPrimaryAttack()

	local owner = self:GetOwner()
	if owner:IsHolding() or owner:GetBarricadeGhosting() then return false end

	if owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() or self:GetIsCharging() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:GetIsCharging() then
		self:SetIsCharging(true)
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
		ent:AddLegDamage(6)
	end

	if tr.HitWorld and not tr.HitSky then
		local e = EffectData()
			e:SetOrigin(tr.HitPos)
			e:SetNormal(tr.HitNormal)
			e:SetRadius(3)
			e:SetMagnitude(1)
			e:SetScale(1)
		util.Effect("cball_bounce", e)
		
	end

	GenericBulletCallback(attacker, tr, dmginfo)
end


function SWEP:Reload()
end


function SWEP:Think()
	local owner = self:GetOwner()
	if self:GetIsCharging() then
		if owner:KeyReleased(IN_ATTACK) or owner:GetBarricadeGhosting() then
			local nextshotdelay = 0.25
			if self:GetChargePerc() > 0 and not owner:GetBarricadeGhosting() then
				local shots = math.Clamp(self:Clip1(), 0, self.Primary.ClipSize)
				self:TakePrimaryAmmo(shots)
				self:EmitFireSound()
				self:ShootBullets(self.Primary.Damage, shots, self:GetCone())
				nextshotdelay = self.Primary.Delay
			end
			self:SetIsCharging(false)
			self.IdleAnimation = CurTime() + self:SequenceDuration()
			self:SetNextPrimaryFire(CurTime() + nextshotdelay)
		elseif self:GetChargePerc() < 1 and owner:KeyDown(IN_ATTACK) then
			if self.LastCharge <= CurTime() and owner:GetAmmoCount(self.Primary.Ammo) >= 1 then
				self:SetClip1(math.Clamp(self:Clip1() + 1, 0, self.Primary.ClipSize))
				owner:RemoveAmmo(1, self.Primary.Ammo, false)
				self:EmitSound(self.ChargeSound, 65, 70+30*self:GetChargePerc(), 1, CHAN_WEAPON)
				self.LastCharge = CurTime() + 0.09
			end	
		end
	end
	self.BaseClass.Think(self)
end

function SWEP:GetChargePerc()
	return math.Clamp(self:Clip1() / self.Primary.ClipSize, 0, 1)
end

if CLIENT then

	function SWEP:TranslateFOV(fov)
		return GAMEMODE.FOVLerp * fov * (1-0.03*math.Clamp(self:GetChargePerc(), 0, 1))
	end
	
	function SWEP:CalcViewModelView(vm, oldpos, oldang, pos, ang)
		pos, ang = self.BaseClass.CalcViewModelView(self, vm, oldpos, oldang, pos, ang)
		return pos+VectorRand(-0.1,0.1)*math.Clamp(self:GetChargePerc(), 0, 1),ang
	end
end
