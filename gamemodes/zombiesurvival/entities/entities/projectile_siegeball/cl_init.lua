include("shared.lua")

local matTrail = Material("trails/laser.vmt")
local colTrail = Color(0, 255, 0, 80)

function ENT:Draw()
	self.Entity:DrawModel()

	local vOffset = self.Entity:GetPos()

	-- render.SetMaterial(matTrail)
	-- for i=1, #self.TrailPositions do
		-- if self.TrailPositions[i+1] then
			-- render.DrawBeam(self.TrailPositions[i], self.TrailPositions[i+1], 6, 1, 0, colTrail)
		-- end
	-- end
end

function ENT:Initialize()
	self.Trailing = CurTime() + 100
	self.TrailPositions = {}
end

function ENT:Think()
	if self.Entity:GetVelocity():Length() <= 0 and self.Trailing < CurTime() then
		function self:Draw() self.Entity:DrawModel() end
		function self:Think() end
	else
		-- table.insert(self.TrailPositions, 1, self.Entity:GetPos())
		-- if self.TrailPositions[128] then
			-- table.remove(self.TrailPositions, 128)
		-- end
		-- local dist = 0
		-- local mypos = self.Entity:GetPos()
		-- for i=1, #self.TrailPositions do
			-- if self.TrailPositions[i]:Distance(mypos) > dist then
				-- self.Entity:SetRenderBoundsWS(self.TrailPositions[i], mypos, Vector(16, 16, 16))
				-- dist = self.TrailPositions[i]:Distance(mypos)
			-- end
		-- end
		
		local ct = CurTime()
		local pos = self:GetPos()
		local dir = self:GetVelocity():GetNormal()
		hook.Add("PreDrawTranslucentRenderables", "SIEGEBALL_" .. tostring(ct), function(isDepth, isSkybox)
			render.SetMaterial(matTrail)
			
			local ratio = (1 - (CurTime() - ct) / 1)
			
			render.DrawBeam(pos, pos + dir * 10, 150 * ratio, 0, 5, Color(255, 0, 0, 255 * ratio))
			
			if (ct + 1 <= CurTime()) then
				hook.Remove("PreDrawTranslucentRenderables", "SIEGEBALL_" .. tostring(ct))
			end
		end)
	end
end

function ENT:OnRemove()
end
