local actionsDatabase = {}

function actionsDatabase.debugAttack(encounterID, attackerData, defenderData) --these parameters are at the unitID level, idk if i worded that right, but i will know what it means
	--attack intended to test debugging
	-- supposed to do the base damage to the defender based off attacker's stats.
	local baseDamage = 10
	
	local finalDamage = (baseDamage) --damage calculation if want to change later lol
	
	defenderData["Stats"]["Health"] -= finalDamage
	
	print("resulting health = ", defenderData["Stats"]["Health"])
	--todo, add placeholder animation logic, vui, all that fancy stuff.
	
end



return actionsDatabase
