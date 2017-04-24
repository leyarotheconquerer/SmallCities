Elephant = ScriptObject()

elephantTurn = 0
turnCounter = 0
dayOfTheElephant = false
elephantDialog = false

denialPhrases = {
	"What Elephant?",
	"Elephant Who?",
	"Small City",
	"Lack of Elephant"
}
carnagePrefabs = {
	"Objects/Carnage/Explosion1.xml",
	"Objects/Carnage/Explosion2.xml",
	"Objects/Carnage/Explosion3.xml",
	"Objects/Carnage/Explosion4.xml",
	"Objects/Carnage/Explosion5.xml",
	"Objects/Carnage/Explosion6.xml",
	"Objects/Carnage/Explosion7.xml",
	"Objects/Carnage/Explosion8.xml",
}

function NextTurn()
	if elephantTurn <= 0 then
		elephantTurn = RandomInt(10, 30)
	end

	turnCounter = turnCounter + 1

	if elephantTurn - turnCounter <= 4 then
		if not elephantDialog then
			SpawnDialog("Elephant")
			elephantDialog = true
		end
		local titleText = ui.root:GetChild("Title", true)
		titleText.text = "ELEPHANT! ("..elephantTurn - turnCounter..")"
		log:Write(LOG_WARNING, "The elephant's arrival is imminent. Bleeeeaaaugh!!!!")
	end

	if elephantTurn <= turnCounter then
		SummonElephant()
	end
end

function SummonElephant()
	log:Write(LOG_WARNING, "Behold, our doom is now. The elephant has arrived.")
	dayOfTheElephant = true
	elephant = scene_:InstantiateXML(
		cache:GetResourceFileName("Objects/Elephant.xml"),
		Vector3(0, scaleFactor * 5.12, 0),
		Quaternion())
	elephant.scale = elephant.scale * scaleFactor
end

function Elephant:Start()
	self.progress = 0.0
	self.rate = 6
	self:SubscribeToEvent("Update", "Elephant:UpdateDayOfTheElephant")
	self:SubscribeToEvent(self.node, "NodeBeginContact2D", "Elephant:HandleNodeBeginContact2D")
	PlaySound("Sounds/Elephant.wav")
	log:Write(LOG_DEBUG, "I have arrived")
end

function Elephant:UpdateDayOfTheElephant(type, data)
	local timestep = data["TimeStep"]:GetFloat()
	if self.node.position.y > -scaleFactor * 5.12 then
		self.rate = self.rate + .2
		self.node:Translate2D(Vector2(0, - timestep * scaleFactor * self.rate))
	else
		if buildingRoot ~= nil then
			buildingRoot:Remove()
		end
		buildingRoot = nil
		buildingPlacements = {}
		buildingsPlaced = {}
		buildingPopulation = 0
		population = totalPopulation
		dayOfTheElephant = false
		elephantDialog = false
		turnCounter = 0
		elephantTurn = 0

		local titleText = ui.root:GetChild("Title", true)
		local index = RandomInt(1, table.getn(denialPhrases))
		local phrase = denialPhrases[index]
		log:Write(LOG_DEBUG, "Phrase ["..index.."]: "..phrase)
		titleText.text = phrase

		self.rate = 3
		self:UnsubscribeFromEvent("Update")
		self:UnsubscribeFromEvent(self.node, "NodeBeginContact2D")
		self:SubscribeToEvent("Update", "Elephant:RetractFoot")
	end
end

function Elephant:HandleNodeBeginContact2D(type, data)
	local collisionPoint = data["ContactPoints"]:Get("Vector2")
	for i,v in pairs(collisionPoint) do
		log:Write(LOG_DEBUG,
			"Spawning explosion at "..i.."="..v..", ")
	end
	local explosion = scene_:CreateChild("Explosion")
	local index = RandomInt(1, table.getn(carnagePrefabs))
	explosion = scene_:InstantiateXML(
		cache:GetResourceFileName(carnagePrefabs[index]),
		Vector3(collisionPoint.x, collisionPoint.y, 0),
		Quaternion())
	SubscribeToEvent(explosion, "ParticleEffectFinished", function(type, data)
		log:Write(LOG_DEBUG, "Particle effect finished. Deleting node")
		local node = data["Node"]:Get("Node")
		node:Remove()
	end)
end

function Elephant:RetractFoot(type, data)
	local timestep = data["TimeStep"]:GetFloat()
	if self.node.position.y < scaleFactor * 5.12 then
		self.rate = self.rate + .05
		self.node:Translate2D(Vector2(0, timestep * scaleFactor * self.rate))
	else
		self:UnsubscribeFromEvent("Update")
		self.node:Remove()
	end
end
