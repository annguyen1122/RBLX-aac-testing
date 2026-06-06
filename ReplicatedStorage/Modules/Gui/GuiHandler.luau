local GuiHandler = {}

function GuiHandler.actionMenu(actionsData)
	
	print(actionsData)
	
	local newActionGui = game.ReplicatedStorage.Gui.prototypeActionSelect:Clone()
	
	for actionName,actionFunction in actionsData do
		local actionButton = newActionGui.Frame.ScrollingFrame.TemplateButton:Clone()
		actionButton.Text = actionName
		actionButton.Visible = true
		actionButton.Parent = newActionGui.Frame.ScrollingFrame
		actionButton.Activated:Connect(function()
			game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireServer("openSubmenuTargeting", actionFunction)
		end)
	end
	newActionGui.Parent =  game.Players.LocalPlayer.PlayerGui
	
end

function GuiHandler.openSubmenuTargeting(validTargets, actionFunction)
	print(validTargets)

	local newSubmenu = game.ReplicatedStorage.Gui.prototypeActionSelect.Frame.TemplateSubmenu:Clone()

	for targetId,targetData in validTargets do
		local actionButton = newSubmenu.ScrollingFrame.TemplateButton:Clone()
		actionButton.Text = targetData["UnitData"]["UnitName"]
		actionButton.Visible = true
		actionButton.Parent = newSubmenu.ScrollingFrame
		actionButton.Activated:Connect(function()
			game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireServer("performAction", actionFunction, targetId)--remember this for later, but sending the validtarget data through this doesnt send the original reference to these values, instead use the targetID to call from the original dictionary
		end)
	end
	
	newSubmenu.Visible = true
	newSubmenu.Parent =  game.Players.LocalPlayer.PlayerGui.prototypeActionSelect.Frame --make this more safe, cause rn it's assuming there is a prototypeactionselect
end
-- later rewrite this, maybe a better approach might be to instead call the server for validtargets data and handle the gui locally, instead of passing the values to server to pass back to client with more data.
-- oh and properly rename validtargets to be validenemytargets


return GuiHandler


--later when you're not busy, go through each of these possible inputs and make sure exploits aren't possible