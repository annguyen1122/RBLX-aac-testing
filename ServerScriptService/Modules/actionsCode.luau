local moduleAnimationFunctions = require(game.ServerScriptService.Modules.animationFunctions)

local actionsCode = {}


-- add later something to have data on the attacks, such as the targeting type and stuff.
function actionsCode.debugAttack(encounterID, attackerData, defenderData) --these parameters are at the unitID level, idk if i worded that right, but i will know what it means
	--attack intended to test debugging
	-- supposed to do the base damage to the defender based off attacker's stats.
	local baseDamage = 10
	
	local finalDamage = (baseDamage) --damage calculation if want to change later lol
	
	defenderData["Stats"]["Health"] -= finalDamage
	
	print("resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"])
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

	print("DEATH: resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"])
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
	
	print("sword lunge, resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"])
	
end

function actionsCode.parryStance(encounterID, attackerData, defenderData)
	
end


return actionsCode
