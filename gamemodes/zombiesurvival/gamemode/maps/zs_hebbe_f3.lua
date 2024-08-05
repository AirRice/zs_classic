hook.Add("InitPostEntityMap", "Adding", function()
	ents.FindInSphere(Vector(203, 576, 523), 30)[1]:Remove()
end)
