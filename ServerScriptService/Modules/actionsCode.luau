local moduleAnimationFunctions = require(game.ServerScriptService.Modules.animationFunctions)

local actionsCode = {}

-- PROBABLY split this into another module, but for now just having it here.
-- calculates all the modifiers n stuff for damage and whatnot for every attack
function dealDamage(attackerData, defenderData, baseDamage)
	
	local strengthMult = (attackerData["AbilityScores"]["Strength"] * 0.1)
	print(defenderData)
	-- if have armor use but if not default to 1 mult
	local armorMult
	if defenderData["DamageCalcStats"] and defenderData["DamageCalcStats"]["Armor"] then
		armorMult = (100 / (100 + defenderData["DamageCalcStats"]["Armor"]))
	else
		armorMult = 1
	end
	local finalDamage = math.round((baseDamage * strengthMult * armorMult)) --damage calculation if want to change later lol. oh and rounds to nearest whole.
	
	
	defenderData["Stats"]["Health"] -= finalDamage
	
	return finalDamage
end


-- add later something to have data on the attacks, such as the targeting type and stuff.
function actionsCode.debugAttack(encounterID, attackerData, defenderData) --these parameters are at the unitID level, idk if i worded that right, but i will know what it means -- i in fact did not know what that means later.
	--attack intended to test debugging
	-- supposed to do the base damage to the defender based off attacker's stats.
	local baseDamage = 10
	
	local damageDealt = dealDamage(attackerData,defenderData,baseDamage)
	
	print("Debug Attack: resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"], "Damage: ", damageDealt)
	--todo, add placeholder animation logic, vui, all that fancy stuff.
end

function actionsCode.skipTurn(encounterID)
	print("Turn skipped")
end

function actionsCode.debugInstantKill(encounterID, attackerData, defenderData)
	
	--attack intended to test debugging
	-- supposed to do the base damage to the defender based off attacker's stats.
	local baseDamage = 999

	local damageDealt = dealDamage(attackerData,defenderData,baseDamage)

	print("Instant Kill: resulting health = ", defenderData["Stats"]["Health"], "attacker: ", attackerData["UnitData"]["UnitName"], "defender: ", defenderData["UnitData"]["UnitName"])
	--todo, add placeholder animation logic, vui, all that fancy stuff.

	
end

function actionsCode.swordLunge(encounterID, attackerData, defenderData)
	local baseDamage = 10

	local damageDealt = dealDamage(attackerData,defenderData,baseDamage)

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
