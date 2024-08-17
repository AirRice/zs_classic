local lastThink = CurTime()
hook.Add("Think", "zs_abstraction_exit", function()
	if (lastThink + 0.2 < CurTime()) then
		local ed = EffectData()
		
		local mins = Vector(-16, -16, 0)

		local maxs = Vector(16, 16, 72)

		local source = Vector(6511.968750, -239.968750, 0.031250)
		
		local dest = Vector(1220.333984, -663.211792, 512.031250)
		
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
		
		lastThink = CurTime()
	end
end)