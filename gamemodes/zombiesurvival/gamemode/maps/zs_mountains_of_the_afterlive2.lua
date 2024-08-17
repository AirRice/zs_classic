hook.Add("InitPostEntityMap", "Adding", function()
	for _, v in pairs(ents.FindInSphere(Vector(-161, -223, -321), 800)) do
		if (v:GetClass() == "func_movelinear") then
			v:Remove()
		end
	end
end)
