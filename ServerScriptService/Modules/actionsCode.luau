local moduleAnimationFunctions = require(game.ServerScriptService.Modules.animationFunctions)

local actionsCode = {}


-- add later something to have data on the attacks, such as the targeting type and stuff.
function actionsCode.debugAttack(encounterID, attackerData, defenderData) --these parameters are at the unitID level, idk if i worded that right, but i will know what it means
	--attack intended to test debugging
	-- supposed to do the base damage to the defender based off attacker's stats.
	local baseDamage = 10
	
	local strengthMult = (attackerData["AbilityScores"]["Strength"] * 0.1)
	local finalDamage = (baseDamage * strengthMult) --damage calculation if want to change later lol
	
	defenderData["Stats"]["Health"] -= finalDamage
	
	print("Debug Attack: resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"], "Damage: ", finalDamage)
	--todo, add placeholder animation logic, vui, all that fancy stuff.
	
end

function actionsCode.skipTurn(encounterID)
	print("Turn skipped")
end

function actionsCode.debugInstantKill(encounterID, attackerData, defenderData)
	
	--attack intended to test debugging
	-- supposed to do the base damage to the defender based off attacker's stats.
	local baseDamage = 999

	local finalDamage = (baseDamage) --damage calculation if want to change later lol

	defenderData["Stats"]["Health"] -= finalDamage

	print("Instant Kill: resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"])
	--todo, add placeholder animation logic, vui, all that fancy stuff.

	
end

function actionsCode.swordLunge(encounterID, attackerData, defenderData)
	local baseDamage = 10

	local finalDamage = (baseDamage)

	defenderData["Stats"]["Health"] -= finalDamage

	if attackerData.UnitData.UnitType == "EnemyAI" then
		--mirrored varient
		moduleAnimationFunctions.swordLunge(attackerData["UnitData"]["WorkspaceInstance"].Humanoid.Animator,true)
	else
		moduleAnimationFunctions.swordLunge(attackerData["UnitData"]["WorkspaceInstance"].Humanoid.Animator)
	end
	
	print("Sword Lunge: resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"])
	
end

function actionsCode.parryStance(encounterID, attackerData, defenderData)
	-- probably set this up so that it defends an ally dragging taunt for that one ally, reflecting one instance of damage?
	print("Parry Stance: Unfinished")
end


return actionsCode
