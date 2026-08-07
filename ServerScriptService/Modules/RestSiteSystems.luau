local modulePlayerStats = require(game.ServerScriptService.Modules.playerStats)
local moduleMapHandler = require(game.ServerScriptService.Modules.MapHandler)

local PlayersService = game:GetService("Players")


local RestSiteSystems = {}


-- not going to be that useful since i think i might just have the same camera angle for both
function setAllPlayersCamera()

	for playerID, playerData in modulePlayerStats.SavedPlayerStats do
		local thisPlayer = PlayersService:GetPlayerByUserId(playerID)
		game.ReplicatedStorage.RemoteEvents.Gui.setCamera:FireClient(thisPlayer)
	end

end

function RestSiteSystems.loadRestSiteMapAllPlayers()
	setAllPlayersCamera()
	moduleMapHandler.loadMap("RestSite")
end

function RestSiteSystems.unloadRestSiteMap()
	moduleMapHandler.unloadCurrentMap()
end

return RestSiteSystems
