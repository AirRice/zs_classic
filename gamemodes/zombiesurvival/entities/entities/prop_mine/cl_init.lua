include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Died = false
ENT.LightMode = 0
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
	local expltime = self:GetStartExplosion()
	
	if (expltime > 0) then
		self:PlaySound(expltime)
	end
end

local lastSound = 0
function ENT:PlaySound(expltime)
	if (lastSound + 0.1 <= CurTime()) then
		local pitch = math.Clamp((CurTime() - expltime) / self.ExplodeTimeout * 100, 50, 255)

		self:EmitSound("weapons/c4/c4_click.wav", 100, pitch, 1, CHAN_AUTO)
		lastSound = CurTime()
	end
end

local matLight = Material( "sprites/light_ignorez" )
function ENT:DrawTranslucent()
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
	self:Draw()
	
	if (!self:GetActive()) then
		return
	end
	
	local curtime = CurTime()
	
	local time = curtime * 60 % 60
	
	local pos = self:GetPos() + self:GetAngles():Forward() * 3.9 + self:GetAngles():Up() * - 2
	
	local ang = self:GetAngles() - Angle(-45, 10, 0)
	
	cam.Start3D2D(pos, ang, 1)
		render.SetColorMaterial()
		if (time > 30) then
			col = Color(255, 0, 0)
		else
			col = Color(0, 255, 0)
		end
		
		render.DrawSphere(Vector(0, 0, 0), 0.5, 50, 50, col)
		
		render.SetMaterial(matLight)
		if (time > 30) then
			col = Color(255, 0, 0)
		else
			col = Color(0, 255, 0)
		end
		
		render.DrawSprite(Vector(0, 0, 0), 50, 50, col)
	cam.End3D2D()
end