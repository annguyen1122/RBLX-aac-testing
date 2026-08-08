
local moduleEncounterSystems = require(game.ServerScriptService.Modules.EncounterSystems)

game:GetService("Players").PlayerAdded:Connect(function(playerJoined)

	wait(3) -- TODO: later set this up properly, to take into account player loadings
	game.ReplicatedStorage.RemoteEvents.Gui.setCamera:FireClient(playerJoined)

end)

moduleEncounterSystems.gameLaunch()



-- waiting system for every player to join
---- probably a ready system while you're at it

-- campaign start, probably a rest site at the beginning? maybe later copy slay the spire and add a starting bonus like neow

-- first encounter

-- rest site

-- repeat

-- later implement a map to control this flow
-- also store that map into a modulescript
-- name them routes so you dont get confused
