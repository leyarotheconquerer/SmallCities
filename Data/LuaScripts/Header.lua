headerInContact = {}

Header = ScriptObject()

function Header:Start()
	self:SubscribeToEvent(self.node, "NodeBeginContact2D", "Header:HandleNodeBeginContact2D")
	self:SubscribeToEvent(self.node, "NodeEndContact2D", "Header:HandleNodeEndContact2D")
end

function Header:FindBuilding(node)
	local myNode = node
	while (scene_.root ~= myNode and not myNode:HasTag("Building")) do
		myNode = myNode.parent
	end
	return myNode
end

function Header:HandleNodeBeginContact2D(type, data)
	local otherNode = data["OtherNode"]:Get("Node")
	if otherNode:HasTag("Base") then
		local building = self:FindBuilding(self.node)
		headerInContact[building.ID] = true
	end
end

function Header:HandleNodeEndContact2D(type, data)
	local otherNode = data["OtherNode"]:Get("Node")
	if otherNode:HasTag("Base") then
		local building = self:FindBuilding(self.node)
		headerInContact[building.ID] = nil
	end
end
