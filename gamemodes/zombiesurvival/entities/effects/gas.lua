function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local ent = data:GetEntity()

	if ent and ent:IsValid() then
		ent:EmitSound("ambient/machines/steam_release_2.wav", 70, 255)
	else
		sound.Play("ambient/machines/steam_release_2.wav", pos, 70, 255)
	end

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(16, 24)

	for i=1, 5 do

		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(8), pos)
		particle:SetVelocity(norm * 32 + VectorRand() * 16)
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetDieTime(math.Rand(0.75, 1.25))
		particle:SetStartAlpha(135)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(13, 14))
		particle:SetEndSize(math.Rand(10, 12))
		particle:SetColor(255, 255, 10)
		particle:SetRoll(math.Rand(180, 360))
		particle:SetRollDelta(math.Rand(-4, 4))
		particle:SetGravity(Vector(0, 0, -10))
		particle:SetAirResistance(100)

		particle:SetLighting(true)
	end

	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end