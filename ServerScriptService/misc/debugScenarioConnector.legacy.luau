


local moduleTBSystems = require(game.ServerScriptService.Modules.TBSystems)
local moduleUnitDatabase = require(game.ServerScriptService.Modules.unitDatabase)

game.ReplicatedStorage.DebugTriggers.debugScenario.OnServerEvent:Connect(function(triggeringPlayer)
	
	
	local baseUnits = {
		["TestPlayer"] = {
			
			["UnitData"] = {
				["UnitType"] = "Player", -- Player / FriendlyAI / EnemyAI,
				["PlayerID"] = triggeringPlayer.UserId,
				["UnitName"] = triggeringPlayer.Name
			},
			
			
			["Stats"] = {
				["MaxHealth"] = 100,
				["Health"] = 100
			},
			
			["Actions"] = {
				-- make sure that the future code takes into account the possibility of multiple actions being here and varied possible amounts.
				["DebugAttack"] = "debugAttack" --the name is what's put when doing moduleActionsDatabase[HERE]
			}
		},
		
		
		["TestEnemy1"] = moduleUnitDatabase.newUnit("Enemies", "TestUnit"),
		["TestEnemy2"] = moduleUnitDatabase.newUnit("Enemies", "TestUnit"),
		["TestEnemy3"] = moduleUnitDatabase.newUnit("Enemies", "TestUnit")
		
		
	}
	
	local encounterID = moduleTBSystems.startEncounter(baseUnits)
	moduleTBSystems.debugDisplayEncounter(encounterID)
	
	--testing turn of unit 0
	moduleTBSystems.unitTurnHandler(encounterID, 0)
	
end)