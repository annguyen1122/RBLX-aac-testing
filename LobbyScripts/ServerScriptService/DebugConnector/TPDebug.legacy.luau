
local moduleStartCampaign = require(game.ServerScriptService.ModuleScripts.StartCampaign)
local modulePreCampaignData = require(game.ServerScriptService.ModuleScripts.PreCampaignData)

local PlayerService = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local MemoryStoreService = game:GetService("MemoryStoreService")
local DataStoreService = game:GetService("DataStoreService")
local playerDataStore = DataStoreService:GetDataStore("PlayerData")


--update player data on join
PlayerService.PlayerAdded:Connect(function(joiningPlayer)
	modulePreCampaignData.LoadDataStore(joiningPlayer.UserId)
end)


game.ReplicatedStorage.DebugRE.DebugTrigger.OnServerEvent:Connect(function(playerWhoCalled)
	
	print("run")
	--save chosen class before TP
	modulePreCampaignData.SaveDataStore(playerWhoCalled.UserId)
	
	local teleportingPlayer = {playerWhoCalled}	
	
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
	
	
	local teleportingPlayerIDs = {}
	for i, v in teleportingPlayer do
		table.insert(teleportingPlayerIDs, v.UserId)
	end

	--accessCode = "TEST" --FOR DEBUGGING, REMOVE LATER

	print(teleportingPlayer, teleportingPlayerIDs)
	local sentData = MemoryStoreService:GetHashMap("CampaignHashMap")
	sentData:SetAsync(accessCode, teleportingPlayerIDs, 180)
	
	print(sentData)
	
	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ReservedServerAccessCode = accessCode
	teleportOptions:SetTeleportData(accessCode)

	
	local success, result = pcall(function()
		TeleportService:TeleportAsync(110918852730713, teleportingPlayer, teleportOptions)
	end)
	if success then
		print("teleport success")
	else
		print("teleport failed")
	end
	
end)