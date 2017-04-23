Building = ScriptObject()

function Building:Start()
	log:Write(LOG_DEBUG, "I started")
	self.placements = {}

	self:SubscribeToEvent("Update", "Building:HandleFirstUpdate")
	log:Write(LOG_DEBUG, "I registered")
end

function Building:HandleFirstUpdate()
	self:UnsubscribeFromEvent("Update")
end
