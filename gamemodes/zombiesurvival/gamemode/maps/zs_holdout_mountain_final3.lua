hook.Add("InitPostEntityMap", "Adding", function()
	for _,v in pairs(ents.FindByClass("func_door")) do
		v:Remove()
	end
end)
