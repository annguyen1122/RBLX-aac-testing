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
			["PrimaryWeapon"] = nil,
			["Inventory"] = {}
		},
		["ClassAbilities"] = {
			["Debug Attack"] = "DebugAttack",
			["Instant Kill"] = "DebugInstantKill",
			["Sword Lunge"] = "SwordLunge"
		}
		
	},
	--i'm intending this to be the jack of all trades class, with a focus on multiple different blades that serve different purposes. probably going to use the seven swords roblox has, yk venomshank illumina etc.
	-- oh yk what, maybe each class has special rest actions, and blademaster can forge blades during rest, picking amongst some? needs some randomness, but also needs some control, so maybe materials?
	["Blademaster"] = {
		["RawStats"] = {
			["AbilityScores"] = {
				["Strength"] = 10,
				["Dexterity"] = 10,
				["Constitution"] = 10,
				["Intelligence"] = 10,
				["Wisdom"] = 10,
				["Charisma"] = 10
			}
		},
		["BaseEquipment"] = {
			["PrimaryWeapon"] = "LinkedSword",
			["Inventory"] = {}
		},
		["ClassAbilities"] = {
			--["Sword Swapping"] --not implemented yet, but later add this as a special ability that lets you swap swords mid-turn. make it a quick action too, probably a low mana cost.
		}
	}
	
}


return classData
