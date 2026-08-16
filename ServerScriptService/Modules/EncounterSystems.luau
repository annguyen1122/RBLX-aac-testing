-- the more general systems to hook everything up together
-- probably rename it to campaign systems
local MemoryStoreService = game:GetService("MemoryStoreService")

local moduleTBSystems = require(game.ServerScriptService.Modules.TBSystems)
local moduleRestSiteSystems = require(game.ServerScriptService.Modules.RestSiteSystems)
local moduleRouteHandler = require(game.ServerScriptService.Modules.RouteHandler)

local EncounterSystems = {}

EncounterSystems.PlayerList = {22078642} -- TODO: FOR TESTING THIS FOR NOW WILL HAVE SOMETHING PRESET
--EncounterSystems.PlayerList = {-1, -2}

function EncounterSystems.gameLaunch()
	
	moduleRouteHandler.SetMapDebugDefault()

	EncounterSystems.JoiningPlayersPlayerList() -- for getting the playerlist in the system for the ready check
	wait(3) -- this is the fake ready check, so i'll add it later
	
	campaignLoop()

end

-- sets the player list according to the teleport data of the first player's access code
function EncounterSystems.GetPlayerList(accessCode)
	if not EncounterSystems.PlayerList then
		local accessCodeData = MemoryStoreService:GetHashMap("CampaignHashMap"):GetAsync(accessCode)
		print(accessCodeData[1])
		EncounterSystems.PlayerList = accessCodeData
	end
	return EncounterSystems.PlayerList
end

-- run once
function EncounterSystems.JoiningPlayersPlayerList()
	game:GetService("Players").PlayerAdded:Connect(function(joiningPlayer)
		local joinData = joiningPlayer:GetJoinData()
		local accessCode = joinData.TeleportData
		--accessCode = "TEST"
		local playerList = EncounterSystems.GetPlayerList(accessCode)
	end)

end

function EncounterSystems.ReadyCheck()
	
end

function campaignLoop()
	
	while true do -- eventually add an end condition, or just break.
		wait(0.5) -- infinite loop safeguard
		local routeOption = restSite()
		
		EncounterSystems.LoadEncounter(routeOption)
	end
	
end

function restSite()
	moduleRestSiteSystems.loadRestSiteMapAllPlayers()
	-- wait for all players ready -- need to actually test this lol
	local playersReady = false
	local readyList = {}
	for i, v in EncounterSystems.PlayerList do
		readyList[v] = false
	end
	while playersReady == false do -- wait loop on player input until all players are ready
		local player, isReady = game.ReplicatedStorage.RemoteEvents.playerInput.ReadyChecks.restSiteEnd.OnServerEvent:Wait()
		readyList[player.UserId] = isReady
		
		-- check all in readyList if true, assume true then if any are false set to false.
		playersReady = true
		for i, v in readyList do
			if v == false then
				playersReady = false
				break
			end
		end
	end
	
	local returnRouteOption = displayRouteOptions()
	
	return returnRouteOption
end

function displayRouteOptions()
	
	local currentNode = moduleRouteHandler.CurrentNode
	local adjacentNodes = moduleRouteHandler.getAdjacentRoutes(currentNode)
	if adjacentNodes == nil then
		print("CAMPAIGN JOURNEY OVER, probably. no adjacent nodes.")
		return
	end
	local adjacentRoutes = moduleRouteHandler.getEventFromNodes(adjacentNodes)

	game.ReplicatedStorage.RemoteEvents.LoadGUI.AllPlayersLoadRouteChoices:FireAllClients(adjacentRoutes) -- load gui for routes
	
	local playerFired, choiceNum = game.ReplicatedStorage.RemoteEvents.playerInput.RouteChoices.VoteRouteChoice.OnServerEvent:Wait() -- TODO: right now it doesnt have vote functionality and assumes first player's choice. do that system later.

	local chosenNode = moduleRouteHandler.getNodeFromChoice(currentNode, choiceNum)
	local returnRouteOption = moduleRouteHandler.getEventFromNodes(chosenNode)

	moduleRouteHandler.UpdateCurrentNote(chosenNode)
	print("DESTINATION: NODE ", chosenNode)
	return returnRouteOption
end


function EncounterSystems.LoadEncounter(encounterListId)
	game.ReplicatedStorage.RemoteEvents.LoadGUI.AllPlayersLoadRouteChoices:FireAllClients(false) -- closes gui
	moduleRestSiteSystems.unloadRestSiteMap()
	moduleTBSystems.startEncounter(encounterListId)
end

function EncounterSystems.EncounterEnd()
	
end

function EncounterSystems.GetAdjacentChoices(currentNode)
	
	local adjacentNodes = moduleRouteHandler.ActiveRouteMap.Connections[currentNode]
	
	if adjacentNodes == nil then
		print("NO MORE AVAILABLE ROUTES")
	end
	
	local returnedAdjacentChoices = {}
	
	for i, v in adjacentNodes do
		table.insert(returnedAdjacentChoices, moduleRouteHandler.ActiveRouteMap.Nodes[v])
	end
	
	return returnedAdjacentChoices
end


return EncounterSystems
