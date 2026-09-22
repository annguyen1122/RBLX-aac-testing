local EventsList = {}

EventsList.CombatEncounter = {
	
	["DebugEncounter"] = {
		
		["Name"] = "The Debug Encounter",
		["Description"] = "A random area within the crossroads, used to experiment on the world's functionality.",
		["Image"] = "",
		["Rewards"] = {
			["LinkedSword"] = {
				["Chance"] = 50 -- in percentage
			}
		},
		["MapCategory"] = "Crossroads",
		["MapName"] = nil, --specify for specific maps
		
		["EnemyUnits"] = {
			["LinkedSword1"] = {
				["SideType"] = "Enemies",
				["UnitID"] = "Sword",
			},
			["LinkedSword2"] = {
				["SideType"] = "Enemies",
				["UnitID"] = "Sword",
			},
			["LinkedSword3"] = {
				["SideType"] = "Enemies",
				["UnitID"] = "Sword",
			},
			["ZERAT"] = {
				["SideType"] = "Enemies",
				["UnitID"] = "Rat",
			}
		}
		
	}
	
}



return EventsList
