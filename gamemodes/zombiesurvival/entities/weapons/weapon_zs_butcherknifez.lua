AddCSLuaFile()

SWEP.Base = "weapon_zs_butcherknife"

SWEP.ZombieOnly = true
SWEP.MeleeDamage = 30
SWEP.Primary.Delay = 0.4
SWEP.AttackStack = 0
SWEP.LastAttackHuman = 0
SWEP.BarricadeDamage = 0

function SWEP:Initialize()
	if (self.BaseClass.Initialize) then
		self.BaseClass.Initialize(self)
	end
	
	self.LastAttackHuman = CurTime()
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
	if (IsValid(hitent)) then
		local diff = CurTime() - self.LastAttackHuman
		
		diff = math.floor(diff)
		
		if (hitent:IsPlayer() and hitent:Team() == TEAM_HUMAN) then
			local dmg = self.MeleeDamage
			
			for i = 1, diff do 
				dmg = dmg * 1.02
			end	
			
			if (IsValid(self.Owner)) and SERVER then
				hitent:TakeDamage(dmg, self.Owner, self)
			end
			
			self.LastAttackHuman = CurTime()
		end
		
		if (hitent:IsNailed()) then
			local dmg = self.MeleeDamage * (1 + 0.02 * diff)
			
			if IsValid(self.Owner) and SERVER then
				hitent:TakeDamage(dmg, self.Owner, self)
			end
			
			self.BarricadeDamage = self.BarricadeDamage + dmg
			
			if (self.BarricadeDamage > 1000) then
				self.LastAttackHuman = CurTime()
				self.BarricadeDamage = 0
			end
		end
	end
end

if not CLIENT then return end 

function SWEP:DrawHUD()
	local diff = CurTime() - self.LastAttackHuman
	mult = 1.02^diff
	local text = "살육 충동에 의한 대미지:"..math.floor(100*mult).."%"
	draw.SimpleTextBlurry(text, "ZSHUDFontSmall", ScrW() - 320, ScrH() - 60, COLOR_RED, TEXT_ALIGN_CENTER)
	if GetConVarNumber("crosshair") ~= 1 then return end
	self:DrawCrosshairDot()
end
