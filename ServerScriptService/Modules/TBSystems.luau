
local HttpService = game:GetService("HttpService")
local PlayersService = game:GetService("Players")

local moduleUnitDatabase = require(game.ServerScriptService.Modules.unitDatabase)
local moduleActionsDatabase = require(game.ServerScriptService.Modules.actionsDatabase)


local TBSystems = {}

--todo, split the encounter data storage from this system thing to a different module script
TBSystems.encounterData = {}

function TBSystems.startEncounter(baseUnits)
	
	local newUUID = HttpService:GenerateGUID() 
	TBSystems.encounterData[newUUID] = {}
	local thisEncounter = TBSystems.encounterData[newUUID]

	thisEncounter["Units"] = {}
	local unitID = 0
	--individual unit loop
	for unitName, storedUnitData in baseUnits do
		
		-- set default stats to replace, also in case there's a missing stat from the base unit data
		thisEncounter["Units"][unitID] = {}
		local dataTemplate = moduleUnitDatabase.DefaultData
		local newUnitData = thisEncounter["Units"][unitID]
		
		--print(unitID, newUnitData, storedUnitData) --debug

		newUnitData["UnitData"] = {}
		newUnitData["UnitData"]["UnitType"] = storedUnitData["UnitData"]["UnitType"]
		newUnitData["UnitData"]["PlayerID"] = storedUnitData["UnitData"]["PlayerID"]
		
		-- individual stats loop
		-- replaces default stats for corresponding stat on the inputted unit data
		newUnitData["Stats"] = {}
		for statName, statValue in storedUnitData["Stats"] do
			newUnitData["Stats"][statName] = statValue
		end
		
		
		--copies storedUnitData[actions] to newunitdata
		newUnitData["Actions"] = {}
		for actionName, actionFunction in storedUnitData["Actions"] do
			newUnitData["Actions"][actionName] = actionFunction
		end
		--TODO: make the values in the default be the fallback if values are wrong
		
		--to have a serial unitID so identical unit types dont overlap with each other
		unitID += 1
	end
	
	
	return newUUID
end


function TBSystems.unitTurnHandler(encounterID, encounterUnitID)
	
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	if unitWhoseTurn["UnitData"]["UnitType"] == "Player" then
		TBSystems.playerTurn(encounterID, encounterUnitID)
	elseif unitWhoseTurn["UnitData"]["UnitType"] == "EnemyAI" then
	
	elseif unitWhoseTurn["UnitData"]["UnitType"] == "FriendlyAI" then
		
	else
		error("Invalid Unit Type")
	end
		
end

function TBSystems.playerTurn(encounterID, encounterUnitID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	
	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireClient(PlayersService:GetPlayerByUserId(unitWhoseTurn["UnitData"]["PlayerID"]), unitWhoseTurn.Actions)
	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnServerEvent:Connect(function(firedPlayer, actionFunction)
		moduleActionsDatabase[actionFunction](encounterID, unitWhoseTurn, thisEncounter["Units"][1])--defender is placeholder TODO: make it selectable
		TBSystems.debugDisplayEncounter(encounterID)
	end)
end




function TBSystems.debugDisplayEncounter(encounterUID)
	
	local encounterData = TBSystems.encounterData[encounterUID]
	
	print(encounterData)
	
end



return TBSystems
