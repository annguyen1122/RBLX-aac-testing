local turnHelper = {}

--find a way to put this so its not copied everywhere, maybe a modulescript somewhere
function turnHelper.getAllAliveTeamUnits(desiredTeam, encounterData)
	local thisEncounter = encounterData
	local teamUnits = {}

	if desiredTeam == "Enemyside" then
		print(thisEncounter["Teams"])
		for teamID, unitID in thisEncounter["Teams"]["Enemyside"] do
			if thisEncounter["Units"][unitID]["UnitData"]["DeathStatus"] == "Alive" then
				teamUnits[unitID] = thisEncounter["Units"][unitID]
			end
		end
	elseif desiredTeam == "Playerside" then
		for teamID, unitID in thisEncounter["Teams"]["Playerside"] do
			if thisEncounter["Units"][unitID]["UnitData"]["DeathStatus"] == "Alive" then
				teamUnits[unitID] = thisEncounter["Units"][unitID]
			end
		end
	end

	print(teamUnits)
	return teamUnits
end


return turnHelper
