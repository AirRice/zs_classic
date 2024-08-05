-- Removes teleports and other annoying ZM garbage.

hook.Add("InitPostEntityMap", "Adding", function()
	for _, ent in pairs(ents.FindByClass("trigger_push")) do ent:Remove() end
	for _, ent in pairs(ents.FindByClass("trigger_teleport")) do ent:Remove() end
	
	local lastThink = 0
	hook.Remove("Think", "TESTING")
	hook.Add("Think", "TESTING", function()
		if (lastThink + 1 <= CurTime()) then
			local doorpos = Vector(258.502350, -623.534180, -255.968750)
			
			for _, ent in pairs(ents.FindInSphere(doorpos, 200)) do
				if (ent:GetClass() == "func_door_rotating") then
					local mins = ent:OBBMins()
					local maxs = ent:OBBMaxs()
					
					local wmins = ent:LocalToWorld(mins)
					local wmaxs = ent:LocalToWorld(maxs)
					
					for _, pl in pairs(ents.FindInBox(wmins, wmaxs)) do
						if (pl:IsPlayer()) then
							local td = {}
							td.start = pl:GetPos()
							td.endpos = td.start
							td.filter = {}
							table.insert(td.filter, pl)
							table.Add(td.filter, team.GetPlayers(pl:Team()))
							td.mins = pl:OBBMins()
							td.maxs = pl:OBBMaxs()
							local tr = util.TraceHull(td)
							
							if (!tr.HitWorld and IsValid(tr.Entity)) then
								local dir
								
								local eobbc = ent:LocalToWorld(ent:OBBCenter())
								local pobbc = pl:LocalToWorld(pl:OBBCenter())
								
								dir = (pobbc - eobbc):GetNormal()
								
								dir.x = 0							
								dir.z = 0
								
								pl:SetPos(td.start + dir * 100)
							end
						end
					end
				end
			end
			lastThink = CurTime()
		end
	end)
end)
