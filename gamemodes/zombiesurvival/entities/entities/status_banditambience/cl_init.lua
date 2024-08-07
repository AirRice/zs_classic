include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.NextEmit = 0

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

	self.AmbientSound = CreateSound(self, "ambient/levels/citadel/citadel_ambient_scream_loop1.wav")
	self.AmbientSound:PlayEx(0.47, 100)
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.47, 100 + math.sin(RealTime()))
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(255, 0, 0, 255)
function ENT:DrawTranslucent()
	local owner = self:GetOwner()
	if owner:IsValid() and (owner ~= LocalPlayer() or owner:ShouldDrawLocalPlayer()) then
		local pos = owner:LocalToWorld(owner:OBBCenter())
		render.SetMaterial(matGlow)
		render.DrawSprite(pos, math.Rand(72, 84), math.Rand(80, 90), colGlow)

		if self.NextEmit <= CurTime() then
			self.NextEmit = CurTime() + 0.5

			local emitter = ParticleEmitter(pos)
			emitter:SetNearClip(32, 48)

			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(owner:GetVelocity() * 0.8)
			particle:SetDieTime(math.Rand(1, 1.35))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(50, 64))
			particle:SetEndSize(45)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-3, 3))
			particle:SetGravity(Vector(0, 0, 125))
			particle:SetCollide(true)
			particle:SetBounce(0.45)
			particle:SetAirResistance(12)
			particle:SetColor(200, 0, 0)

			emitter:Finish()
		end
	end
end
