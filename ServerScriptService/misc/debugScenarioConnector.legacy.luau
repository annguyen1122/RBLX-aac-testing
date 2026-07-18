


local moduleTBSystems = require(game.ServerScriptService.Modules.TBSystems)
local moduleUnitDatabase = require(game.ServerScriptService.Modules.unitDatabase)
local modulePlayerStats = require(game.ServerScriptService.Modules.playerStats)

game.ReplicatedStorage.DebugTriggers.debugScenario.OnServerEvent:Connect(function(triggeringPlayer)
	
	local oldTestPlayer = {

			["UnitData"] = {
				["UnitType"] = "Player", -- Player / FriendlyAI / EnemyAI,
				["PlayerID"] = triggeringPlayer.UserId,
				["UnitName"] = triggeringPlayer.Name,
				["DeathStatus"] = "Alive"
			},


			["Stats"] = {
				["MaxHealth"] = 100,
				["Health"] = 100
			},

			["Actions"] = {
				-- make sure that the future code takes into account the possibility of multiple actions being here and varied possible amounts.
				["Debug Attack"] = "DebugAttack",
				["Instant Kill"] = "DebugInstantKill",
				["Sword Lunge"] = "SwordLunge"
			},
			["Animations"] = {
				["Death"] = "placeholderDeath"
			}
		}

	local s, err = pcall(function()
		modulePlayerStats.CreateBaseStats(triggeringPlayer.UserId)
	end)
	if err then
		print(err)
	else
		modulePlayerStats.AssignClassStats(triggeringPlayer.UserId, "DebugClass")
	end
	
	local testPlayer = modulePlayerStats.GetPlayerUnitStats(triggeringPlayer.UserId)
	
	print(testPlayer)
	print(oldTestPlayer)
	
	local baseUnits = {

		["TestPlayer"] = testPlayer, -- i dont know why but if you put a space between testplayer, it makes one of the sword units unselectable? figure that bug out later, but we can ignore it for now

		["LinkedSword1"] = moduleUnitDatabase.newUnit("Enemies", "Sword"),
		["LinkedSword2"] = moduleUnitDatabase.newUnit("Enemies", "Sword"),
		["LinkedSword3"] = moduleUnitDatabase.newUnit("Enemies", "Sword"),
		["ZERAT"] = moduleUnitDatabase.newUnit("Enemies", "Rat"),
		
	}
	
	local encounterID = moduleTBSystems.startEncounter(baseUnits)
	moduleTBSystems.debugDisplayEncounter(encounterID)
	
end)