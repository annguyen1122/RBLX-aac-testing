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
			game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireServer(actionFunction)
		end)
	end

	newActionGui.Parent =  game.Players.LocalPlayer.PlayerGui
	
end



return GuiHandler
