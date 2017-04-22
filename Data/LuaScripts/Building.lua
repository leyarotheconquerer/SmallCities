Building = ScriptObject()

function Building:Start()
	log:Write(LOG_DEBUG, "I started")
	self.placements = {}
	self.node:GetChildrenWithTag()

	self:SubscribeToEvent("MouseButtonDown", "Building:HandleMouseButtonDown")
	log:Write(LOG_DEBUG, "I registered")
end

function Building:HandleMouseButtonDown(type, data)
end
