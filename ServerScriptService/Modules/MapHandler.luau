local PlayersService = game:GetService("Players")

local mapHandler = {}

function mapHandler.loadMap(mapCategory, mapName)
	local newMap = game.ServerStorage.Maps[mapCategory][mapName]:Clone()
	newMap.Parent = game.Workspace.CurrentMap
end

function mapHandler.loadMapFromCategory(mapCategory)
	local mapList = game.ServerStorage.Maps[mapCategory]:GetChildren()
	local selectedMap = mapList[math.random(1, #mapList)]
	local loadedMap = selectedMap:Clone()
	loadedMap.Parent = game.Workspace.CurrentMap
end

--technically unloads all maps, but only one map should be loaded at a time
function mapHandler.unloadCurrentMap()
	for i, v in game.Workspace.CurrentMap:GetChildren() do
		v:Destroy()
	end
end

function mapHandler.setPlayersCamera(allUnits)
	for unitID, unitData in allUnits do
		if unitData["UnitData"]["UnitType"] == "Player" then
			local thisPlayer = PlayersService:GetPlayerByUserId(unitData["UnitData"]["PlayerID"])
			game.ReplicatedStorage.RemoteEvents.Gui.setCamera:FireClient(thisPlayer)
		end
	end

end


return mapHandler
