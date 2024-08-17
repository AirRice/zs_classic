
local lastThink = CurTime()
hook.Add("Think", "zs_mystery_tp", function()
	if (lastThink + 0.2 < CurTime()) then
		local ed = EffectData()
		
		local mins = Vector(-16, -16, 0)

		local maxs = Vector(16, 16, 72)

		local source = Vector(3046.372314, 1737.953369, -719.185852)
		
		local dest = Vector(2006.031250, 3699.991211, -335.968750)
		
		ed:SetOrigin(source)
		ed:SetMagnitude(1)
		util.Effect("nailrepaired", ed)

		ed:SetOrigin(dest)
		ed:SetMagnitude(0)
		util.Effect("nailrepaired", ed)
		
		for i, v in pairs(ents.FindInBox(source + mins, source + maxs)) do
			if (v:IsPlayer()) then
				-- print(v)
				v:SetPos(dest)
			end
		end
		
		source = Vector(3142, 3700, -319)
		
		dest = Vector(1818.030396, 1999.991211, -335.968750)
	
		ed:SetOrigin(source)
		ed:SetMagnitude(1)
		util.Effect("nailrepaired", ed)
	
		ed:SetOrigin(dest)
		ed:SetMagnitude(0)
		util.Effect("nailrepaired", ed)
		
		for i, v in pairs(ents.FindInBox(source + mins, source + maxs)) do
			if (v:IsPlayer()) then
				v:SetPos(dest)
			end
		end
		
		source = Vector(3041, 2589, -619)
		
		dest = Vector(3087, 2007, -291)
		
		ed:SetOrigin(source)
		ed:SetMagnitude(1)
		util.Effect("nailrepaired", ed)

		ed:SetOrigin(dest)
		ed:SetMagnitude(0)
		util.Effect("nailrepaired", ed)
		
		for i, v in pairs(ents.FindInBox(source + mins, source + maxs)) do
			if (v:IsPlayer()) then
				v:SetPos(dest)
			end
		end
		
		source = Vector(3139.461182, 1624.031250, -383.968750)
		
		dest = Vector(2502.000977, 2056.031250, -350.356720)
		
		ed:SetOrigin(source)
		ed:SetMagnitude(1)
		util.Effect("nailrepaired", ed)

		ed:SetOrigin(dest)
		ed:SetMagnitude(0)
		util.Effect("nailrepaired", ed)
		
		for i, v in pairs(ents.FindInBox(source + mins, source + maxs)) do
			if (v:IsPlayer()) then
				v:SetPos(dest)
			end
		end
		
		lastThink = CurTime()
	end
end)