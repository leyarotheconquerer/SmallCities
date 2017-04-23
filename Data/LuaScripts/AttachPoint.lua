activePlacements = {}
buildingPlacements = {}

AttachPoint = ScriptObject()

function AttachPoint:Start()
	self.placements = {}

	self:SubscribeToEvent(self.node, "NodeBeginContact2D", "AttachPoint:HandleNodeBeginContact2D")
	self:SubscribeToEvent(self.node, "NodeEndContact2D", "AttachPoint:HandleNodeEndContact2D")
	self:SubscribeToEvent("MouseButtonDown", "AttachPoint:HandleMouseButtonDown")
end

function AttachPoint:FindBuilding(node)
	local myNode = node
	while (scene_.root ~= myNode and not myNode:HasTag("Building")) do
		myNode = myNode.parent
	end
	return myNode
end

function AttachPoint:HandleNodeBeginContact2D(type, data)
	local index = self.node.name
	local myNode = self:FindBuilding(self.node)
	local otherNode = data["OtherNode"]:Get("Node")
	if otherNode:HasTag("Base") then
		local otherIndex = otherNode.name
		otherNode = self:FindBuilding(otherNode)
		activePlacements[index] = {
			id = otherNode.ID,
			base = otherIndex,
			type = otherNode.name
		}
		PrintActivePlacements()
		log:Write(LOG_DEBUG,
			"There was a collision between "..
				myNode.name.."("..index.." - "..myNode.ID..")"..
				" and "..
				otherNode.name.."("..otherIndex.." - "..otherNode.ID..")")
	end
end

function AttachPoint:HandleNodeEndContact2D(type, data)
	local index = self.node.name
	local myNode = self:FindBuilding(self.node)
	local otherNode = data["OtherNode"]:Get("Node")
	if otherNode:HasTag("Base") then
		local otherIndex = otherNode.name
		otherNode = self:FindBuilding(otherNode)
		activePlacements[index] = nil
		PrintActivePlacements()
		log:Write(LOG_DEBUG,
			"The collision between "..
				myNode.name.."("..index.." - "..myNode.ID..")"..
				" and "..
				otherNode.name.."("..otherIndex.." - "..otherNode.ID..")"..
			" ended")
	end
end

function AttachPoint:HandleMouseButtonDown(type, data)
	log:Write(LOG_DEBUG, "Handling mouse click")
	local success = false
	local myNode = self:FindBuilding(self.node)
	if myNode.name == "SimpleResidential" then
		log:Write(LOG_DEBUG, "SimpleResidential")
		local one = activePlacements["1"]
		local two = activePlacements["2"]
		if (
			one ~= nil and two ~= nil and					-- Has two valid placements
			(one.id ~= two.id or one.type == "Base") and	-- Doesn't share the same building (except bases)
			(buildingPlacements[one.id] == nil or			-- First slot isn't already taken up
				buildingPlacements[one.id][one.base] == nil) and
			(buildingPlacements[two.id] == nil or			-- Second slot isn't already taken up
				buildingPlacements[two.id][two.base] == nil)
		) then
			if buildingPlacements[one.id] == nil then
				buildingPlacements[one.id] = {}
			end
			buildingPlacements[one.id][one.base] = myNode.ID
			if buildingPlacements[two.id] == nil then
				buildingPlacements[two.id] = {}
			end
			buildingPlacements[two.id][two.base] = myNode.ID
			success = true
		end
	elseif myNode.name == "Slant" or myNode.name == "SlantLeft" then
		log:Write(LOG_DEBUG, myNode.name)
		local one = activePlacements["1"]
		if (
			one ~= nil and
			(buildingPlacements[one.id] == nil or
				buildingPlacements[one.id][one.base] == nil)
		) then
			if buildingPlacements[one.id] == nil then
				buildingPlacements[one.id] = {}
			end
			buildingPlacements[one.id][one.base] = myNode.ID
			success = true
		end
	elseif myNode.name == "Tower" then
		log:Write(LOG_DEBUG, myNode.name)
		local one = activePlacements["1"]
		if (
			one ~= nil and
			(buildingPlacements[one.id] == nil or
				buildingPlacements[one.id][one.base] == nil)
		) then
			if buildingPlacements[one.id] == nil then
				buildingPlacements[one.id] = {}
			end
			buildingPlacements[one.id][one.base] = myNode.ID
			success = true
		end
	elseif myNode.name == "WedgeResidential" or myNode.name == "WedgeResidentialLeft" then
		log:Write(LOG_DEBUG, myNode.name)
		local one = activePlacements["1"]
		if (
			one ~= nil and
			(buildingPlacements[one.id] == nil or
				buildingPlacements[one.id][one.base] == nil)
		) then
			if buildingPlacements[one.id] == nil then
				buildingPlacements[one.id] = {}
			end
			buildingPlacements[one.id][one.base] = myNode.ID
			success = true
		end
		log:Write(LOG_DEBUG, "WedgeResidential")
	elseif myNode.name == "ClicheResidential" then
		log:Write(LOG_DEBUG, myNode.name)
		local one = activePlacements["1"]
		local two = activePlacements["2"]
		if (
			one ~= nil and two ~= nil and					-- Has two valid placements
			(one.id ~= two.id or one.type == "Base") and	-- Doesn't share the same building (except bases)
			(buildingPlacements[one.id] == nil or			-- First slot isn't already taken up
				buildingPlacements[one.id][one.base] == nil) and
			(buildingPlacements[two.id] == nil or			-- Second slot isn't already taken up
				buildingPlacements[two.id][two.base] == nil)
		) then
			if buildingPlacements[one.id] == nil then
				buildingPlacements[one.id] = {}
			end
			buildingPlacements[one.id][one.base] = myNode.ID
			if buildingPlacements[two.id] == nil then
				buildingPlacements[two.id] = {}
			end
			buildingPlacements[two.id][two.base] = myNode.ID
			success = true
		end
	else
		log:Write(LOG_DEBUG, "None of the above")
	end

	if success then
		log:Write(LOG_DEBUG, "Placement succeeded")
		activePlacements = {}
		local scriptNodes = currentBuilding:GetChildrenWithComponent("LuaScriptInstance", true)
		for k,v in pairs(scriptNodes) do
			log:Write(LOG_DEBUG, "Removing script node from "..v.name)
			v:RemoveComponent("LuaScriptInstance")
		end
		currentBuilding = nil
		self:UnsubscribeFromAllEvents()
	end
end

function PrintBuildingPlacements()
	for k,v in pairs(buildingPlacements) do
		log:Write(LOG_DEBUG, k.." = {id="..v.id..", base="..v.base..", type="..v.type.."}")
	end
end

function PrintActivePlacements()
	for k,v in pairs(activePlacements) do
		log:Write(LOG_DEBUG, k.." = {id="..v.id..", base="..v.base..", type="..v.type.."}")
	end
end
