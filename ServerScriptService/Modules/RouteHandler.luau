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


return RouteHandler
