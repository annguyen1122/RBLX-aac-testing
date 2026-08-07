
local unitDatabase = {}

--used as a base for making data for other units, also a fallback
unitDatabase.DefaultData = {
	["UnitData"] = {
		["UnitType"] = "Unknown", -- Player / FriendlyAI / EnemyAI
		["PlayerID"] = "Unknown",
		["UnitName"] = "Unknown",
		["EnemyAI"] = "Unknown",
		["DeathStatus"] = "Alive",
		["WorkspaceInstance"] = "Unset"
	},
	
	
	["Stats"] = {
		["Health"] = 100,
		["MaxHealth"] = 100,
	},
	
	["Actions"] = {
		-- make sure that the future code takes into account the possibility of multiple actions being here and varied possible amounts.
		["Debug Attack"] = "DebugAttack" --the name is what's put when doing moduleActionsCode[HERE]
	},
	["Animations"] = {
		["Death"] = "placeholderDeath"
	},
	["Equipment"] = {
		["PrimaryWeapon"] = "LinkedSword"
	},
	["AbilityScores"] = {
		["Strength"] = 10,
		["Dexterity"] = 10,
		["Constitution"] = 10,
		["Intelligence"] = 10,
		["Wisdom"] = 10,
		["Charisma"] = 10
	}
	
}




unitDatabase.Enemies = {
	
	
	["TestUnit"] = {
		["UnitData"] = {
			["UnitType"] = "EnemyAI", -- Player / FriendlyAI / EnemyAI
			["UnitName"] = "The Test Unit",
			["EnemyAI"] = "randomChoice",
			["DeathStatus"] = "Alive",
			["Model"] = "TestUnit",
			["WorkspaceInstance"] = "Unset"
		},
		
		["Stats"] = {
			["Health"] = 100,
			["MaxHealth"] = 100,
		},
		
		["Actions"] = {
			["Debug Attack"] = "DebugAttack", --the name is what's put when doing moduleActionsCode[HERE]
			["Skip Turn"] = "SkipTurn"
		},
		["Animations"] = {
			["Death"] = "placeholderDeath"
		}
		
	},
	
	
	["Rat"] = {
		["UnitData"] = {
			["UnitType"] = "EnemyAI", -- Player / FriendlyAI / EnemyAI
			["UnitName"] = "Rat",
			["EnemyAI"] = "randomChoice",
			["DeathStatus"] = "Alive",
			["Model"] = "Rat",
			["WorkspaceInstance"] = "Unset"
		},

		["Stats"] = {
			["Health"] = 50,
			["MaxHealth"] = 50,
		},

		["Actions"] = {
			["Debug Attack"] = "DebugAttack", --the name is what's put when doing moduleActionsCode[HERE]
			["Skip Turn"] = "SkipTurn"
		},
		
		["Animations"] = {
			["Death"] = "None",
		}
	},
	
	["Sword"] = {
		["UnitData"] = {
			["UnitType"] = "EnemyAI", -- Player / FriendlyAI / EnemyAI
			["UnitName"] = "Linked Sword",
			["EnemyAI"] = "randomChoice",
			["DeathStatus"] = "Alive",
			["Model"] = "Sword",
			["WorkspaceInstance"] = "Unset"
		},

		["Stats"] = {
			["Health"] = 100,
			["MaxHealth"] = 100,
		},

		["Actions"] = {
			["Lunge"] = "SwordLunge", --the name is what's put when doing moduleActionsCode[HERE]
			["Parry Stance"] = "ParryStance",
			["Skip Turn"] = "SkipTurn"
		},

		["Animations"] = {
			["Death"] = "None",
			["Idle"] = "swordIdle"
		},
		["Equipment"] = {
			["PrimaryWeapon"] = "LinkedSword"
		},
		["AbilityScores"] = {
			["Strength"] = 10,
			["Dexterity"] = 10,
			["Constitution"] = 10,
			["Intelligence"] = 10,
			["Wisdom"] = 10,
			["Charisma"] = 10
		}

	}
}


function unitDatabase.newUnit(type, unitName) --type: i.e Enemies, unitName: internal unit name
	
	local databaseUnit = unitDatabase[type][unitName]
	local defaultUnit = unitDatabase.DefaultData
	local unitCopy = {}
	
	--copy the unit
	--unitCopy["UnitData"] = {}
	--for i, v in databaseUnit["UnitData"] do
	--	unitCopy["UnitData"][i] = v
	--end
	--unitCopy["Stats"] = {}
	--for i, v in databaseUnit["Stats"] do
	--	unitCopy["Stats"][i] = v
	--end
	--unitCopy["Actions"] = {}
	--for i, v in databaseUnit["Actions"] do
	--	unitCopy["Actions"][i] = v
	--end
	--unitCopy["Animations"] = {}
	--for i, v in databaseUnit["Animations"] do
	--	unitCopy["Animations"][i] = v
	--end
	--unitCopy["Equipment"] = {}
	--for i, v in databaseUnit["Equipment"] do
	--	unitCopy["Equipment"][i] = v
	--end
	
	---- replaced the deep copy above with a more general one so i dont have to adjust it every time i add a new thing. hope i wont miss bugs cause of it tho. having expected values did let me catch some bugs
	--for dataCatagory, dataTable in databaseUnit do
	--	--figure out better, less confusing names for this, or maybe just do i,v idk
	--	unitCopy[dataCatagory] = {}
	--	for valueName, dataValue in dataTable do
	--		unitCopy[dataCatagory][valueName] = dataValue
	--	end
	--end 
	
	local expectedCategories = {"UnitData", "Stats", "Actions", "Animations", "Equipment", "AbilityScores"}	
	for i, v in expectedCategories do
		unitCopy[v] = {}
		if databaseUnit[v] then
			for j, k in databaseUnit[v] do
				unitCopy[v][j] = k
			end
		else
			warn("ERROR: Base unit does not have ", v, " data, using fallback values.", unitCopy) -- TODO: later figure out exceptions instead of this faulty print statement
			for j, k in defaultUnit[v] do
				unitCopy[v][j] = k
			end
		end
	end
	
	return unitCopy
	
end

return unitDatabase
