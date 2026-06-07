
local moduleGuiHandler = require(game.ReplicatedStorage.Modules.Gui.GuiHandler)

game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnClientEvent:Connect(function(request, arg1, arg2)
	
	if request == "openActionMenu" then
		local actionsData = arg1
		moduleGuiHandler.actionMenu(actionsData)
	elseif request == "openSubmenuTargeting" then
		local validEnemyTargetList = arg1
		local actionFunction = arg2
		moduleGuiHandler.openSubmenuTargeting(validEnemyTargetList, actionFunction)
	elseif request == "closeActionMenu" then
		moduleGuiHandler.closeActionMenu()
	end
	
end)