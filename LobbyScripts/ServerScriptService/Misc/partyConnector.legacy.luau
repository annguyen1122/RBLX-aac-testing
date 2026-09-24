local modulePreCampaignData = require(game.ServerScriptService.ModuleScripts.PreCampaignData)

game.ReplicatedStorage.RemoteEvents.inputParty.OnServerEvent:Connect(function(playerWhoCalled, param1, param2)
	
	if param1 == "CreateParty" then
		-- TODO: a check if they're already in one
		
		modulePreCampaignData.CreateParty(playerWhoCalled.UserId)
	end
	
end)

game.ReplicatedStorage.RemoteEvents.startCampaign.OnServerEvent:Connect(function(playerWhoCalled)
	
	modulePreCampaignData.startCampaign(playerWhoCalled)
end)