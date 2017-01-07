print("Loading Commands for LIVE System By Doc...")

concommand.Add("deathrun_setlives",function(ply, cmd, args)
	if args[1] and args[2] then
		local targets = FindPlayersByName( args[1] )
		local newLives = tonumber(args[2])
		local cont = false

		if DR:CanAccessCommand( ply, cmd ) then
		
			if type(newLives) == "number" then
				if newLives == 0 or newLives > 10 then DeathrunSafeChatPrint( ply, "The value of lives is [1-10]") return end
				local players = ""
				if #targets > 0 then
					-- for k, targ in ipairs( targets ) do
					-- 	--if ( ply:Team() == TEAM_SPECTATOR ) then
					-- 		--table.remove( targets, k )
					-- 	--end
					-- end
					for k,targ in ipairs( targets ) do
						if targ:Team() == TEAM_RUNNER then
							tableLives[targ:SteamID64()] = newLives
							players = players..targ:Nick()..", "
						else 
							DeathrunSafeChatPrint( ply, "The player " .. targ:Name() .. "not is RUNNER" )
						end

					end
				end

				DeathrunSafeChatPrint( ply, "The players "..string.sub(players,1,-3).." now have " .. newLives .. " lives")
			else
				DeathrunSafeChatPrint( ply, "Only numbers.")
			end
		else
			DeathrunSafeChatPrint( ply, "You are not allowed to do that.")
		end
	elseif args[1] then
		local newLives = tonumber(args[1])
		
		if DR:CanAccessCommand( ply, cmd ) then
			if type(newLives) == "number" then
				if newLives == 0 or newLives > 10 then DeathrunSafeChatPrint( ply, "The value of lives is [1-10]") return end
				if ply:Team() == TEAM_RUNNER then
					tableLives[ply:SteamID64()] = newLives
					DeathrunSafeChatPrint( ply, "Your have now have " .. newLives .. " lives" )
				else 
					DeathrunSafeChatPrint( ply, "You are not a RUNNER" )
				end
			else
				DeathrunSafeChatPrint( ply, "Only numbers.")
			end
		else
			DeathrunSafeChatPrint( ply, "You are not allowed to do that.")
		end
	else
		DeathrunSafeChatPrint( ply, "Could not execute command.")
	end

end, nil, nil, FCVAR_SERVER_CAN_EXECUTE )

concommand.Add("deathrun_getlives",function(ply, cmd, args)
	if args[1] then
		local targets = FindPlayersByName( args[1] )
		local cont = false
		
		if #targets == 1 then
			if tableLives[victim:SteamID64()] == nil then DeathrunSafeChatPrint( ply, "This player not have lives." ) return end
			local lives = tableLives[targets[1]:SteamID64()]
			ply:DeathrunChatPrint("El jugador " .. targets[1]:Name() .. " have " .. lives .. " lives")
		elseif #targets > 1 then
			DeathrunSafeChatPrint( ply, "One player at a time, please." )
		else
			DeathrunSafeChatPrint( ply, "No targets found with that name.")
		end
	elseif not args[1] then
		if tableLives[ply:SteamID64()] == nil then DeathrunSafeChatPrint( ply, "You do havent lives." ) return end
		local lives = tableLives[ply:SteamID64()]
		ply:DeathrunChatPrint("You have " .. lives .. " lives")
			
	else
		DeathrunSafeChatPrint( ply, "Could not execute command.")
	end

end, nil, nil, FCVAR_SERVER_CAN_EXECUTE )

DR:AddChatCommand("getlives", function(ply, args)
	ply:ConCommand("deathrun_getlives "..(args[1] or ""))
	PrintTable( args )
end)

DR:AddChatCommand("setlives", function(ply, args)
	ply:ConCommand("deathrun_setlives "..(args[1] or "")..(args[2] or ""))
	PrintTable( args )
end)