Elephant = ScriptObject()

elephantTurn = 2
turnCounter = 0
dayOfTheElephant = false

denialPhrases = {
	"What Elephant?",
	"Elephant Who?",
	"Small City",
	"Lack of Elephant"
}

function NextTurn()
	if elephantTurn <= 0 then
		elephantTurn = RandomInt(10, 30)
	end

	turnCounter = turnCounter + 1

	if elephantTurn - turnCounter <= 4 then
		local titleText = ui.root:GetChild("Title", true)
		titleText.text = "ELEPHANT! ("..elephantTurn - turnCounter..")"
		log:Write(LOG_WARNING, "The elephant's arrival is imminent. Bleeeeaaaugh!!!!")
	end

	if elephantTurn <= turnCounter then
		log:Write(LOG_WARNING, "Behold, our doom is now. The elephant has arrived.")
		dayOfTheElephant = true
		elephant = scene_:InstantiateXML(
			cache:GetResourceFileName("Objects/Elephant.xml"),
			Vector3(0, scaleFactor * 5.12, 0),
			Quaternion())
		elephant.scale = elephant.scale * scaleFactor
	end
end

function Elephant:Start()
	self.progress = 0.0
	self.rate = 6
	self:SubscribeToEvent("Update", "Elephant:UpdateDayOfTheElephant")
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
		turnCounter = 0
		elephantTurn = 0

		local titleText = ui.root:GetChild("Title", true)
		local index = RandomInt(1, table.getn(denialPhrases))
		local phrase = denialPhrases[index]
		log:Write(LOG_DEBUG, "Phrase ["..index.."]: "..phrase)
		titleText.text = phrase

		self.rate = 3
		self:UnsubscribeFromEvent("Update")
		self:SubscribeToEvent("Update", "Elephant:RetractFoot")
	end
end

function Elephant:RetractFoot(type, data)
	local timestep = data["TimeStep"]:GetFloat()
	if self.node.position.y < scaleFactor * 5.12 then
		self.rate = self.rate + .05
		self.node:Translate2D(Vector2(0, timestep * scaleFactor * self.rate))
	else
		self:UnsubscribeFromEvent("Update")
		self:Remove()
	end
end
