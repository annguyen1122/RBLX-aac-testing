local moduleClassData = require(game.ServerScriptService.Modules.classData)
local moduleItemsData = require(game.ServerScriptService.Modules.ItemsData)

local playerStats = {}

playerStats.SavedPlayerStats = {}

function playerStats.CreateBaseStats(PlayerID)
	-- save the sh into savedplayerstats
	
	--check if it exists already
	if playerStats.SavedPlayerStats[PlayerID] ~= nil then
		error("Base Player Stats Already Set")
	end
	
	playerStats.SavedPlayerStats[PlayerID] = {}
	
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"] = {}
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"] = {}
	
	-- similar to barony, these stats affect the other skills slightly, with different scalings based off it. it'll have a small but noticable impact, acting as essentially a headstart on those skills. the skills will have their own specialized way to level them up in addition to core ability score, for better specialization. tldr, ability score is general skills, and skill points are specialized for that skill.
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"]["Strength"] = 0 --phys damage (make it so certain bows have strength requirements too)
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"]["Dexterity"] = 0 -- ranged damage cause precision, also crit chance too. balance ranged weapons to keep this in mind that both stats are affected.
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"]["Constitution"] = 0 -- health, mostly health, and resistances
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"]["Intelligence"] = 0 -- learning spells more easier, and having more spell slots or spell inventory, cause higher int means remember more. better appraisal skills, n stuff
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"]["Wisdom"] = 0 -- 
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["AbilityScores"]["Charisma"] = 0 -- bargaining chances (make a minigame later for it, and have it reliant on luck cause it feels off for it to be consistant. call for a lower price, the lower it is, the lower the chance, you get like a couple attempts, but it's random the amount before the trader locks a price)
	
	
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["MainStats"] = {}
	playerStats.SavedPlayerStats[PlayerID]["BaseStats"]["MainStats"]["MaxHealth"] = 100
	
	playerStats.SavedPlayerStats[PlayerID]["Class"] = "Unselected"
	
	playerStats.SavedPlayerStats[PlayerID]["Abilities"] = {}
	playerStats.SavedPlayerStats[PlayerID]["Abilities"]["InnateAbilities"] = {} -- abilities that aren't linked to any class or weapon or anything. special case compared to the others since it's probably only tracked here. it's a misc slot kinda.
	playerStats.SavedPlayerStats[PlayerID]["Abilities"]["ClassAbilities"] = {}
	playerStats.SavedPlayerStats[PlayerID]["Abilities"]["EquipmentAbilities"] = {} -- clears and reassigns whenever a weapon or armor is unequipped.
	
	playerStats.SavedPlayerStats[PlayerID]["Inventory"] = {}
	
	playerStats.SavedPlayerStats[PlayerID]["Equipped"] = {}
	playerStats.SavedPlayerStats[PlayerID]["Equipped"]["PrimaryWeapon"] = {}
	
end

function playerStats.ModifyStat(PlayerID, StatName)
	
end

function playerStats.AssignClassStats(PlayerID, Class)
	local thisPlayerStats = playerStats.SavedPlayerStats[PlayerID]
	local thisClassData = moduleClassData.PlayerClasses[Class]
	
	thisPlayerStats["BaseStats"] = {}
	
	thisPlayerStats["BaseStats"]["AbilityScores"] = {}
	thisPlayerStats["BaseStats"]["AbilityScores"]["Strength"] = thisClassData["RawStats"]["AbilityScores"]["Strength"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Dexterity"] = thisClassData["RawStats"]["AbilityScores"]["Dexterity"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Constitution"] = thisClassData["RawStats"]["AbilityScores"]["Constitution"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Intelligence"] = thisClassData["RawStats"]["AbilityScores"]["Intelligence"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Wisdom"] = thisClassData["RawStats"]["AbilityScores"]["Wisdom"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Charisma"] = thisClassData["RawStats"]["AbilityScores"]["Charisma"]


	thisPlayerStats["BaseStats"]["MainStats"] = {}
	thisPlayerStats["BaseStats"]["MainStats"]["MaxHealth"] = ((thisPlayerStats["BaseStats"]["AbilityScores"]["Constitution"]) * 10) -- Max Health Calculation, con * 10 -- TODO: add a function at some point to recalculate the max health with all the modifiers all at once, for other possible variables for the max health.
	
	
	thisPlayerStats["Class"] = Class
	
	-- adds the classabilitys to the list, not overwrite.
	for abilityName, abilityID in thisClassData["ClassAbilities"] do
		thisPlayerStats["Abilities"]["ClassAbilities"][abilityName] = abilityID
	end
	
	--TODO: later change the abilities to update with a seperate function, whenever the weapon is changed. call that function here. Same goes with the animation stuff you did earlier that you left as placeholder
	local primaryWeaponID = thisClassData["BaseEquipment"]["PrimaryWeapon"]
	thisPlayerStats["Equipped"]["PrimaryWeapon"] = primaryWeaponID
	if moduleItemsData[primaryWeaponID] then
		for abilityName, abilityID in moduleItemsData[primaryWeaponID]["EquipmentAbilities"] do
			thisPlayerStats["Abilities"]["EquipmentAbilities"][abilityName] = abilityID
		end
	end
	
	for i, v in thisClassData["BaseEquipment"]["Inventory"] do
		table.insert(thisPlayerStats["Inventory"], v)
	end
	
	
end

-- for use in encounters, in the TBSystems
function playerStats.GetPlayerUnitStats(PlayerID)
	local returningPlayerUnitStats = {}
	
	local thisPlayerStats = playerStats.SavedPlayerStats[PlayerID]

	returningPlayerUnitStats = {
		["UnitData"] = {
			["UnitType"] = "Player", -- Player / FriendlyAI / EnemyAI,
			["PlayerID"] = PlayerID,
			["UnitName"] = game:GetService("Players"):GetPlayerByUserId(PlayerID).Name, --TODO: fix potential nil error here
			["DeathStatus"] = "Alive"	
		},
	
		["Stats"] = {
			["MaxHealth"] = thisPlayerStats["BaseStats"]["MainStats"]["MaxHealth"],
			["Health"] = thisPlayerStats["BaseStats"]["MainStats"]["MaxHealth"]
		},
		["Animations"] = {
			["Death"] = "placeholderDeath", -- TODO: replace this later
			["Idle"] = "swordIdle" -- also replace later
		}
	}
	
	returningPlayerUnitStats["Actions"] = {}
	-- later can add different code for each subsection, for now just treat all equally.
	for i, subSection in thisPlayerStats["Abilities"] do
		for abilityName, abilityID in subSection do
			returningPlayerUnitStats["Actions"][abilityName] = abilityID 
		end
	end
	
	returningPlayerUnitStats["Equipment"] = {}
	returningPlayerUnitStats["Equipment"]["PrimaryWeapon"] = thisPlayerStats["Equipped"]["PrimaryWeapon"]
	
	returningPlayerUnitStats["AbilityScores"] = {}
	for i, v in thisPlayerStats["BaseStats"]["AbilityScores"] do
		returningPlayerUnitStats["AbilityScores"][i] = v
	end
	
	return returningPlayerUnitStats
	
end


function playerStats.updatePlayerInventory(playerID)
	local playerStatsData = playerStats.SavedPlayerStats[playerID]
	
	local playerInstance = game.Players:GetPlayerByUserId(playerID)
	game.ReplicatedStorage.RemoteEvents.PlayerInventory.UpdatePlayerInventory:FireClient(playerInstance, playerStatsData)
end


--TODO: add a check so that players can't access their inventory mid combat if a bug or exploiter occurs.
function playerStats.equipItemFromInventory(playerID, inventoryID)
	local thisPlayerStats = playerStats.SavedPlayerStats[playerID]
	
	
	
	local thisItemId = thisPlayerStats["Inventory"][inventoryID]
	local itemInfo = moduleItemsData[thisItemId]
	
	
	print(itemInfo)
	if itemInfo["ItemType"] == "Consumable" then
		print("consumable used code")
		table.remove(thisPlayerStats.Inventory, inventoryID)
	elseif itemInfo["ItemType"] == "PrimaryWeapon" then
		table.insert(thisPlayerStats.Inventory, thisPlayerStats.Equipped["PrimaryWeapon"])
		thisPlayerStats.Equipped["PrimaryWeapon"] = thisItemId
		table.remove(thisPlayerStats.Inventory, inventoryID)
	end
	
	
	playerStats.updatePlayerInventory(playerID)
end

return playerStats
