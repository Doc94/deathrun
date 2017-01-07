print("Loading LIVE System By Doc...")

CreateConVar("deathrun_runner_lives", "1", defaultFlags, "Lifes for runners. <br> DONT SET TO 0")

tableLives = {}
--tableLives["76561198062831768"] = 2

-- Death system
hook.Add("DeathrunPlayerDeath", "DeathCheckLives", deathPlayer)

function deathPlayer(victim, inflictor, attacker)
	if GetConVar("deathrun_runner_lives"):GetInt() <= 1 then return end --Well not neeed read this
	
	if tableLives[victim:SteamID64()] == nil then
		PrintMessage(HUD_PRINTTALK ,"El jugador " .. victim:Name() .. " [" .. victim:SteamID64() .. "] no tiene vidas?")
		return
	end
	
	tableLives[victim:SteamID64()] = tableLives[victim:SteamID64()] - 1
	
	local livesPlayer = tableLives[victim:SteamID64()]
	
	DR:ChatBroadcast("The player " .. victim:Name() .. " has " .. livesPlayer .. " lives reaming")
	
	if livesPlayer > 0 then
		--victim:KillSilent()
		timer.Simple(10, function() 
			victim:Spawn()
		end)
	else 
		victim:DeathrunChatPrint("You have lost all your lives :c")
	end
	
end

--Start round
hook.Add("DeathrunBeginActive", "Set lives", startRound)

function startRound()
	for k, v in ipairs( player.GetAll() ) do
		--Check livesystem/sv_lives
		if v:Team() == TEAM_RUNNER then
			tableLives[v:SteamID64()] = GetConVar("deathrun_runner_lives"):GetInt()
		end
	end
	print("Set lives to all runner to " .. GetConVar("deathrun_runner_lives"):GetInt() .. "")
end

--Register commands
include("sv_commands.lua")