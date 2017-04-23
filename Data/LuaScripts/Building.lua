Building = ScriptObject()

function Building:Start()
	log:Write(LOG_DEBUG, "I started")
	self.placements = {}

	self:SubscribeToEvent("Update", "Building:HandleFirstUpdate")
	self:SubscribeToEvent("MouseButtonDown", "Building:HandleMouseButtonDown")
	log:Write(LOG_DEBUG, "I registered")
end

function Building:HandleFirstUpdate()
	self:UnsubscribeFromEvent("Update")

	local childs = self.node:GetChildrenWithComponent("LuaScriptInstance", true)
	for i,child in ipairs(childs) do
		log:Write(LOG_DEBUG, "Subscribing to "..child.name.." events")
		self:SubscribeToEvent(child, "Attached", "Building:HandleAttached")
		self:SubscribeToEvent(child, "Detached", "Building:HandleDetached")
	end
end

function Building:HandleMouseButtonDown(type, data)
end

function Building:HandleAttached(type, data)
	log:Write(LOG_DEBUG, "Attaching")
end

function Building:HandleDetached(type, data)
	log:Write(LOG_DEBUG, "Detaching")
end
