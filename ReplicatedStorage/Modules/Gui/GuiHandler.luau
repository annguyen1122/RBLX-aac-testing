local GuiHandler = {}

local moduleTurnHelper = require(game.ReplicatedStorage.Modules.helpers.turnHelper)
local moduleActionsData = require(game.ReplicatedStorage.Modules.ReplicatedData.actionsData)

function GuiHandler.actionMenu(actionOptions, encounterData)
	
	
	local newActionGui = game.ReplicatedStorage.Gui.prototypeActionSelect:Clone()
	
	for actionName,actionInternalName in actionOptions do
		local actionButton = newActionGui.Frame.ScrollingFrame.TemplateButton:Clone()
		actionButton.Text = actionName
		actionButton.Visible = true
		actionButton.Parent = newActionGui.Frame.ScrollingFrame
		actionButton.Activated:Connect(function()
			if newActionGui.Frame:FindFirstChild("submenuTargeting") then
				GuiHandler.closeSubmenuTargeting()
				GuiHandler.closeHighlightTargeting(encounterData)
			else
				local targetOptions
				if moduleActionsData.generalActions[actionInternalName]["actionTargeting"] == "enemyTargeting" then
					targetOptions = moduleTurnHelper.getAllAliveTeamUnits("Enemyside", encounterData)
				end
				openSubmenuTargeting(targetOptions, actionInternalName)
				openHighlightTargeting(targetOptions, actionInternalName)
			end
		end)
	end
	newActionGui.Parent =  game.Players.LocalPlayer.PlayerGui
	
end


function openSubmenuTargeting(validTargets, actionInternalName)

	local newSubmenu = game.ReplicatedStorage.Gui.prototypeActionSelect.Frame.TemplateSubmenu:Clone()
	

	
	for targetId,targetData in validTargets do
		local actionButton = newSubmenu.ScrollingFrame.TemplateButton:Clone()
		actionButton.Text = targetData["UnitData"]["UnitName"]
		actionButton.Visible = true
		actionButton.Parent = newSubmenu.ScrollingFrame
		actionButton.Activated:Connect(function()
			game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireServer("performAction", actionInternalName, targetId)--remember this for later, but sending the validtarget data through this doesnt send the original reference to these values, instead use the targetID to call from the original dictionary
		end)
	end
	
	newSubmenu.Visible = true
	newSubmenu.Name = "submenuTargeting"
	newSubmenu.Parent =  game.Players.LocalPlayer.PlayerGui.prototypeActionSelect.Frame --make this more safe, cause rn it's assuming there is a prototypeactionselect
end
-- later rewrite this, maybe a better approach might be to instead call the server for validtargets data and handle the gui locally, instead of passing the values to server to pass back to client with more data.
-- oh and properly rename validtargets to be validenemytargets

--alternative to submenu targeting, click enemies directly.
function openHighlightTargeting(validTargets, actionInternalName)


	for targetId,targetData in validTargets do
		local targetWorkspaceInstance = targetData["UnitData"]["WorkspaceInstance"]
		
		local newHighlight = Instance.new("Highlight")
		newHighlight.FillTransparency = 1
		newHighlight.Parent = targetWorkspaceInstance
		
		local newClickDetector = Instance.new("ClickDetector")
		newClickDetector.MaxActivationDistance = 999999
		newClickDetector.Parent = targetWorkspaceInstance
		
		newClickDetector.MouseClick:Connect(function()
			game.ReplicatedStorage.RemoteEvents.Gui.actionMenu:FireServer("performAction", actionInternalName, targetId)
		end)
		
		newClickDetector.MouseHoverEnter:Connect(function()
			newHighlight.FillTransparency = 0.5
		end)
		
		newClickDetector.MouseHoverLeave:Connect(function()
			newHighlight.FillTransparency = 1
		end)
		
	end
	
end

function GuiHandler.closeSubmenuTargeting()
	local submenu = game.Players.LocalPlayer.PlayerGui.prototypeActionSelect.Frame["submenuTargeting"]
	submenu:Destroy()
end

function GuiHandler.closeHighlightTargeting(encounterData)
	for unitID,unitData in encounterData["Units"] do
		local targetWorkspaceInstance = unitData["UnitData"]["WorkspaceInstance"]
		
		if targetWorkspaceInstance:FindFirstChild("Highlight") then
			targetWorkspaceInstance:FindFirstChild("Highlight"):Destroy()
		end
		if targetWorkspaceInstance:FindFirstChild("ClickDetector") then
			targetWorkspaceInstance:FindFirstChild("ClickDetector"):Destroy()
		end
	end
end

--assumes actionmenu exists
function GuiHandler.closeActionMenu()
	game.Players.LocalPlayer.PlayerGui.prototypeActionSelect:Destroy()
end


function GuiHandler.loadRouteChoices()
	local newActionGui = game.ReplicatedStorage.Gui.RouteChoices:Clone()
	
	local actionButton = newActionGui.Frame.Option
	actionButton.Activated:Connect(function()
		
		
	end)
	
	newActionGui.Parent =  game.Players.LocalPlayer.PlayerGui

end


return GuiHandler
--later when you're not busy, go through each of these possible inputs and make sure exploits aren't possible