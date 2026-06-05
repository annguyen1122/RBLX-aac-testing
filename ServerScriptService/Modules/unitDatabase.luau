
local unitDatabase = {}

--used as a base for making data for other units, also a fallback
unitDatabase.DefaultData = {
	["UnitData"] = {
		["UnitType"] = "Unknown", -- Player / FriendlyAI / EnemyAI
		["PlayerID"] = "Unknown"
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
			["UnitType"] = "EnemyAI" -- Player / FriendlyAI / EnemyAI
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




return unitDatabase
