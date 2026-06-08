local enemyAI = {}



-- needs code later for handling ally options
function enemyAI.randomChoice(potentialActions, enemyOptions)
	
	print(potentialActions, enemyOptions)
	
	local actionListWithKeyOnName = {} -- list with numberical keys to the actionName of potential actions
	local key = 1
	for actionName, actionInternalName in potentialActions do
		actionListWithKeyOnName[key] = actionInternalName
		key += 1
	end
	
	local enemyOptionsWithKeyOnName = {} -- same as above, system to pick randomly from dictionary, there's probably an easier way to do this but i dont know
	local key = 1
	for enemyID, enemyData in enemyOptions do
		enemyOptionsWithKeyOnName[key] = enemyID
		key += 1
	end

	local enemyAction = {actionListWithKeyOnName[math.random(1, #actionListWithKeyOnName)],enemyOptionsWithKeyOnName[math.random(1, #enemyOptionsWithKeyOnName)], }
	
	return enemyAction
	
end




return enemyAI
