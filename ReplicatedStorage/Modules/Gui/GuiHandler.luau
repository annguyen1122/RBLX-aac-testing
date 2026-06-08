local GuiHandler = {}

local moduleActionsData = require(game.ReplicatedStorage.Modules.ReplicatedData.actionsData)

function GuiHandler.actionMenu(actionOptions, encounterData)
	
	
	local newActionGui = game.ReplicatedStorage.Gui.prototypeActionSelect:Clone()
	
	for actionName,actionInternalName in actionOptions do
		local actionButton = newActionGui.Frame.ScrollingFrame.TemplateButton:Clone()
		actionButton.Text = actionName
		actionButton.Visible = true
		actionButton.Parent = newActionGui.Frame.ScrollingFrame
		actionButton.Activated:Connect(function()
			print(encounterData)
			local targetOptions
			if moduleActionsData.generalActions[actionInternalName]["actionTargeting"] == "enemyTargeting" then
				targetOptions = getAllTeamUnits("Enemyside", encounterData)
			end

			openSubmenuTargeting(targetOptions, actionInternalName)
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
	newSubmenu.Parent =  game.Players.LocalPlayer.PlayerGui.prototypeActionSelect.Frame --make this more safe, cause rn it's assuming there is a prototypeactionselect
end
-- later rewrite this, maybe a better approach might be to instead call the server for validtargets data and handle the gui locally, instead of passing the values to server to pass back to client with more data.
-- oh and properly rename validtargets to be validenemytargets


--assumes actionmenu exists
function GuiHandler.closeActionMenu()
	game.Players.LocalPlayer.PlayerGui.prototypeActionSelect:Destroy()
end

--find a way to put this so its not copied everywhere, maybe a modulescript somewhere
function getAllTeamUnits(desiredTeam, encounterData)
	local thisEncounter = encounterData
	local teamUnits = {}

	if desiredTeam == "Enemyside" then
		print(thisEncounter["Teams"])
		for teamID, unitID in thisEncounter["Teams"]["Enemyside"] do
			teamUnits[unitID] = thisEncounter["Units"][unitID]
		end
	elseif desiredTeam == "Playerside" then
		for teamID, unitID in thisEncounter["Teams"]["Playerside"] do
			teamUnits[unitID] = thisEncounter["Units"][unitID]
		end
	end

	print(teamUnits)
	return teamUnits
end


return GuiHandler


--later when you're not busy, go through each of these possible inputs and make sure exploits aren't possible