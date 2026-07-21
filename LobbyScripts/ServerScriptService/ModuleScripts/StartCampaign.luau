local DataStoreService = game:GetService("DataStoreService") -- TODO: make sure that these datastores dont get too many requests, there needs to be a checker if the user is putting in too many requests

local StartCampaign = {}


local myselfPlayer = game.Players:FindFirstChild("11annguyen")
local campaignID = game:GetService("HttpService"):GenerateGUID()
local debugCampaignStart = {
	
	
	
}


function StartCampaign.startCampaign(host, isParty)
	
	-- check if it's a party or solo
	
	--if solo, then start campaign with the player's data
	
	--if party, check the party members linked to the host, then get each of those player's data to send
	
	
	
end



return StartCampaign
