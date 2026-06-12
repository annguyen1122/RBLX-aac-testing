
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
			["Skip Turn"] = "SkipTurn"
		},

		["Animations"] = {
			["Death"] = "None",
			["Idle"] = "swordIdle"
		}
	}
}


function unitDatabase.newUnit(type, unitName) --type: i.e Enemies, unitName: internal unit name
	
	local databaseUnit = unitDatabase[type][unitName]
	local unitCopy = {}
	
	--copy the unit
	unitCopy["UnitData"] = {}
	for i, v in databaseUnit["UnitData"] do
		unitCopy["UnitData"][i] = v
	end
	unitCopy["Stats"] = {}
	for i, v in databaseUnit["Stats"] do
		unitCopy["Stats"][i] = v
	end
	unitCopy["Actions"] = {}
	for i, v in databaseUnit["Actions"] do
		unitCopy["Actions"][i] = v
	end
	unitCopy["Animations"] = {}
	for i, v in databaseUnit["Animations"] do
		unitCopy["Animations"][i] = v
	end
	
	return unitCopy
	
end

return unitDatabase
