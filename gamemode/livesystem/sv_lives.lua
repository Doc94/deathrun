print("Loading LIVE System By Doc...")

tableLives = {} --Table for lives of runners
--tableLives["76561198062831768"] = 2 --Debugtest

tablePos = {}

tablePosStatus = {}

cansetLives = false

--cvars system
CreateConVar("deathrun_enablelives", "1", defaultFlags, "Set if lives are enable or disabled")

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
		tableLives = {} --Reset all lives datas
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
hook.Add("DeathrunPlayerDeath", "deathPlayerLives",
	function(victim, inflictor, attacker)
		if GetConVar("deathrun_enablelives"):GetInt() == 0 then return end --Well not neeed read this

		if victim:Team() ~= TEAM_RUNNER then return end --Only runners pass here

		if tableLives[victim:SteamID64()] == nil then --Why not
			tableLives[victim:SteamID64()] = GetConVar("deathrun_runner_lives"):GetInt()
		end

		tableLives[victim:SteamID64()] = tableLives[victim:SteamID64()] - 1

		local livesPlayer = tableLives[victim:SteamID64()]

		DR:ChatBroadcast("The player " .. victim:Name() .. " has dead and now have " .. livesPlayer .. " lives in this round")

		if livesPlayer > 0 then
			--victim:KillSilent()
			victim:DeathrunChatPrint("You have " .. livesPlayer .. " lives, wait 7 seconds to respawn." )
			timer.Simple(7, function()
				local posRespawn = tablePos[victim:SteamID64()]
				victim:Spawn()
				if posRespawn then
					victim:SetPos(posRespawn)
				end
			end)
		else
			victim:DeathrunChatPrint("You have lost all your lives :c")
		end

	end
)



--Start round
hook.Add("DeathrunBeginActive", "startRoundLives",
	function()
		print("Reload lives to start")
		if GetConVar("deathrun_enablelives"):GetInt() == 0 then return end --Well not neeed read this
		tableLives = {} --Reset all lives datas

		DR:ChatBroadcast("This round have a system lives enabled.")

		for k, v in ipairs( player.GetAll() ) do
			--Check livesystem/sv_lives
			if v:Team() == TEAM_RUNNER then
				tableLives[v:SteamID64()] = GetConVar("deathrun_runner_lives"):GetInt()
				tablePosStatus[v:SteamID64()] = true
			end
		end
		DR:ChatBroadcast("All runners have " .. GetConVar("deathrun_runner_lives"):GetInt() .. " lives in this round.")
		print("Set lives to all runners to " .. GetConVar("deathrun_runner_lives"):GetInt() .. "")
		cansetLives = true

		--Save pos timmer
		timer.Create("savepostolives", 6, 0, function()
			for k, v in ipairs( player.GetAll() ) do
				if v:Team() == TEAM_RUNNER then
					DR:ChatBroadcast("MOVE IS " .. v:GetMoveType())
					if v:GetVelocity():IsZero() and v:Alive() and v:WaterLevel() == 0 and v:IsOnGround() and not v:IsOnFire() then
						if v:GetGroundEntity() then
                            if v:GetGroundEntity():GetVelocity():IsZero() then
								if tablePosStatus[v:SteamID64()] == true then
									tablePos[v:SteamID64()] = v:GetPos()
									v:PrintMessage(HUD_PRINTCENTER ,"Checkpoint Save")
								end
								tablePosStatus[v:SteamID64()] = true
                            end
                        end
					end
					DR:ChatBroadcast("end move")
				end
			end
		end)
	end
)

--End round
hook.Add("DeathrunBeginOver", "endRoundLives",
	function()
		tablePos = {}
		timer.Remove("savepostolives")
	end
)

--PreStart round
hook.Add("DeathrunBeginPrep", "prestartRoundLives",
	function()
		print("Reload lives to start")
		if GetConVar("deathrun_enablelives"):GetInt() == 0 then return end --Well not neeed read this
		cansetLives = false
	end
)

function hasPlayersWithLives()
	if GetConVar("deathrun_enablelives"):GetInt() == 0 then return false end --Well not neeed read this
	for k,v in pairs(tableLives) do
		if v > 0 then
			return true
		end
	end
	return false
end

--Register commands
include("sv_commands.lua")