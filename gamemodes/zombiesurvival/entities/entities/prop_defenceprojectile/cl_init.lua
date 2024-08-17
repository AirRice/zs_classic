include("shared.lua")

ENT.Dinged = true

function ENT:Initialize()
	self:SetRenderBounds(Vector(-72, -72, -72), Vector(72, 72, 128))
end

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
end

local vOffset = Vector(16, 0, 0)
local vOffset2 = Vector(-16, 0, 0)
local aOffset = Angle(0, 90, 90)
local aOffset2 = Angle(0, 270, 90)
local vOffsetEE = Vector(-15, 0, 8)

function ENT:Think()
	local curTime = CurTime()

	local adder = 1
	local ang = self:GetAngles()
	local attacked = 0
	local proj = {}	
	if (self.LastAttack + self.AttackCooldown < curTime) then
		
		proj = {}
		
		attacked = 0
		
		for _, ent in pairs(ents.FindInSphere(self:LocalToWorld(self:OBBCenter()), self.SearchRadius)) do
			if (attacked >= self.AttackLimit) then
				break
			end
		
			if (ent == self or !string.find(ent:GetClass(), "projectile")) then
				continue
			end
			
			table.insert(proj, ent)
			
			attacked = attacked + 1
		end
	end
	
	if (attacked > 0) then
		adder = adder + table.Count(proj)
		self.LastAttack = curTime
	end
	
	self:SetAngles(Angle(ang.pitch, ang.yaw + adder, ang.roll))
	
	-- chat.AddText(tostring(adder))
	
	return true
end

function ENT:RenderInfo(pos, ang, owner)
	cam.Start3D2D(pos, ang, 0.075)

		local ratio = self:GetObjectHealth() / self:GetMaxObjectHealth()
	
		draw.RoundedBox(0, -150, -100, 300 * ratio, 25, Color(255 * (1 - ratio), 255 * (ratio), 0, 200))
		
		if owner:IsValid() and owner:IsPlayer() then
			draw.SimpleText("("..owner:ClippedName()..")", "ZS3D2DFont2Small", 0, 20, owner == MySelf and COLOR_BLUE or COLOR_GRAY, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end

	cam.End3D2D()
end

function ENT:Draw()
	self:DrawModel()

	if not MySelf:IsValid() then return end

	local owner = self:GetObjectOwner()
	local ang = self:LocalToWorldAngles(aOffset)

	self:RenderInfo(self:LocalToWorld(vOffset), ang, owner)
	-- self:RenderInfo(self:LocalToWorld(vOffset2), self:LocalToWorldAngles(aOffset2), owner)
end
