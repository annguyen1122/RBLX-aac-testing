local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData")
local PlayerService = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HTTPService = game:GetService("HttpService")
local MemoryStoreService = game:GetService("MemoryStoreService")

local PreCampaignData = {}

PreCampaignData.PlayerData = {
	LoadedDataStore = {}
}

local loadedPlayerDataStore = PreCampaignData.PlayerData.LoadedDataStore

PreCampaignData.PartyData = {}
PreCampaignData.AssignedParty = {}
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
	--TODO: add that check
	
	
	--set up the party data with the host
	local partyUID = HTTPService:GenerateGUID()
	PreCampaignData.PartyData[partyUID] = {}
	PreCampaignData.PartyData[partyUID]["HostPlayer"] = HostPlayerID
	PreCampaignData.PartyData[partyUID]["Members"] = {}
	table.insert(PreCampaignData.PartyData[partyUID]["Members"], HostPlayerID)
	PreCampaignData.AssignedParty[HostPlayerID] = partyUID
end

-- adds player to the party
-- TODO: add a check later to make sure the host is inviting, etc. cause if not there'd potentially a bug of joining a different party after sending out an invite and then the invite leads to the new party. not a high priority for me tho.
function PreCampaignData.PartyAdd(HostPlayerID, AddPlayerID)
	local partyUID = PreCampaignData.AssignedParty[HostPlayerID]
	
	table.insert(PreCampaignData.PartyData[partyUID]["Members"], AddPlayerID)
	PreCampaignData.AssignedParty[HostPlayerID] = partyUID
end

function PreCampaignData.GetParty(PlayerID)
	-- using the id, get all the party member's id.
	local partyUID = PreCampaignData.AssignedParty[PlayerID]
	
	local partyData = PreCampaignData.PartyData[partyUID]
	return partyData
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

function teleportPlayers(playerList)

	
	
	-- reserves a server for the group
	local accessCode
	local success, result = pcall(function()
		accessCode = TeleportService:ReserveServerAsync(110918852730713)
	end)
	if success then
		print("reserve success")
	else
		accessCode = "" -- remove later
		print("reserve failed")
	end
	
	local teleportingPlayerIDs = {} -- stores the player list for readycheck/loading wait for all.
	
	--teleports all the players
	for i, indivPlayer in playerList do
		--save chosen class before TP
		PreCampaignData.SaveDataStore(indivPlayer.UserId)	

		table.insert(teleportingPlayerIDs, indivPlayer.UserId) -- adds playerId to the list to send later.

		--accessCode = "TEST" --FOR DEBUGGING, REMOVE LATER
		print(indivPlayer, teleportingPlayerIDs)

		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.ReservedServerAccessCode = accessCode
		teleportOptions:SetTeleportData(accessCode)

		local success, result = pcall(function()
			TeleportService:TeleportAsync(110918852730713, indivPlayer, teleportOptions)
		end)
		if success then
			print("teleport success")
		else
			print("teleport failed")
			--TODO: add a teleport again attempt here, or the option to at least.
		end
	end
	
	-- sends to the server a list of the players expected to join, using accessCode as the key to find it.
	local sentData = MemoryStoreService:GetHashMap("CampaignHashMap")
	sentData:SetAsync(accessCode, teleportingPlayerIDs, 180)
	print(sentData)
	
end

function PreCampaignData.startCampaign(playerWhoCalled)
	
	local partyData = PreCampaignData.GetParty(playerWhoCalled.UserId)
	if partyData["HostPlayer"] == playerWhoCalled.UserId then
		
		
	
		
		
		
	end
	
end


return PreCampaignData


