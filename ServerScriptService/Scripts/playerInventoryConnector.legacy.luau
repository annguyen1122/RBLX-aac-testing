
local modulePlayerStats = require(game.ServerScriptService.Modules.playerStats)

game.ReplicatedStorage.RemoteEvents.PlayerInventory.EquipItemFromInventory.OnServerEvent:Connect(function(playerFired, itemID)
	modulePlayerStats.equipItemFromInventory(playerFired.UserId, itemID)
end)