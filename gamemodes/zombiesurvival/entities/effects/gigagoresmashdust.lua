function EFFECT:Init(data)
	local pos = data:GetOrigin()

	sound.Play("physics/concrete/boulder_impact_hard" .. math.random(1, 4) .. ".wav", pos, 90, math.Rand(85, 95))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 45)
		for i=1, math.random(12, 20) do
			local heading = VectorRand():GetNormalized()
			local particle = emitter:Add("particle/smokestack", pos + heading * 16)
			particle:SetVelocity(heading * 144)
			particle:SetDieTime(math.Rand(0.7, 1.2))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(200)
			particle:SetStartSize(32)
			particle:SetEndSize(14)
			particle:SetColor(25, 20, 20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
		end
		for i=1, math.random(5, 8) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(144, 129))
			particle:SetDieTime(math.Rand(1.2, 2.6))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(200)
			particle:SetStartSize(8)
			particle:SetEndSize(100)
			particle:SetColor(12, 10, 10)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetAirResistance(10)
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
