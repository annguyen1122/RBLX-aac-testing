
local HttpService = game:GetService("HttpService")
local PlayersService = game:GetService("Players")

local moduleUnitDatabase = require(game.ServerScriptService.Modules.unitDatabase)
local moduleActionsCode = require(game.ServerScriptService.Modules.actionsCode)
local moduleEnemyAi = require(game.ServerScriptService.Modules.enemyAI)
local moduleActionsData = require(game.ReplicatedStorage.Modules.ReplicatedData.actionsData)
local moduleTurnHelper = require(game.ReplicatedStorage.Modules.helpers.turnHelper)
local moduleAnimationFunctions = require(game.ServerScriptService.Modules.animationFunctions)

local TBSystems = {}

--todo, split the encounter data storage from this system thing to a different module script
TBSystems.encounterData = {}

function TBSystems.startEncounter(baseUnits)
	
	local encounterID = createEncounterDatabase(baseUnits)
	
	--loadMap(newUUID, "Crossroads", "CrossroadsVariation1")
	loadMapFromCategory(encounterID, "Crossroads")
	setPlayersCamera(encounterID)
	createTurnOrder(encounterID)
	assignTeams(encounterID)
	summonUnits(encounterID) -- do after teams are assigned
	beginNextTurn(encounterID)
--	endTurn(encounterID)
end

function createEncounterDatabase(baseUnits)
	local newUUID = HttpService:GenerateGUID() 
	TBSystems.encounterData[newUUID] = {}
	local thisEncounter = TBSystems.encounterData[newUUID]

	thisEncounter["Units"] = {}
	local unitID = 0
	--individual unit loop
	-- creates copies of data for the encounter, so it doesnt affect base stats
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
		for actionName, actionInternalName in storedUnitData["Actions"] do
			newUnitData["Actions"][actionName] = actionInternalName
		end
		--TODO: make the values in the default be the fallback if values are wrong
		
		print(storedUnitData)
		newUnitData["Animations"] = {}
		for animationInternalName, animationFunction in storedUnitData["Animations"] do
			newUnitData["Animations"][animationInternalName] = animationFunction
		end

		--to have a serial unitID so identical unit types dont overlap with each other
		unitID += 1
	end
	return newUUID
end




function TBSystems.playerTurn(encounterID, encounterUnitID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	local thisPlayer = PlayersService:GetPlayerByUserId(unitWhoseTurn["UnitData"]["PlayerID"])
	

	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireClient(thisPlayer, "openActionMenu", unitWhoseTurn.Actions, thisEncounter)
	
	-- TODO: need some code here to make sure the event doesnt get assigned twice so that turns dont happen twice when it loops back around
	local playerActionMenuInput --defines variable before, so the line below can use it inside
	playerActionMenuInput = game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnServerEvent:Connect(function(firedPlayer, RE_request, arg1, arg2)
		if firedPlayer.UserId == thisPlayer.UserId then -- check for if it's the same player, so multiple players don't conflict with this
			if RE_request == "performAction" then
				local actionInternalName = arg1
				local targetID = arg2
				--print(actionInternalName)
				local actionFunction = moduleActionsData["generalActions"][actionInternalName]["actionFunction"]

				moduleActionsCode[actionFunction](encounterID, unitWhoseTurn, thisEncounter["Units"][targetID]) --TODO: add code here to validate if the selections are valid from player input.
				TBSystems.endPlayerTurn(thisPlayer, encounterID)
				endTurn(encounterID)
				playerActionMenuInput:Disconnect()
				
			end
		end
	end)
	
end
--TODO: need some code to make sure exploiters dont attack out of turn, validate inputs to only work if during turn.


function TBSystems.endPlayerTurn(thisPlayer, encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireClient(thisPlayer, "closeActionMenu", thisEncounter)
	
end


function enemyTurn(encounterID, encounterUnitID)
	
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
	local enemyAIType = unitWhoseTurn["UnitData"]["EnemyAI"]
	
	--local enemyOptions = getValidTargets(encounterID, encounterUnitID, )
	
	local potentialActions = unitWhoseTurn["Actions"]
	local potentialTargets = moduleTurnHelper.getAllAliveTeamUnits("Playerside", thisEncounter)
	
	local enemyAction = moduleEnemyAi[enemyAIType](potentialActions, potentialTargets)
	
	local actionInternalName = enemyAction[1]
	local enemyTargetID = enemyAction[2]

	local actionFunction = moduleActionsData["generalActions"][actionInternalName]["actionFunction"]
	
	print(actionFunction, encounterID, unitWhoseTurn, thisEncounter["Units"][enemyTargetID])
	if moduleActionsCode[actionFunction] == nil then
		error("Invalid Action Function")
	end
	moduleActionsCode[actionFunction](encounterID, unitWhoseTurn, thisEncounter["Units"][enemyTargetID])
	
	
	endTurn(encounterID)
end

function assignTeams(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	thisEncounter["Teams"] = {}
	thisEncounter["Teams"]["Playerside"] = {}
	thisEncounter["Teams"]["Enemyside"] = {}
	
	for unitID, unit in thisEncounter["Units"] do
		if unit["UnitData"]["UnitType"] == "Player" or unit["UnitData"]["UnitType"] == "FriendlyAI" then
			thisEncounter["Teams"]["Playerside"][unitID] = unitID
		elseif unit["UnitData"]["UnitType"] == "EnemyAI" then
			thisEncounter["Teams"]["Enemyside"][unitID] = unitID
		end
	end
end


--replacing this code with a different system, grouping the units into teams in the dictionary instead of getting it every time. the teams will be passed to client to make it easier, but i need to make sure to validate it.

--function getValidTargets(encounterID, encounterUnitID, attackInternalName)
--	local thisEncounter = TBSystems.encounterData[encounterID]
--	print(thisEncounter)
--	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
--	local attackData = moduleActionsData.generalActions[attackInternalName]
	
--	local validTargets
--	if attackData["actionTargeting"] == "enemyTargeting" then
--		validTargets = getValidEnemyTargets(encounterID, encounterUnitID)
--	end
	
--	return validTargets
--end

--function getValidEnemyTargets(encounterID, encounterUnitID)
--	local thisEncounter = TBSystems.encounterData[encounterID]
--	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]
	
--	if unitWhoseTurn["UnitData"]["UnitType"] == "Player" or unitWhoseTurn["UnitData"]["UnitType"] == "FriendlyAI" then
--		local validTargetList = {}
--		for unitID, unitData in thisEncounter["Units"] do
--			if unitData["UnitData"]["UnitType"] == "EnemyAI" then
--				validTargetList[unitID] = thisEncounter["Units"][unitID] 
--			end
--		end
		
--		return validTargetList
		
--	elseif unitWhoseTurn["UnitData"]["UnitType"] == "EnemyAI" then
		
--		--TODO
--		local validTargetList = {}
--		for unitID, unitData in thisEncounter["Units"] do
--			if unitData["UnitData"]["UnitType"] == "Player" or unitWhoseTurn["UnitData"]["UnitType"] == "FriendlyAI" then
--				validTargetList[unitID] = thisEncounter["Units"][unitID]
--			end
--		end

--		return validTargetList

--	end
--end




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
end

function beginNextTurn(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	local turnData = thisEncounter["TurnData"]
	
	turnData["CurrentTurn"] += 1
	
	--print(turnData["CurrentTurn"], turnData["TurnOrder"][turnData["CurrentTurn"]])
	
	-- resets turn order once reaches end
	if turnData["TurnOrder"][turnData["CurrentTurn"]] == nil then
		turnData["CurrentTurn"] = 0
	end

	--sorts the turn so it'll run the proper code for if it's a player or AI
	
	local encounterUnitID = turnData["TurnOrder"][turnData["CurrentTurn"]]
	local thisEncounter = TBSystems.encounterData[encounterID]
	local unitWhoseTurn = thisEncounter["Units"][encounterUnitID]

	if unitWhoseTurn["UnitData"]["DeathStatus"] == "Dead" then
		print("DEAD, SKIP TURN")
		endTurn(encounterID)
	else
		if unitWhoseTurn["UnitData"]["UnitType"] == "Player" then
			TBSystems.playerTurn(encounterID, encounterUnitID)
		elseif unitWhoseTurn["UnitData"]["UnitType"] == "EnemyAI" then
			enemyTurn(encounterID, encounterUnitID)
		elseif unitWhoseTurn["UnitData"]["UnitType"] == "FriendlyAI" then
			print("unimplemented")
		else
			error("Invalid Unit Type")
		end
	end

end

--TODO: make a system just in case the checkvictory fails, cause enemys will infinitly loop their turn if it gets to that point
function endTurn(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	-- turn end delay
	wait(0.5)
	-- TODO add an info thing here for what enemy did.
	--maybe add a wait for any long turn anims. oh wait that should be put in the actions themselves. 
	
	-- update death status for all units in the encounter
	for unitID, unitData in thisEncounter["Units"] do
		deathCheck(encounterID, unitID)
	end
	--after death check, check if encounter ended
	local isEncounterEnd = checkVictory(encounterID)
	if isEncounterEnd == false then
		beginNextTurn(encounterID)
	end
end

--probably split this function later, but it both returns death status, and updates death status.
function deathCheck(encounterID, unitID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	local thisUnit = thisEncounter["Units"][unitID]
	
	if thisUnit["UnitData"]["DeathStatus"] == "Dead" then
		return "Dead"
	end
	
	if thisUnit["Stats"]["Health"] <= 0 and thisUnit["UnitData"]["DeathStatus"] == "Alive" then -- checks if they're under 0hp, and if they're not already marked dead
		doDeath(encounterID, unitID)
		return "Dead"
	end
	return "Alive"
end

function doDeath(encounterID, unitID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	local thisUnit = thisEncounter["Units"][unitID]
	
	local workspaceInstance = thisUnit["UnitData"]["WorkspaceInstance"]
	local success, error = pcall(function() moduleAnimationFunctions[thisUnit["Animations"]["Death"]](workspaceInstance.Humanoid.Animator) end)
	if error then
		print("pcall Error: ANIMATION NOT FOUND", error)
	end
	
	thisUnit["UnitData"]["DeathStatus"] = "Dead"
	print("UNIT ", unitID, " is dead")
end

function checkVictory(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	local alivePlayerside = moduleTurnHelper.getAllAliveTeamUnits("Playerside", thisEncounter)
	local aliveEnemyside = moduleTurnHelper.getAllAliveTeamUnits("Enemyside", thisEncounter)
	
	local isEncounterEnd = false
	
	if not next(aliveEnemyside) then
		print("YYAAAY YOU WIINNN")
		endEncounter(encounterID)
		isEncounterEnd = true
	elseif not next(alivePlayerside) then
		print("OH NOOOES YOU LOOSSTT")
		endEncounter(encounterID)
		isEncounterEnd = true
	end
	
	return isEncounterEnd
end

function loadMap(encounterID, mapCategory, mapName)
	local newMap = game.ServerStorage.Maps[mapCategory][mapName]:Clone()
	newMap.Parent = game.Workspace.CurrentMap
end

function loadMapFromCategory(encounterID, mapCategory)
	local mapList = game.ServerStorage.Maps[mapCategory]:GetChildren()
	local selectedMap = mapList[math.random(1, #mapList)]
	local loadedMap = selectedMap:Clone()
	loadedMap.Parent = game.Workspace.CurrentMap
end

--technically unloads all maps, but only one map should be loaded at a time
function unloadCurrentMap()
	for i, v in game.Workspace.CurrentMap:GetChildren() do
		v:Destroy()
	end
end

function setPlayersCamera(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	for unitID, unitData in thisEncounter["Units"] do
		if unitData["UnitData"]["UnitType"] == "Player" then
			local thisPlayer = PlayersService:GetPlayerByUserId(unitData["UnitData"]["PlayerID"])
			game.ReplicatedStorage.RemoteEvents.Gui.setCamera:FireClient(thisPlayer)
		end
	end
	
end

--this function only runs after teams are assigned, TODO: add a failsafe for this if it's not the case
function summonUnits(encounterID)
	local thisEncounter = TBSystems.encounterData[encounterID]
	
	local unitsStorage = Instance.new("Folder")
	unitsStorage.Name = "Units"
	unitsStorage.Parent = game.Workspace
	
	local combatPlate = game.Workspace.combatPlate
	local enemySpawn = combatPlate.basePlate.enemyLine
	local playerSpawn = combatPlate.basePlate.playerLine
	
	local playerUnitsStorage = Instance.new("Folder")
	playerUnitsStorage.Name = "PlayerUnits"
	playerUnitsStorage.Parent = unitsStorage
	local spawnIndex = 1
	for nameUnitID, unitID in thisEncounter["Teams"]["Playerside"] do
		local thisUnit = thisEncounter["Units"][unitID]
		if thisEncounter["Units"][unitID]["UnitData"]["UnitType"] == "Player" then
			local thisPlayer = PlayersService:GetPlayerByUserId(thisUnit["UnitData"]["PlayerID"])
			
			print(thisPlayer, "Spawn"..spawnIndex)
			
			local playerCopy = game.ServerStorage.Models.UnitModels.placeholderUnit:Clone()
			playerCopy:PivotTo(playerSpawn["Spawn"..spawnIndex].WorldCFrame * CFrame.Angles(0, math.rad(270), 0))
			local humanoidDescription = thisPlayer.Character.Humanoid:GetAppliedDescription()
			playerCopy.Parent = playerUnitsStorage
			playerCopy.Humanoid:ApplyDescriptionAsync(humanoidDescription)
			playerCopy.HumanoidRootPart.Anchored = true
			
			thisEncounter["Units"][unitID]["UnitData"]["WorkspaceInstance"] = playerCopy
			
			local animationFunctionName = thisUnit["Animations"]["Idle"] or nil
			if animationFunctionName then
				moduleAnimationFunctions[animationFunctionName](playerCopy.Humanoid.Animator)
			else
				print("ERROR: Invalid Animation Name")
			end
			
			
			spawnIndex += 1
		end
	end
	
	
	local enemyUnitsStorage = Instance.new("Folder")
	enemyUnitsStorage.Name = "EnemyUnits"
	enemyUnitsStorage.Parent = unitsStorage
	local spawnIndex = 1
	for nameUnitID, unitID in thisEncounter["Teams"]["Enemyside"] do
		local thisUnit = thisEncounter["Units"][unitID]
		if thisEncounter["Units"][unitID]["UnitData"]["UnitType"] == "EnemyAI" then
			local unitModel = game.ServerStorage.Models.UnitModels:FindFirstChild(thisUnit["UnitData"]["Model"])
			if not unitModel then
				print("ERROR: Unit Model Missing")
				continue -- TODO: add a fallback unit model
			end
			local physicalUnit = unitModel:Clone()

			
			physicalUnit:PivotTo(enemySpawn["Spawn"..spawnIndex].WorldCFrame * CFrame.Angles(0, math.rad(90), 0))
			physicalUnit.Parent = enemyUnitsStorage
			physicalUnit.HumanoidRootPart.Anchored = true
			
			thisEncounter["Units"][unitID]["UnitData"]["WorkspaceInstance"] = physicalUnit
			
			local animationFunctionName = thisUnit["Animations"]["Idle"] or nil
			print(animationFunctionName)
			if animationFunctionName then
				moduleAnimationFunctions[animationFunctionName](physicalUnit.Humanoid.Animator)
			else
				print("ERROR: Invalid Animation Name")
			end
			
			spawnIndex += 1
		end
	end
	
end

function unloadAllUnits()
	game.Workspace:FindFirstChild("Units"):Destroy()
end

function endEncounter(encounterID)
	
	unloadCurrentMap()
	TBSystems.encounterData[encounterID] = nil
	unloadAllUnits()
end

return TBSystems

-- maybe in the future revamp this whole system to allow for multiple simultaneous encounters, let parties split up or something along those lines. some groundwork for it it there, but only like 10% of it, adjust to make it work if you do plan on doing that
-- lots of the stuff i just did now with the rendering map, camera, and unit spawning, needs to be changed if you do want to do that
-- they assume that the stuff are in the one consistent place at 0,0 and in the same workspace spots.

--TODO: fix the reliance of humanoid instances in the unit model