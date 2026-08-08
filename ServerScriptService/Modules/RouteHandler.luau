local RouteHandler = {}



RouteHandler.ActiveRouteMap = {}
RouteHandler.CurrentNode = 1

function RouteHandler.SetMapDebugDefault()
	
	RouteHandler.ActiveRouteMap = {
		["Nodes"] = {
			[1] = "DebugEncounter",
			[2] = "DebugEncounter",
			[3] = "DebugEncounter",
			[4] = "DebugEncounter",
			[5] = "DebugEncounter",
			[6] = "DebugEncounter",
		},
		["Connections"] = {
			[1] = {2, 3, 4},
			[2] = {5, 6},
			[3] = {6},
			[4] = {}
		}
	}
end

function RouteHandler.UpdateCurrentNote(setNode)
	RouteHandler.CurrentNode = setNode
	
end

function RouteHandler.getAdjacentRoutes(node)
	local returnedAdjacentRoutes = RouteHandler.ActiveRouteMap["Connections"][node]
	
	return returnedAdjacentRoutes
end

function RouteHandler.getEventFromNodes(nodeList)
	
	-- if it's a single node, or a node list, return the corresponding events
	if type(nodeList) == "number" then
		return RouteHandler.ActiveRouteMap["Nodes"][nodeList]
	else
		local returnEvents = {}
		for i, v in nodeList do
			table.insert(returnEvents, RouteHandler.ActiveRouteMap["Nodes"][v])
		end
		return returnEvents
	end
end

--might be a roundabout method, probbably improve this later, but for now it's gonna work this way.
-- function that takes the choice number from the players, and compares it to the choices of that node to get the node number of the choice number.
-- basically takes the from, and the which, to get the where.
function RouteHandler.getNodeFromChoice(nodeFrom, choiceNum)
	local destinationNode = RouteHandler.ActiveRouteMap["Connections"][nodeFrom][choiceNum]
	
	return destinationNode
end

return RouteHandler
