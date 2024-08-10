
function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	-- local mag = data:GetMagnitude()
	-- local ent = data:GetEntity()
	-- local scale = math.Round(data:GetScale())
	
	local e = ParticleEmitter(pos)
	
	for i = 1, 12 do
		local p = e:Add("effects/spark_noz", pos)
		p:SetDieTime(math.Rand(0.2, 0.4))
		p:SetStartAlpha(180)
		p:SetEndAlpha(0)
		p:SetStartSize(math.Rand(0, 1))
		p:SetEndSize(math.Rand(1, 1.2))
		p:SetRoll(math.Rand(-180, 180))
		p:SetColor(math.random(200, 255), math.random(200, 255), 0)
		p:SetVelocity(math.Rand(50, 100) * norm * Vector(math.Rand(-0.1, 0.1), math.Rand(-0.1, 0.1), math.Rand(-0.1, 0.1)))
		-- p:SetLighting(true)
		
	end
		EmitSound("zombiesurvival/weapons/sweeperexplosion.wav", pos, 1, CHAN_WEAPON, 1, 100, 0, math.random(180, 250))
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

util.PrecacheSound("zombiesurvival/weapons/sweeperexplosion.wav")