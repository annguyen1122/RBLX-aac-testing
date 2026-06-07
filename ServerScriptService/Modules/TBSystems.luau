
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
		for unitDataName, unitDataValue in storedUnitData["UnitData"] do
			newUnitData["UnitData"][unitDataName] = unitDataValue
		end
		--TODO: same issue as below, fallback systems
		
		-- individual stats loop
		-- replaces default stats for corresponding stat on the inputted unit data
		newUnitData["Stats"] = {}
		for statName, statValue in storedUnitData["Stats"] do
			newUnitData["Stats"][statName] = statValue
		end
		--TODO: add a fallback system if the newunitdata stats are missing stuff. for now we're assuming it has the same stuff as the default to cause errors to catch if the stats inputted are wrong.
		
		--copies storedUnitData[actions] to newunitdata
		newUnitData["Actions"] = {}
		for actionName, actionFunction in storedUnitData["Actions"] do
			newUnitData["Actions"][actionName] = actionFunction
		end
		--TODO: make the values in the default be the fallback if values are wrong
		
		--to have a serial unitID so identical unit types dont overlap with each other
		unitID += 1
	end
	
	createTurnOrder(newUUID)
	return newUUID
end


function TBSystems.unitTurnHandler(encounterID, encounterUnitID)
	
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	if unitWhoseTurn["UnitData"]["UnitType"] == "Player" then
		TBSystems.playerTurn(encounterID, encounterUnitID)
	elseif unitWhoseTurn["UnitData"]["UnitType"] == "EnemyAI" then
		print("ENEMY TURN")
	elseif unitWhoseTurn["UnitData"]["UnitType"] == "FriendlyAI" then
		
	else
		error("Invalid Unit Type")
	end
		
end

function TBSystems.playerTurn(encounterID, encounterUnitID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	local thisPlayer = PlayersService:GetPlayerByUserId(unitWhoseTurn["UnitData"]["PlayerID"])
	
	
	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireClient(thisPlayer, "openActionMenu", unitWhoseTurn.Actions)
	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnServerEvent:Connect(function(firedPlayer, RE_request, arg1, arg2)
		if firedPlayer.UserId == thisPlayer.UserId then -- check for if it's the same player, so multiple players don't conflict with this
			if RE_request == "performAction" then
				local actionFunction = arg1
				local targetID = arg2
				--print(actionFunction)

				moduleActionsDatabase[actionFunction](encounterID, unitWhoseTurn, thisEncounter["Units"][targetID])--defender is placeholder TODO: make it selectable
				TBSystems.endPlayerTurn(thisPlayer)
				beginNextTurn(encounterID)
			elseif RE_request == "openSubmenuTargeting" then
				local actionFunction = arg1
				local validEnemyTargetList = getValidEnemyTargets(encounterID, encounterUnitID)
				game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireClient(thisPlayer, "openSubmenuTargeting", validEnemyTargetList, actionFunction)

			end
			--TBSystems.debugDisplayEncounter(encounterID)
		end
	end)
end


function TBSystems.endPlayerTurn(thisPlayer)
	
	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireClient(thisPlayer, "closeActionMenu")
	
end


function getValidEnemyTargets(encounterID, encounterUnitID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	if unitWhoseTurn["UnitData"]["UnitType"] == "Player" or unitWhoseTurn["UnitData"]["UnitType"] == "FriendlyAI" then
		local validTargetList = {}
		for unitID, unitData in thisEncounter["Units"] do
			if unitData["UnitData"]["UnitType"] == "EnemyAI" then
				validTargetList[unitID] = thisEncounter["Units"][unitID] 
			end
		end
		
		return validTargetList
		
	elseif unitWhoseTurn["UnitData"]["UnitType"] == "EnemyAI" then
		
		--TODO

	end
end




function TBSystems.debugDisplayEncounter(encounterUID)
	
	local encounterData = TBSystems.encounterData[encounterUID]
	
	print(encounterData)
	
end

function createTurnOrder(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	thisEncounter["TurnData"] = {}
	thisEncounter["TurnData"]["TurnOrder"] = {} 
	
	--placeholder turn order until speed stats are implemented, do turn order based off unit ID's chronologically
	--this code below is temp
	local turnNum = 0
	for unitID, unitData in thisEncounter["Units"] do
		thisEncounter["TurnData"]["TurnOrder"][turnNum] = unitID
		turnNum += 1
	end
	
	thisEncounter["TurnData"]["CurrentTurn"] = 0
	print(thisEncounter["TurnData"])
end

function beginNextTurn(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	local turnData = thisEncounter["TurnData"]
	
	turnData["CurrentTurn"] += 1
	
	print(turnData["CurrentTurn"], turnData["TurnOrder"][turnData["CurrentTurn"]])
	
	TBSystems.unitTurnHandler(encounterID, turnData["TurnOrder"][turnData["CurrentTurn"]])
end

return TBSystems
