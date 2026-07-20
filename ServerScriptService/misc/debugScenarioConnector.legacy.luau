


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
end)

game.ReplicatedStorage.DebugTriggers.debugScenario.OnServerEvent:Connect(function(triggeringPlayer)
	
	print(loadedPlayerDataStore)
	local thisPlayerDataStore = loadedPlayerDataStore[triggeringPlayer.UserId]

	
	
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
				["Debug Attack"] = "DebugAttack",
				["Instant Kill"] = "DebugInstantKill",
				["Sword Lunge"] = "SwordLunge"
			},
			["Animations"] = {
				["Death"] = "placeholderDeath"
			}
		}

	--local succ, result = pcall(function()
	--	modulePlayerStats.CreateBaseStats(triggeringPlayer.UserId)
	--end)
	--if succ then
	--	modulePlayerStats.AssignClassStats(triggeringPlayer.UserId, "DebugClass")
	--else
	--	print(result)
	--end
	
	
	local succ, result = pcall(function()
		modulePlayerStats.CreateBaseStats(triggeringPlayer.UserId)
	end)
	if succ then
		modulePlayerStats.AssignClassStats(triggeringPlayer.UserId, thisPlayerDataStore["ChosenClass"])
	else
		print(result)
	end
	
	
	
	local testPlayer = modulePlayerStats.GetPlayerUnitStats(triggeringPlayer.UserId)
	
	--print(testPlayer)
	--print(oldTestPlayer)
	
	local baseUnits = {

		["TestPlayer"] = testPlayer, -- i dont know why but if you put a space between testplayer, it makes one of the sword units unselectable? figure that bug out later, but we can ignore it for now

		["LinkedSword1"] = moduleUnitDatabase.newUnit("Enemies", "Sword"),
		["LinkedSword2"] = moduleUnitDatabase.newUnit("Enemies", "Sword"),
		["LinkedSword3"] = moduleUnitDatabase.newUnit("Enemies", "Sword"),
		["ZERAT"] = moduleUnitDatabase.newUnit("Enemies", "Rat"),
		
	}
	
	local encounterID = moduleTBSystems.startEncounter(baseUnits)
	--moduleTBSystems.debugDisplayEncounter(encounterID)
	
end)