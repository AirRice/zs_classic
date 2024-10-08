AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "'비르벨빈트' 휴대용 국지방어기"
	SWEP.Description = "탄약을 사용해 주변의 투사체를 요격하는 총기이다."

	SWEP.HUD3DBone = "ValveBiped.base"
	SWEP.HUD3DPos = Vector(3, 0.25, -2)
	SWEP.HUD3DScale = 0.02
	
	SWEP.ViewModelFOV = 60
	SWEP.Slot = 4
	SWEP.ViewModelFlip = false

	SWEP.VElements = {
		["monitor"] = { type = "Model", model = "models/props_combine/combine_intmonitor001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(2.046, 1.325, 7.032), angle = Angle(0, 0, -90), size = Vector(0.059, 0.144, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backpanel"] = { type = "Model", model = "models/props_combine/combine_interface002.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(0, 1.919, 0.23), angle = Angle(-42.225, -90, 180), size = Vector(0.054, 0.029, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["core"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.base", rel = "", pos = Vector(0, 0, -6.711), angle = Angle(0, 0, 0), size = Vector(0.108, 0.128, 0.275), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lightsight"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(0, -1.915, -2.839), angle = Angle(0, -90, 0), size = Vector(0.156, 0.221, 0.314), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["radar"] = { type = "Model", model = "models/props_rooftop/roof_dish001.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(-0.258, -1.035, 0.224), angle = Angle(-84.481, 55.051, -94.617), size = Vector(0.046, 0.046, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun1"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(-1.372, 0.824, 14.314), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun2"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(-1.372, -0.825, 14.314), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun3"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(1.371, -0.825, 14.314), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun4"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "core", pos = Vector(1.371, 0.824, 14.314), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.018), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
	SWEP.WElements = {
		["monitor"] = { type = "Model", model = "models/props_combine/combine_intmonitor001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(2.046, 1.325, 5.361), angle = Angle(0, 0, -90), size = Vector(0.059, 0.104, 0.054), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["backpanel"] = { type = "Model", model = "models/props_combine/combine_interface002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(0, 1.919, 0.23), angle = Angle(-42.225, -90, 180), size = Vector(0.054, 0.029, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["core"] = { type = "Model", model = "models/props_c17/canister_propane01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.172, 1.524, -4.211), angle = Angle(0, -89.995, -102.33), size = Vector(0.108, 0.128, 0.256), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["lightsight"] = { type = "Model", model = "models/props_combine/combine_light002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(0, -1.915, -2.839), angle = Angle(0, -90, 0), size = Vector(0.156, 0.221, 0.314), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun1"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(-1.453, 0.985, 12.852), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun2"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(-1.453, -0.986, 12.852), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun3"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(1.452, 0.985, 12.852), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["gun4"] = { type = "Model", model = "models/props_c17/column02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(1.452, -0.986, 12.852), angle = Angle(0, 0, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["radar"] = { type = "Model", model = "models/props_rooftop/roof_dish001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "core", pos = Vector(-0.258, -1.035, 0.224), angle = Angle(-84.481, 55.051, -94.617), size = Vector(0.046, 0.046, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.UseHands = true
SWEP.ReloadSound = Sound("Weapon_Alyx_Gun.Reload")
SWEP.Primary.Sound = Sound("weapons/smg1/smg1_fire1.wav")
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.12

SWEP.Primary.ClipSize = 30
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ConeMax = 0.0302
SWEP.ConeMin = 0.0011

SWEP.Recoil = 0.28

SWEP.WalkSpeed = SPEED_SLOW
SWEP.LastAttack = 0
SWEP.Shootingdown = false
SWEP.SearchRadius = 160
function SWEP:SecondaryAttack()
end

function SWEP:Attack(proj)
	if (proj:GetClass() == "projectile_healdart" or (proj:GetOwner():IsPlayer() and self.Owner:IsPlayer() and proj:GetOwner():Team() == self.Owner:Team())) then
		return
	end
	if (!proj.Twister or proj.Twister == nil or !IsValid(proj.Twister) or proj.Twister == self) and proj:IsValid() then
		local phys = proj:GetPhysicsObject()
		self.Owner:EmitSound("weapons/ar1/ar1_dist"..math.random(2)..".wav")
		self:TakeAmmo()
	
		local owner = self.Owner
		--owner:MuzzleFlash()
		self:SendWeaponAnimation()
		owner:DoAttackEvent()
		proj.Twister = self
		local projcenter = proj:GetPos()
		local fireorigin = self.Owner:GetShootPos()
		local firevec = ( projcenter - fireorigin ):GetNormalized()
		self.Owner:FireBullets({Num = 1, Src = fireorigin, Dir = firevec, Spread = Vector(0, 0, 0), Tracer = 1, TracerName = "AR2Tracer", Force = self.Primary.Damage * 0.1, Damage = 1, Callback = 	self.BulletCallback})
		local ed = EffectData()
			ed:SetOrigin(proj:GetPos())
			ed:SetNormal(firevec)
		util.Effect("sweeperexpl", ed)

		self.IdleAnimation = CurTime() + self:SequenceDuration()
		if SERVER then
			proj:Remove()
		end
	end
end

function SWEP:Think()
	local curTime = CurTime()

	if (self.LastAttack + self.Primary.Delay*0.25 < curTime ) and self:Clip1() > 0 then --and self.Owner:KeyDown(IN_ATTACK2) 
		local center = self.Owner:GetShootPos()
		local projs = {}
		
		local attacked = 0
		
		local td = {}
		
		for _, ent in pairs(ents.FindInSphere(center, self.SearchRadius)) do
			local dot = (ent:GetPos() - center):GetNormalized():Dot(self.Owner:GetAimVector())
			if dot >= 0.55 and (TrueVisibleFilters(center, ent:GetPos(), self, ent, self.Owner)) then
				if (ent == self or !string.find(ent:GetClass(), "projectile")) then
					continue
				else					
					self:Attack(ent)
					self.LastAttack = curTime
					self:SetNextPrimaryFire(CurTime() + self.Primary.Delay*0.25)
					break
				end
			end
		end
	end
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end
	
	self:DevineConeAdder()
end
