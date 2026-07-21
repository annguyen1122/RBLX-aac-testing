local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData")
local PlayerService = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local PreCampaignData = {}

PreCampaignData.PlayerData = {
	LoadedDataStore = {}
}

local loadedPlayerDataStore = PreCampaignData.PlayerData.LoadedDataStore

--update player data on join
PlayerService.PlayerAdded:Connect(function(joiningPlayer)

end)

function PreCampaignData.CreatePlayerData()
	-- create the space for the data to be placed in later, store in playerID
end

function PreCampaignData.GetPlayerData(PlayerID)
	--gives the data that's selected
end

function PreCampaignData.UpdatePlayerData()
	--updates a value from the default
	
	--options are here, but first thing's first, do the class the player selects
end


-- not sure if this should be a seperate system, but putting it here
function PreCampaignData.CreateParty(HostPlayerID)
	--check if one already exists
	
	--set up the party data with the host
end

-- adds player to the party
function PreCampaignData.PartyAdd(HostPlayerID, AddPlayerID)
	
end

function PreCampaignData.GetParty(HostPlayerID)
	-- using the id, get all the party member's id.
end

function PreCampaignData.SetClass(PlayerID, ClassName)
	loadedPlayerDataStore[PlayerID]["ChosenClass"] = ClassName
end

function PreCampaignData.LoadDataStore(PlayerID)
	local success, joiningPlayerDataStore = pcall(function()
		return playerDataStore:GetAsync(PlayerID)
	end)
	if success then
		-- empty save
		if joiningPlayerDataStore == nil then
			local defaultSave = {
				["ChosenClass"] = "Blademaster"
			}
			print("Empty Save, Setting Default")
			joiningPlayerDataStore = defaultSave

			local success, result = pcall(function()
				playerDataStore:SetAsync(PlayerID, defaultSave)
			end)
			if not success then
				warn("Setting Default Save Failed", result)
			else
				print("Save Successful")
			end
		end
		print("Load Successful")
	else
		warn("Player Data Load Failed")
	end
	loadedPlayerDataStore[PlayerID] = joiningPlayerDataStore
end

function PreCampaignData.SaveDataStore(PlayerID)
	
	local success, result = pcall(function()
		playerDataStore:SetAsync(PlayerID, loadedPlayerDataStore[PlayerID])
	end)
	if not success then
		warn("Updating Player Save Failed", result)
	else
		print("Save Successful")
	end
end


return PreCampaignData


