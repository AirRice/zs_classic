AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'프렉티션' 의료소총"
	SWEP.Description = "메디컬 에너지를 사용해 지속적인 피해를 입히는 탄환을 발사한다.\n달리기 키를 누르고 있으면 피격 지점 주변 인간들을 치료하는 탄환을 발사한다."

	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 45
	SWEP.VElements = {
		["medvial"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Clip", rel = "", pos = Vector(0, 0.082, 1.297), angle = Angle(-116.181, -93.926, -4.924), size = Vector(0.99, 0.99, 0.99), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Stock"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0, -3.207, 6.977), angle = Angle(0, 90, 0), size = Vector(0.741, 0.552, 0.731), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Nozzle"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(0, 1.032, -3.503), angle = Angle(-180, -90, 0), size = Vector(0.221, 0.221, 0.221), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Nozzle+"] = { type = "Model", model = "models/healthvial.mdl", bone = "v_weapon.AK47_Bolt", rel = "", pos = Vector(-1.599, 1.032, -8.228), angle = Angle(89.334, 0, 0), size = Vector(0.549, 0.549, 0.372), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["GunBody"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(0.075, -2.062, -2.416), angle = Angle(-90, 0, -90), size = Vector(0.016, 0.019, 0.016), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+"] = { type = "Model", model = "models/props_pipes/pipecluster16d_001a.mdl", bone = "v_weapon.AK47_ClipRelease", rel = "", pos = Vector(-1.106, 0.326, -3.448), angle = Angle(88.875, 0, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe++"] = { type = "Model", model = "models/props_pipes/pipecluster16d_001a.mdl", bone = "v_weapon.AK47_Parent", rel = "", pos = Vector(1.787, -4.518, -6.603), angle = Angle(-35.552, -61.82, -89.033), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe"] = { type = "Model", model = "models/props_pipes/pipecluster16d_001a.mdl", bone = "v_weapon.AK47_ClipRelease", rel = "", pos = Vector(-1.106, 0.726, -1.866), angle = Angle(88.875, 0, 0), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["medvial"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(19.25, 1.802, -6.107), angle = Angle(-90, 90, -180), size = Vector(0.412, 0.412, 0.412), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Stock"] = { type = "Model", model = "models/props_combine/breenlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.787, 0.829, -1.714), angle = Angle(-77.25, -180, 0), size = Vector(0.741, 0.552, 0.731), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["Nozzle"] = { type = "Model", model = "models/props_pipes/valve002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.409, 0.717, -5.237), angle = Angle(-99.195, 0, 0), size = Vector(0.157, 0.157, 0.216), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["medvial+"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.27, 0.612, -4.487), angle = Angle(-32.586, 0, 0), size = Vector(1.12, 1.12, 1.12), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["GunBody"] = { type = "Model", model = "models/props_combine/combinetrain01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.612, 0.462, -2.099), angle = Angle(-11.101, 0, 180), size = Vector(0.019, 0.019, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe+"] = { type = "Model", model = "models/props_pipes/pipecluster16d_001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.585, 2.451, -1.999), angle = Angle(0, 0, 90), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe++"] = { type = "Model", model = "models/props_pipes/pipecluster16d_001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.114, 1.914, -1.56), angle = Angle(-16.452, 14.064, 87.228), size = Vector(0.028, 0.028, 0.028), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["pipe"] = { type = "Model", model = "models/props_pipes/pipecluster16d_001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.274, -0.724, -3.898), angle = Angle(39.147, -27.515, -69.176), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.HUD3DBone = "v_weapon.AK47_Parent"
	SWEP.HUD3DPos = Vector(-3, -4.5, -4)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("Weapon_AK47.Clipout")
SWEP.Primary.Sound = Sound("weapons/grenade_launcher1.wav", 70, math.random(90,120))
SWEP.Primary.Damage = 5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.14
SWEP.Primary.ClipSize = 30
SWEP.Primary.Ammo = "Battery"
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 0
SWEP.TracerName = "HelicopterTracer"
SWEP.ConeMax = 0.064
SWEP.ConeMin = 0.035
SWEP.NoAmmo = false
SWEP.Recoil = 0.26
SWEP.ToxicDamage = 2
SWEP.ToxicTick = 0.3
SWEP.ToxDuration = 3
SWEP.WalkSpeed = SPEED_SLOW

SWEP.ChargeRequiredClip = 30
SWEP.ChargeShotSound = "beams/beamstart5.wav"

SWEP.IronSightsPos = Vector(-3.6, 20, 3.1)

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self.IdleAnimation = CurTime() + self:SequenceDuration()

	if CLIENT then
		hook.Add("PostPlayerDraw", "PostPlayerDrawMedical", GAMEMODE.PostPlayerDrawMedical)
		GAMEMODE.MedicalAura = true
	end

	return true
end
function SWEP:Holster()
	if CLIENT then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end

	return true
end

function SWEP:OnRemove()
	if CLIENT and self.Owner == LocalPlayer() then
		hook.Remove("PostPlayerDraw", "PostPlayerDrawMedical")
		GAMEMODE.MedicalAura = false
	end
end
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self.Owner:KeyDown(IN_SPEED) then
		if self:Clip1() == self.ChargeRequiredClip then
		self:EmitSound(self.ChargeShotSound)
		self:SetClip1(0)
		self:ShootChargedBullet()
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay*5)
		else
		self:EmitSound("Weapon_Pistol.Empty")
		self:SetNextPrimaryFire(CurTime() + math.max(0.25, self.Primary.Delay))
		return false
		end
	else
		self:EmitFireSound()
		self:TakeAmmo()
		self:ShootBullets(self.Primary.Damage, self.Primary.NumShots, self:GetCone())
		self.IdleAnimation = CurTime() + self:SequenceDuration()
	end
end

function SWEP:ShootChargedBullet()
	if SERVER then
	self:SetConeAndFire()
	end
	self:DoRecoil()
	
	local owner = self.Owner
	--owner:MuzzleFlash()
	self:SendWeaponAnimation()
	owner:DoAttackEvent()
	self:StartBulletKnockback()
	owner:FireBullets({
		Num = 1, 
		Src = owner:GetShootPos(), 
		Dir = owner:GetAimVector(), 
		Spread = Vector(0.0001, 0.0001, 0), 
		Tracer = 1, 
		TracerName = self.TracerName, 
		Force = self.Primary.Damage * 0.1, 
		Damage = self.Primary.Damage  * 10, 
		Callback = self.SpecialBulletCallback
	})
	self:DoBulletKnockback(self.Primary.KnockbackScale * 0.05)
	self:EndBulletKnockback()
end

function SWEP:Reload()
	if self.Owner:IsHolding() then return end
	
	if self:GetIronsights() then
		self:SetIronsights(false)
	end
	
	if self:GetNextReload() <= CurTime() then
		self.NoAmmo = false
		self:SetClip1(0)
		if self:DefaultReload(ACT_VM_RELOAD) then
		self.IdleAnimation = CurTime() + self:SequenceDuration()
		self:SetNextReload(self.IdleAnimation)
		self.Owner:DoReloadEvent()
		if self.ReloadSound then
			self:EmitSound(self.ReloadSound)
		end
	end
	end
	self:ResetConeAdder()
end

function SWEP.SpecialBulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetMagnitude(5)
		if tr.Entity:IsValid() then
			effectdata:SetEntity(tr.Entity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect("gas", effectdata)
	if ent:IsPlayer() then 
		if ent:Team() == TEAM_ZOMBIE and ent:Health() <= 125 and SERVER then
			ent.Gibbed = CurTime()
			if gamemode.Call("PlayerShouldTakeDamage", ent, attacker) then
				INFDAMAGEFLOATER = true
				ent:SetHealth(1)
			end
		end
	else 
		local epicenter = tr.HitPos
		local radius =  75
		for _, ent in pairs(ents.FindInSphere(epicenter, radius)) do
			if ent and ent:IsValid() then
				if (ent:IsPlayer() and ent:Team() == TEAM_HUMANS) then
					local oldhealth = ent:Health()
					local newhealth = math.min(oldhealth + 10, ent:GetMaxHealth())
					if oldhealth ~= newhealth then
						ent:SetHealth(newhealth)
						ent:EmitSound("items/medshot4.wav")
						if  attacker:IsPlayer() and newhealth - oldhealth > 5 then
							gamemode.Call("PlayerHealedTeamMember",  attacker, ent, newhealth - oldhealth, attacker:GetWeapon("weapon_zs_practition"))
						end
					end
				end
			end
		end
	end
	GenericBulletCallback(attacker, tr, dmginfo)
end


function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if tr.HitSky then return end
	local effectdata = EffectData()
		effectdata:SetOrigin(tr.HitPos)
		effectdata:SetNormal(tr.HitNormal)
		effectdata:SetMagnitude(5)
		if tr.Entity:IsValid() then
			effectdata:SetEntity(tr.Entity)
		else
			effectdata:SetEntity(NULL)
		end
	util.Effect("hit_healdart", effectdata)
	if ent:IsPlayer() and ent:Team() == TEAM_ZOMBIE and SERVER then
				local wep = attacker:GetWeapon("weapon_zs_practition")
				if IsValid(wep) and attacker:IsValid() and attacker:IsPlayer() and ent:GetZombieClassTable().Name ~= "Shade" then
					local tox = ent:GiveStatus("tox")
					if tox and tox:IsValid() then
						tox:AddTime(wep.ToxDuration)
						tox.Damage = wep.ToxicDamage
						tox.Damager = attacker
						tox.TimeInterval = wep.ToxicTick
						tox.Owner = attacker
					end
				end
			end
	GenericBulletCallback(attacker, tr, dmginfo)
end
if not CLIENT then return end

function SWEP:DrawHUD()
	if LocalPlayer():KeyDown(IN_SPEED) and self:Clip1() == 30 then
		if LocalPlayer():KeyPressed(IN_SPEED)then
			surface.PlaySound("buttons/button9.wav")
		end
		surface.SetFont("ZSHUDFontSmall")
		local text = "MED SHOT 발사가능 상태"
		local nTEXW, nTEXH = surface.GetTextSize(text)

		draw.SimpleTextBlurry(text, "ZSHUDFontSmall", ScrW() - nTEXW * 0.5 - 24, ScrH() - nTEXH * 2, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
	else
	end
	if self.BaseClass.DrawHUD then
		self.BaseClass.DrawHUD(self)
	end
end