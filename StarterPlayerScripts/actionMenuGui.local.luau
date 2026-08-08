--
local moduleGuiHandler = require(game.ReplicatedStorage.Modules.Gui.GuiHandler)

game.ReplicatedStorage.RemoteEvents.Gui.actionMenu.OnClientEvent:Connect(function(request, arg1, arg2)
	
	if request == "openActionMenu" then
		local actionsData = arg1
		local encounterData = arg2
		moduleGuiHandler.actionMenu(actionsData, encounterData)
	elseif request == "closeActionMenu" then
		local encounterData = arg1
		moduleGuiHandler.closeActionMenu()
		moduleGuiHandler.closeHighlightTargeting(encounterData)
	elseif request == "respondValidTargets" then
		local validEnemyTargetList = arg1
		local actionInternalName = arg2
		moduleGuiHandler.openSubmenuTargeting(validEnemyTargetList, actionInternalName)
	end
	
end)

game.ReplicatedStorage.RemoteEvents.LoadGUI.AllPlayersLoadRouteChoices.OnClientEvent:Connect(function(optionsList)
	
	moduleGuiHandler.loadRouteChoices(optionsList)
	
	
end)

game.ReplicatedStorage.RemoteEvents.Gui.encounterStart.OnClientEvent:Connect(function()
	
	moduleGuiHandler.InitializeStatDisplay()
	
end)

game.ReplicatedStorage.RemoteEvents.Gui.setCamera.OnClientEvent:Connect(function()
	local camera = game.Workspace.Camera
	camera.CameraType = Enum.CameraType.Scriptable

	local cFrame = CFrame.new(Vector3.new(0, 120, 30), Vector3.new(0, 100, 0))
	camera.CFrame = cFrame
end)
