local ItemsData = {}


ItemsData.Weapons = {
	
	["LinkedSword"] = {
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
	}
	
}


return ItemsData
