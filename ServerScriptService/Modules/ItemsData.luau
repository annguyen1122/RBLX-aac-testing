local ItemsData = {}


ItemsData = {
	
	["LinkedSword"] = {
		["ItemType"] = "PrimaryWeapon",
		["EquipmentAbilities"] = {
			["Sword Lunge"] = "SwordLunge"
		},
		["Animations"] = {
			["IdleStance"] = "swordIdle"
			
		},
		
		["ModelData"] = {
			["WorkspaceModel"] = game.ServerStorage.Equipment.Weapons.LinkedSword, 
			["HoldType"] = "RightHeld"
		},
		
		["Tags"] = {"Sword"} -- im thinking maybe swords tagged with sword can be swapped by the blademaster in combat. might be complicated tho to add.
	},
	
	["DebugItem"] = {
		["ItemType"] = "Consumable",
		
		["ConsumableFunction"] = testFunction
	},
	["DebugPrimaryWeapon"] = {
		["ItemType"] = "PrimaryWeapon",
		
		["EquipmentAbilities"] = {
			["Sword Lunge"] = "SwordLunge"
		},
		["Animations"] = {
			["IdleStance"] = "swordIdle"

		},

		["ModelData"] = {
			["WorkspaceModel"] = game.ServerStorage.Equipment.Weapons.DebugPrimaryWeapon, 
			["HoldType"] = "RightHeld"
		},

		["Tags"] = {"Sword"}
		
	}
	
}

function testFunction()
	print("IT RAN")
end

return ItemsData
