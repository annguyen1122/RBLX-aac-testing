--seperate module to have information on the actions, and the function name that's associated in actionsCode


local actionsData = {}

actionsData.generalActions = {
	
	["DebugAttack"] = {
		["actionFunction"] = "debugAttack",
		["actionTargeting"] = "enemyTargeting"
		
	},
	["SkipTurn"] = {
		["actionFunction"] = "skipTurn"
	},
	["DebugInstantKill"] = {
		["actionFunction"] = "debugInstantKill",
		["actionTargeting"] = "enemyTargeting"
	},
	["SwordLunge"] = {
		["actionFunction"] = "swordLunge",
		["actionTargeting"] = "enemyTargeting"
	}
	
	
}




return actionsData
