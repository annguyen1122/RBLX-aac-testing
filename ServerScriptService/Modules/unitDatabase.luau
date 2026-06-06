
local unitDatabase = {}

--used as a base for making data for other units, also a fallback
unitDatabase.DefaultData = {
	["UnitData"] = {
		["UnitType"] = "Unknown", -- Player / FriendlyAI / EnemyAI
		["PlayerID"] = "Unknown",
		["UnitName"] = "Unknown"
	},
	
	
	["Stats"] = {
		["Health"] = 100,
		["MaxHealth"] = 100,
	},
	
	["Actions"] = {
		-- make sure that the future code takes into account the possibility of multiple actions being here and varied possible amounts.
		["DebugAttack"] = "debugAttack" --the name is what's put when doing moduleActionsDatabase[HERE]
	}
	
}




unitDatabase.Enemies = {
	
	
	["TestUnit"] = {
		["UnitData"] = {
			["UnitType"] = "EnemyAI", -- Player / FriendlyAI / EnemyAI
			["UnitName"] = "The Test Unit"
		},
		
		["Stats"] = {
			["Health"] = 100,
			["MaxHealth"] = 100,
		},
		
		["Actions"] = {
			["DebugAttack"] = "debugAttack" --the name is what's put when doing moduleActionsDatabase[HERE]
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
	
	return unitCopy
	
end

return unitDatabase
