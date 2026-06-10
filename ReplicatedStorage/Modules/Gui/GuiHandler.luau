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
				closeSubmenuTargeting()
			else
				local targetOptions
				if moduleActionsData.generalActions[actionInternalName]["actionTargeting"] == "enemyTargeting" then
					targetOptions = moduleTurnHelper.getAllAliveTeamUnits("Enemyside", encounterData)
				end
				openSubmenuTargeting(targetOptions, actionInternalName)
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

function closeSubmenuTargeting()
	local submenu = game.Players.LocalPlayer.PlayerGui.prototypeActionSelect.Frame["submenuTargeting"]
	submenu:Destroy()
end

--assumes actionmenu exists
function GuiHandler.closeActionMenu()
	game.Players.LocalPlayer.PlayerGui.prototypeActionSelect:Destroy()
end

return GuiHandler


--later when you're not busy, go through each of these possible inputs and make sure exploits aren't possible