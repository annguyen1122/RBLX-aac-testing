local classData = {}

classData.PlayerClasses = {
	
	["DebugClass"] = {
		
		["RawStats"] = {
			["AbilityScores"] = {
				["Strength"] = 20,
				["Dexterity"] = 20,
				["Constitution"] = 20,
				["Intelligence"] = 20,
				["Wisdom"] = 20,
				["Charisma"] = 20
			}
		},
		["BaseEquipment"] = {
			["PrimaryWeapon"] = "placeholder",
			["Inventory"] = {}
		},
		["ClassAbilities"] = {
			["Debug Attack"] = "DebugAttack",
			["Instant Kill"] = "DebugInstantKill",
			["Sword Lunge"] = "SwordLunge"
		}
		
	}
	
	
}


return classData
