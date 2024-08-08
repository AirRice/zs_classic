AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "마이너"
	SWEP.Description = "보조 공격으로 샷건 탄창 8개를 소모해 전방의 좀비를 감지하면 자동으로 폭발하는 클레이모어를 설치한다."

	SWEP.ViewModelFOV = 65.527638190955

	SWEP.ShowViewModel = false
	SWEP.ShowWorldModel = false

	SWEP.VElements = {
		["battery++++++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -13.514), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shovel"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.017, 1.843, -14.693), angle = Angle(2.898, -128.706, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 242, 219, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+++++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -13.514), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery++++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -14.938), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -20.585), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -17.741), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shovel+"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.017, 1.843, -14.693), angle = Angle(2.898, -128.706, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 242, 219, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -19.222), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.664, 4.765, -16.291), angle = Angle(0, 39.817, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["battery"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.196, 2.039, -17.317), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["shovel"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.372, 1.197, -9.568), angle = Angle(0, 0, 0), size = Vector(0.632, 0.632, 0.632), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.196, 2.039, -13.53), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+++++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.196, 2.039, -8.353), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery++++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.196, 2.039, -10.256), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.196, 2.039, -15.49), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+++"] = { type = "Model", model = "models/mine/floodlight.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.196, 2.039, -12.108), angle = Angle(0, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.HoldType = "melee2"

SWEP.DamageType = DMG_CLUB

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/props_junk/shovel01a.mdl"
SWEP.UseHands = true

SWEP.MeleeDamage = 50
SWEP.MeleeRange = 68
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 40

SWEP.Primary.Delay = 1.2

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.SwingRotation = Angle(0, -90, -60)
SWEP.SwingOffset = Vector(0, 30, -40)
SWEP.SwingTime = 0.65
SWEP.SwingHoldType = "melee"

SWEP.MineDelay = 3

function SWEP:Deploy()
	gamemode.Call("WeaponDeployed", self.Owner, self)

	self:SpawnGhost()

	return true
end

function SWEP:OnRemove()
	self:RemoveGhost()
end

function SWEP:Holster()
	self:RemoveGhost()
	return true
end

function SWEP:SpawnGhost()
	local owner = self.Owner
	if owner and owner:IsValid() then
		owner:GiveStatus("ghost_mine")
	end
end

function SWEP:RemoveGhost()
	local owner = self.Owner
	if owner and owner:IsValid() then
		owner:RemoveStatus("ghost_mine", false, true)
	end
end

if CLIENT then
	function SWEP:Think()
		if self.Owner:KeyDown(IN_ATTACK2) then
			self:RotateGhost(FrameTime() * 60)
		end
		if self.Owner:KeyDown(IN_RELOAD) then
			self:RotateGhost(FrameTime() * -60)
		end
		
		self.BaseClass.Think(self)
	end
	
	local nextclick = 0
	function SWEP:RotateGhost(amount)
		if nextclick <= RealTime() then
			surface.PlaySound("npc/headcrab_poison/ph_step4.wav")
			nextclick = RealTime() + 0.3
		end
		RunConsoleCommand("_zs_ghostrotation", math.NormalizeAngle(GetConVarNumber("_zs_ghostrotation") + amount))
	end
end

if SERVER then
	function SWEP:Think()
		local owner = self.Owner
		if (owner:KeyDown(IN_USE) and self:GetNextSecondaryFire() < CurTime()) then
			if (!IsValid(owner)) then
				return
			end
		
			local status = owner.status_ghost_mine
			if not (status and status:IsValid()) then return end
			status:RecalculateValidity()
			if not status:GetValidPlacement() then return end

			local pos, ang = status:RecalculateValidity()
			if not pos or not ang then return end
			
			local remainClips = owner:GetAmmoCount("buckshot")
			
			if (remainClips >= 16) then
				local tr = owner:TraceLine(self.MeleeRange * 1.2, MASK_SHOT, {owner, self, team.GetPlayers(owner:Team())})
				
				if (tr.HitWorld) then
					if SERVER then
						local mine = ents.Create("prop_mine")
						mine:SetOwner(self.Owner)
						mine:SetPos(pos)
						mine:SetAngles(ang)
						
						mine:Spawn()
					end
					owner:EmitSound("weapons/melee/miner/miner_success.wav")
					owner:RemoveAmmo(16, "buckshot")
					self:SetNextSecondaryFire(CurTime() + self.MineDelay)
				else
					owner:EmitSound("weapons/melee/miner/miner_empty.wav")
					self:SetNextSecondaryFire(CurTime() + self.MineDelay / 3)
				end
			else
				owner:EmitSound("weapons/melee/miner/miner_empty.wav")
				self:SetNextSecondaryFire(CurTime())
			end
		end
		self.BaseClass.Think(self)
	end
end

function SWEP:PlaySwingSound()
	self:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random(65, 70))
end

function SWEP:PlayHitSound()
	self:EmitSound("weapons/melee/shovel/shovel_hit-0"..math.random(4)..".ogg")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end

function SWEP:OnMeleeHit(hitent, hitflesh, tr)
	if hitent:IsValid() and hitent:IsPlayer() and hitent.Revive and hitent.Revive:IsValid() and gamemode.Call("PlayerShouldTakeDamage", hitent, self.Owner) then
		hitent:SetHealth(1)
	end
end