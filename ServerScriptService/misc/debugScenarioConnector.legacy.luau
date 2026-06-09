


local moduleTBSystems = require(game.ServerScriptService.Modules.TBSystems)
local moduleUnitDatabase = require(game.ServerScriptService.Modules.unitDatabase)

game.ReplicatedStorage.DebugTriggers.debugScenario.OnServerEvent:Connect(function(triggeringPlayer)
	
	
	local baseUnits = {
		["TestPlayer"] = {
			
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
				["Instant Kill"] = "DebugInstantKill"
			}
		},
		
		
		["TestEnemy1"] = moduleUnitDatabase.newUnit("Enemies", "TestUnit"),
		["TestEnemy2"] = moduleUnitDatabase.newUnit("Enemies", "TestUnit"),
		["TestEnemy3"] = moduleUnitDatabase.newUnit("Enemies", "TestUnit")
		
		
	}
	
	local encounterID = moduleTBSystems.startEncounter(baseUnits)
	moduleTBSystems.debugDisplayEncounter(encounterID)
	
end)