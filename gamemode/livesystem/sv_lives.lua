print("Loading LIVE System By Doc...")

tableLives = {} --Table for lives of runners
--tableLives["76561198062831768"] = 2 --Debugtest

--cvars system
CreateConVar("deathrun_enablelives", "0", defaultFlags, "Set if lives are enable or disabled")

CreateConVar("deathrun_runner_lives", "2", defaultFlags, "Lifes for runners. <br> DONT SET TO 0")


cvars.AddChangeCallback( "deathrun_enablelives", function( convar_name, value_old, value_new )
	local newvalue2 = tonumber(value_new)
	if newvalue2 == nil then return end

	if newvalue2 > 1 then
		RunConsoleCommand("deathrun_enablelives", "1")
        return
	elseif newvalue2 < 0 then
		RunConsoleCommand("deathrun_enablelives", "0")
        return
    end

    if newvalue2 == 1 then
        DR:ChatBroadcast("The lives system for runners is ENABLE")
    else
        DR:ChatBroadcast("The lives system for runners is DISABLE")
    end

end )

cvars.AddChangeCallback( "deathrun_runner_lives", function( convar_name, value_old, value_new )
	local newvalue2 = tonumber(value_new)
	if newvalue2 == nil then return end
	if newvalue2 <= 0 then
		RunConsoleCommand("deathrun_runner_lives", "1")
	elseif newvalue2 > 20 then
		RunConsoleCommand("deathrun_runner_lives", "20")
    end
    DR:ChatBroadcast("The next round all runners have " .. newvalue2 .. " lifes")
end )

-- Death system
hook.Add("DeathrunPlayerDeath", "DeathCheckLives", deathPlayer)

function deathPlayer(victim, inflictor, attacker)
	if GetConVar("deathrun_enablelives"):GetInt() == 0 then
        PrintMessage(HUD_PRINTTALK ,"Player dead and the lives system is offline")
        return
    end --Well not neeed read this

    if victim:Team() ~= TEAM_RUNNER then return end
	
	if tableLives[victim:SteamID64()] == nil then
        tableLives[victim:SteamID64()] = 1
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
hook.Add("DeathrunBeginPrep", "Set lives", startRound)

function startRound()
    DR:ChatBroadcast("Round started")
    print("Start function lives start")
	if GetConVar("deathrun_enablelives"):GetInt() == 0 then
        return
    end --Well not neeed read this
    print("Reload lives")
    DR:ChatBroadcast("This round have a system lives enabled.")
	for k, v in ipairs( player.GetAll() ) do
		--Check livesystem/sv_lives
        print("Player " .. v:Name() .. " has team " .. v:Team())
		if v:Team() == TEAM_RUNNER then
			tableLives[v:SteamID64()] = GetConVar("deathrun_runner_lives"):GetInt()
		end
	end
	print("Set lives to all runners to " .. GetConVar("deathrun_runner_lives"):GetInt() .. "")
end

--Register commands
include("sv_commands.lua")