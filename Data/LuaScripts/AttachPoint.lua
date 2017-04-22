AttachPoint = ScriptObject()

function AttachPoint:Start()
	self.placements = {}

	self:SubscribeToEvent(self.node, "NodeBeginContact2D", "AttachPoint:HandleNodeBeginContact2D")
	self:SubscribeToEvent(self.node, "NodeEndContact2D", "AttachPoint:HandleNodeEndContact2D")
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
	local otherIndex = otherNode.name
	otherNode = self:FindBuilding(otherNode)
	self.placements[index] = {
		id = otherNode.ID,
		base = otherIndex,
		type = otherNode.name
	}
	log:Write(LOG_DEBUG,
		"There was a collision between "..
			myNode.name.."("..index.." - "..myNode.ID..")"..
			" and "..
			otherNode.name.."("..otherIndex.." - "..otherNode.ID..")")
end

function AttachPoint:HandleNodeEndContact2D(type, data)
	local index = self.node.name
	local myNode = self:FindBuilding(self.node)
	local otherNode = data["OtherNode"]:Get("Node")
	local otherIndex = otherNode.name
	otherNode = self:FindBuilding(otherNode)
	self.placements[index] = nil
	log:Write(LOG_DEBUG,
		"The collision between "..
			myNode.name.."("..index.." - "..myNode.ID..")"..
			" and "..
			otherNode.name.."("..otherIndex.." - "..otherNode.ID..")"..
		" ended")
end
