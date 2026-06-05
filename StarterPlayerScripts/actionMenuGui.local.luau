
local moduleGuiHandler = require(game.ReplicatedStorage.Modules.Gui.GuiHandler)

game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnClientEvent:Connect(function(actionsData)
	
	moduleGuiHandler.actionMenu(actionsData)
	
end)