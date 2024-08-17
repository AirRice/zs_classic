hook.Add("InitPostEntityMap", "DoorHealth", function()
	for _, ent in pairs(ents.FindByClass("func_door_rotating")) do 
		if not ent.Heal then
			local br = ent:BoundingRadius()
			local health = br * 25
			ent.Heal = health
			ent.TotalHeal = health
		end
	end
end)
