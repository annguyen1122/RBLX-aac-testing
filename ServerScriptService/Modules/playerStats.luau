local moduleClassData = require(game.ServerScriptService.Modules.classData)
local moduleItemsData = require(game.ServerScriptService.Modules.ItemsData)
local moduleEventsList = require(game.ServerScriptService.Modules.EventsList)

local playerStats = {}

playerStats.SavedPlayerStats = {}

-- for fallback values ig
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
	
	playerStats.SavedPlayerStats[PlayerID]["Class"] = "Unselected"
	
	playerStats.SavedPlayerStats[PlayerID]["Abilities"] = {}
	playerStats.SavedPlayerStats[PlayerID]["Abilities"]["InnateAbilities"] = {} -- abilities that aren't linked to any class or weapon or anything. special case compared to the others since it's probably only tracked here. it's a misc slot kinda.
	playerStats.SavedPlayerStats[PlayerID]["Abilities"]["ClassAbilities"] = {}
	playerStats.SavedPlayerStats[PlayerID]["Abilities"]["EquipmentAbilities"] = {} -- clears and reassigns whenever a weapon or armor is unequipped.
	
	playerStats.SavedPlayerStats[PlayerID]["Inventory"] = {}
	
	playerStats.SavedPlayerStats[PlayerID]["Equipped"] = {}
	local equipTypeList = {"PrimaryWeapon", "Head"}
	for i, equipType in equipTypeList do
		playerStats.SavedPlayerStats[PlayerID]["Equipped"][equipType] = "Empty"
	end
	
	
end

function playerStats.ModifyStat(PlayerID, StatName)
	
end

function playerStats.AssignClassStats(PlayerID, Class)
	local thisPlayerStats = playerStats.SavedPlayerStats[PlayerID]
	local thisClassData = moduleClassData.PlayerClasses[Class]
	
	--honestly should probably combine base stats and this function together
	-- dont run these, should have already been set up
	--thisPlayerStats["BaseStats"] = {}
	--thisPlayerStats["BaseStats"]["AbilityScores"] = {}

	local abilityScoreList = {"Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"}
	for i, abilityScore in abilityScoreList do
		thisPlayerStats["BaseStats"]["AbilityScores"][abilityScore] = thisClassData["RawStats"]["AbilityScores"][abilityScore]
	end

	updatePlayerStats(PlayerID)

	-- for stats that save between runs. probably just health. slay the spire -esque stuff.
	thisPlayerStats["PersistentStats"] = {}
	thisPlayerStats["PersistentStats"]["Health"] = thisPlayerStats["DynamicStats"]["MainStats"]["MaxHealth"]

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

-- updates all the player stats and calculates them based off the factors n stuff.
function updatePlayerStats(playerID)
	local thisPlayerStats = playerStats.SavedPlayerStats[playerID]
	

	local abilityScoreList = {"Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"}
	
	--to read after the values are calculated, from armor, etc and other values to calculate. the mutable stats basically.
	thisPlayerStats["DynamicStats"] = {}  -- it resets every time its updated, and recalculated accordingly.
	thisPlayerStats["DynamicStats"]["AbilityScores"] = {}

	for i, abilityScore in abilityScoreList do
		thisPlayerStats["DynamicStats"]["AbilityScores"][abilityScore] = thisPlayerStats["BaseStats"]["AbilityScores"][abilityScore]
	end
	
	thisPlayerStats["DynamicStats"]["DamageCalc"] = {}
	thisPlayerStats["DynamicStats"]["DamageCalc"]["Armor"] = 0
	
	--^^ base values, set in places before they're calculated to be later calculated.
	
	-- calculate all the equipment's modifiers
	for i, itemEquipmentId in thisPlayerStats.Equipped do
		local itemEquipment = moduleItemsData[itemEquipmentId]
		if itemEquipmentId ~= "Empty" and itemEquipment["Modifiers"] then--if the item has modifiers
			for modifierName, value in itemEquipment["Modifiers"] do
				if modifierName == "Armor" then
					thisPlayerStats["DynamicStats"]["DamageCalc"]["Armor"] += value
				elseif modifierName == "Constitution" then -- probably add another loop here to go through the ability scores, instead of repeating one by one. for now, just do it for con and strength.
					thisPlayerStats["DynamicStats"]["AbilityScores"]["Constitution"] += value
				end
			end
		end
	end
	
	-- apply the stats to actual stuff, cause some stats rely on other stats.
	thisPlayerStats["DynamicStats"]["MainStats"] = {}
	thisPlayerStats["DynamicStats"]["MainStats"]["MaxHealth"] = ((thisPlayerStats["DynamicStats"]["AbilityScores"]["Constitution"]) * 10) -- Max Health Calculation, con * 10
end

function playerStats.updatePersistentStats(playerID, unitData)
	local thisPlayerStats = playerStats.SavedPlayerStats[playerID]
	
	thisPlayerStats["PersistentStats"]["Health"] = unitData["Stats"]["Health"]
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
			["MaxHealth"] = thisPlayerStats["DynamicStats"]["MainStats"]["MaxHealth"],
			["Health"] = thisPlayerStats["PersistentStats"]["Health"]
		},
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
	for i, v in thisPlayerStats["DynamicStats"]["AbilityScores"] do
		returningPlayerUnitStats["AbilityScores"][i] = v
	end
	
	returningPlayerUnitStats["DamageCalcStats"] = {}
	returningPlayerUnitStats["DamageCalcStats"]["Armor"] = thisPlayerStats["DynamicStats"]["DamageCalc"]["Armor"]
	
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
	
	
	--print(itemInfo)
	if itemInfo["ItemType"] == "Consumable" then
		print("consumable used code")
		table.remove(thisPlayerStats.Inventory, inventoryID)
	elseif itemInfo["ItemType"] == "PrimaryWeapon" then
		if thisPlayerStats.Equipped[itemInfo["ItemType"]] ~= "Empty" then
			table.insert(thisPlayerStats.Inventory, thisPlayerStats.Equipped[itemInfo["ItemType"]])
		end
		--^^ this if, make it not copied over and over for each equipment
		thisPlayerStats.Equipped["PrimaryWeapon"] = thisItemId
		table.remove(thisPlayerStats.Inventory, inventoryID)
	elseif itemInfo["ItemType"] == "Head" then
		if thisPlayerStats.Equipped[itemInfo["ItemType"]] ~= "Empty" then
			table.insert(thisPlayerStats.Inventory, thisPlayerStats.Equipped[itemInfo["ItemType"]])
		end
		thisPlayerStats.Equipped["Head"] = thisItemId
		table.remove(thisPlayerStats.Inventory, inventoryID)
	else
		warn("ERROR: invalid item type")
	end
	
	updatePlayerStats(playerID)
	playerStats.updatePlayerInventory(playerID)
end


function addItemToInventory(playerID, itemID)
	local thisPlayerStats = playerStats.SavedPlayerStats[playerID]
	table.insert(thisPlayerStats["Inventory"], itemID)
end

function playerStats.addEventRewards(playerID, eventId)
	local rewardData = moduleEventsList.CombatEncounter[eventId].Rewards
	
	for itemId, itemData in rewardData do
		local luck = math.random(1, 100)
		if luck < itemData["Chance"] then
			print("got it")
			addItemToInventory(playerID, itemId)
		else
			print("bad luck")
		end
	end
end

return playerStats
