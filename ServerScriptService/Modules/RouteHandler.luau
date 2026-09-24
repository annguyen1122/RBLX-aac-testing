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
	print(RouteHandler.ActiveRouteMap)
end

-- generates a random branching map with like no intersections cause im too lazy for that. TODO: make one that actually has intersections and stuff so you can do a slay the spire -esque map later on.
function RouteHandler.generateRandomMap(depth)
	-- default depth
	if depth == nil then
		depth = 3
	end
	
	RouteHandler.ActiveRouteMap = {
		["Nodes"] = {
			[1] = "Beginning" -- probably add code later to handle this, cause this is not a valid node name
		},
		["Connections"] = {}
	}
	
	local supposedtobeRandomNode = "DebugEncounter"
	
	local nodeCounter = 2 -- it's 2 cause node 1 is already made
	local function generateRandomSubNodes(headNode, limitDepth, currentDepth)
		print(RouteHandler.ActiveRouteMap, headNode)
		--default value for currentDepth
		if not currentDepth then
			currentDepth = 0
		end
		-- stop if depth is too far
		print(currentDepth, limitDepth)
		if currentDepth >= limitDepth then
			print("end?")
			return
		end
		
		RouteHandler.ActiveRouteMap["Connections"][headNode] = {}
		for i = 1, math.random(1,4), 1 do
			RouteHandler.ActiveRouteMap["Nodes"][nodeCounter] = supposedtobeRandomNode
			table.insert(RouteHandler.ActiveRouteMap["Connections"][headNode], nodeCounter)
			nodeCounter += 1
			generateRandomSubNodes(nodeCounter - 1, limitDepth, currentDepth + 1)
		end
	end

	generateRandomSubNodes(1, depth)
	
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
