
local moduleGuiHandler = require(game.ReplicatedStorage.Modules.Gui.GuiHandler)

game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnClientEvent:Connect(function(request, arg1, arg2)
	
	if request == "openActionMenu" then
		local actionsData = arg1
		local encounterData = arg2
		moduleGuiHandler.actionMenu(actionsData, encounterData)
	elseif request == "closeActionMenu" then
		moduleGuiHandler.closeActionMenu()
	elseif request == "respondValidTargets" then
		local validEnemyTargetList = arg1
		local actionInternalName = arg2
		moduleGuiHandler.openSubmenuTargeting(validEnemyTargetList, actionInternalName)
	end
	
end)