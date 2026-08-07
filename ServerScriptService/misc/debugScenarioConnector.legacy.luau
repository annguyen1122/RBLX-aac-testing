


local moduleTBSystems = require(game.ServerScriptService.Modules.TBSystems)
local moduleUnitDatabase = require(game.ServerScriptService.Modules.unitDatabase)
local modulePlayerStats = require(game.ServerScriptService.Modules.playerStats)

local PlayerService = game:GetService("Players")

-- this is for testing for now, but move the datastores into a module script or something, so that the data can be accessed outside this script
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData")

local loadedPlayerDataStore = {}
--update player data on join
PlayerService.PlayerAdded:Connect(function(joiningPlayer)
	local success, joiningPlayerDataStore = pcall(function()
		return playerDataStore:GetAsync(joiningPlayer.UserId)
	end)
	if success then
		-- empty save
		if joiningPlayerDataStore == nil then
			local defaultSave = {
				["ChosenClass"] = "Blademaster"
			}
			print("Empty Save, Setting Default")
			joiningPlayerDataStore = defaultSave
			local success, result = pcall(function()
				playerDataStore:SetAsync(joiningPlayer.UserId, defaultSave)
			end)
			if not success then
				warn("Setting Default Save Failed", result)
			else
				print("Save Successful")
			end
		end
		print("Load Successful")
	else
		warn("Player Data Load Failed", joiningPlayerDataStore)
	end
	loadedPlayerDataStore[joiningPlayer.UserId] = joiningPlayerDataStore
	
	--print(loadedPlayerDataStore)
	local thisPlayerDataStore = loadedPlayerDataStore[joiningPlayer.UserId]

	local succ, result = pcall(function()
		modulePlayerStats.CreateBaseStats(joiningPlayer.UserId)
	end)
	if succ then
		modulePlayerStats.AssignClassStats(joiningPlayer.UserId, thisPlayerDataStore["ChosenClass"])
	else
		warn(result)
	end
end)

game.ReplicatedStorage.DebugTriggers.debugScenario.OnServerEvent:Connect(function(triggeringPlayer)
	


	local encounterID = moduleTBSystems.startEncounter("DebugEncounter")
	--moduleTBSystems.debugDisplayEncounter(encounterID)
	
end)