include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Died = false

local matTrail = Material("sprites/sent_ball")

function ENT:Think()
	-- if (self:GetDied()) then		
		-- local dieTime = CurTime() + 5
		-- local idx = dieTime
		-- local forward = self:GetAngles():Forward()
		-- local right = self:GetAngles():Right()
		-- local up = self:GetAngles():Up()
		-- local startpos = self:GetPos()
		
		-- local lines = {}
		-- for i = 1, 40 do
			-- table.insert(lines, startpos + forward * 150 + right * math.Rand(-1, 1) * 150 + up * math.Rand(-1, 1) * 150)
		-- end
		
		-- hook.Add("PreDrawTranslucentRenderables", "MINE" .. tostring(idx) .. "EFFECT", function(isDrawingDepth, isDrawSkybox)						
			-- render.SetMaterial(matTrail)
			
			-- local ratio = (dieTime - CurTime()) / 5
			
			-- for _, v in pairs(lines) do
				-- render.DrawBeam(startpos + VectorRand() * math.random(-2, 2), v, 16, 0, 5, Color(230, 40, 70, 255 * ratio))
			-- end
		-- end)
		
		-- timer.Create("MINE" .. tostring(idx) .. "EFFECTDIE", 5, 1, function()
			-- hook.Remove("PreDrawTranslucentRenderables", "MINE" .. tostring(idx) .. "EFFECT")
		-- end)
	-- end
end

-- function ENT:DrawTranslucent()
	-- if (MySelf:Team() == TEAM_HUMAN) then
		-- local startpos = self:GetPos()
		-- local ang = self:GetAngles()
		-- local rot = CurTime() * 32.5 % 150 - 75
		-- local rotUD = CurTime() * 75 % 150 - 75
		-- ang:RotateAroundAxis(ang:Up(), rot)
		-- ang:RotateAroundAxis(ang:Right(), rotUD)
		-- local forward = ang:Forward()
		-- local right = ang:Right()
		-- local up = ang:Up()
		-- render.SetMaterial(matTrail)
		-- render.DrawQuadEasy(startpos + Vector(0, 0, 1), Vector(0, 0, 1), 16, 16, Color(0, 250, 0, 180), CurTime() * 50 % 360)
	-- end
	-- self:Draw()
-- end