local moduleClassData = require(game.ServerScriptService.Modules.classData)

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
	
end

function playerStats.ModifyStat(PlayerID, StatName)
	
end

function playerStats.AssignClassStats(PlayerID, Class)
	local thisPlayerStats = playerStats.SavedPlayerStats[PlayerID]
	local thisClassData = moduleClassData.PlayerClasses["DebugClass"]
	
	thisPlayerStats["BaseStats"] = {}
	
	thisPlayerStats["BaseStats"]["AbilityScores"] = {}
	thisPlayerStats["BaseStats"]["AbilityScores"]["Strength"] = thisClassData["RawStats"]["AbilityScores"]["Strength"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Dexterity"] = thisClassData["RawStats"]["AbilityScores"]["Dexterity"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Constitution"] = thisClassData["RawStats"]["AbilityScores"]["Constitution"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Intelligence"] = thisClassData["RawStats"]["AbilityScores"]["Intelligence"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Wisdom"] = thisClassData["RawStats"]["AbilityScores"]["Wisdom"]
	thisPlayerStats["BaseStats"]["AbilityScores"]["Charisma"] = thisClassData["RawStats"]["AbilityScores"]["Charisma"]


	thisPlayerStats["BaseStats"]["MainStats"] = {}
	thisPlayerStats["BaseStats"]["MainStats"]["MaxHealth"] = ((thisPlayerStats["BaseStats"]["AbilityScores"]["Constitution"]) * 10) -- Max Health Calculation, con * 10
	
	
	thisPlayerStats["Class"] = Class
	
	-- adds the classabilitys to the list, not overwrite.
	for abilityName, abilityID in thisClassData["ClassAbilities"] do
		thisPlayerStats["Abilities"]["ClassAbilities"][abilityName] = abilityID
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
			["Death"] = "placeholderDeath" -- TODO: replace this later
		}
	}
	
	returningPlayerUnitStats["Actions"] = {}
	-- later can add different code for each subsection, for now just treat all equally.
	print(thisPlayerStats["Abilities"])
	for i, subSection in thisPlayerStats["Abilities"] do
		for abilityName, abilityID in subSection do
			returningPlayerUnitStats["Actions"][abilityName] = abilityID 
		end
	end
	
	return returningPlayerUnitStats
	
end



return playerStats
