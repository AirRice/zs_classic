EFFECT.LifeTime = 1
EFFECT.Size = 8

function EFFECT:Init(data)
	self.DieTime = CurTime() + self.LifeTime

	local normal = data:GetNormal()
	local pos = data:GetOrigin()

	pos = pos + normal * 2
	self.Pos = pos
	self.Normal = normal
	
	self.Ent = data:GetEntity()
	
	if (IsValid(self.Ent)) then
		self.EntPos = self.Ent:GetPos()
	end
	
	local snd = Sound("npc/scanner/scanner_electric" .. (math.random() > 0.8 and "2" or "1") .. ".wav")
	sound.Play(snd, pos, 80, math.Rand(85, 95))
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matRefraction	= Material("refract_ring")
local matGlow = Material("effects/rollerglow")
local colGlow = Color(255, 30, 255)
function EFFECT:Render()
	local delta = math.Clamp((self.DieTime - CurTime()) / self.LifeTime, 0, 1)
	local rdelta = 1 - delta
	local size = rdelta ^ 0.5 * self.Size
	colGlow.a = delta * 220
	colGlow.r = delta * 255
	colGlow.b = colGlow.r - 255

	render.SetMaterial(matGlow)
	render.DrawQuadEasy(self.Pos, self.Normal, size, size, colGlow, 0)
	render.DrawQuadEasy(self.Pos, self.Normal * -1, size, size, colGlow, 0)
	render.DrawSprite(self.Pos, size, size, colGlow)
	matRefraction:SetFloat("$refractamount", math.sin(delta * 2 * math.pi) * 0.2)
	render.SetMaterial(matRefraction)
	render.UpdateRefractTexture()
	render.DrawQuadEasy(self.Pos, self.Normal, size, size, color_white, 0)
	render.DrawQuadEasy(self.Pos, self.Normal * -1, size, size, color_white, 0)
	render.DrawSprite(self.Pos, size, size, color_white)
	
	local cnt = math.random(16, 32)
	local entpos = self.EntPos
	if (entpos) then
		-- render.DrawBeam(entpos, self.Pos, 5, 0, 5, Color(255, 0, 0, 255))
	end
end
