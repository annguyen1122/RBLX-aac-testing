-- the more general systems to hook everything up together
local MemoryStoreService = game:GetService("MemoryStoreService")


local EncounterSystems = {}

EncounterSystems.PlayerList = {22078642} -- FOR TESTING THIS WILL HAVE SOMETHING PRESET

-- sets the player list according to the teleport data of the first player's access code
function EncounterSystems.GetPlayerList(accessCode)
	if not EncounterSystems.PlayerList then
		local accessCodeData = MemoryStoreService:GetHashMap("CampaignHashMap"):GetAsync(accessCode)
		print(accessCodeData[1])
		EncounterSystems.PlayerList = accessCodeData
	end
	return EncounterSystems.PlayerList
end

-- run once
function EncounterSystems.JoiningPlayersPlayerList()
	game:GetService("Players").PlayerAdded:Connect(function(joiningPlayer)
		local joinData = joiningPlayer:GetJoinData()
		local accessCode = joinData.TeleportData
		--accessCode = "TEST"
		local playerList = EncounterSystems.GetPlayerList(accessCode)
	end)

end

function EncounterSystems.ReadyCheck()
	
end

return EncounterSystems
