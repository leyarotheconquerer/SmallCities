activeBuildingPrefabs = {
	SimpleResidential = "Objects/ActiveBuildings/SimpleResidential.xml",
	SlantResidential = "Objects/ActiveBuildings/SlantResidential.xml",
	SlantResidentialLeft = "Objects/ActiveBuildings/SlantResidentialLeft.xml",
	Tower = "Objects/ActiveBuildings/Tower.xml",
	Wedge = "Objects/ActiveBuildings/Wedge.xml",
	WedgeLeft = "Objects/ActiveBuildings/WedgeLeft.xml",
	DoubleResidential = "Objects/ActiveBuildings/DoubleResidential.xml",
	ClicheResidential = "Objects/ActiveBuildings/ClicheResidential.xml"
}
buildingPrefabs = {
	SimpleResidential = "Objects/Buildings/SimpleResidential.xml",
	SlantResidential = "Objects/Buildings/SlantResidential.xml",
	SlantResidentialLeft = "Objects/Buildings/SlantResidentialLeft.xml",
	Tower = "Objects/Buildings/Tower.xml",
	Wedge = "Objects/Buildings/Wedge.xml",
	WedgeLeft = "Objects/Buildings/WedgeLeft.xml",
	DoubleResidential = "Objects/Buildings/DoubleResidential.xml",
	ClicheResidential = "Objects/Buildings/ClicheResidential.xml"
}

currentBuilding = nil
buildingRoot = nil
population = 0
buildingPopulation = 0
totalPopulation = 0

function HoldBuilding(type)
	if population >= buildings[type].cost then
		if currentBuilding ~= nil then
			currentBuilding:Remove()
			currentBuilding = nil
		end

		currentBuilding = scene_:InstantiateXML(
			cache:GetResourceFileName(activeBuildingPrefabs[type]),
			Vector3(0, 0, 5),
			Quaternion())
		currentBuilding.scale = currentBuilding.scale * scaleFactor
	else
		SpawnDialog("Costly")
		log:Write(LOG_INFO, "Unable to select building, not enough population")
	end
end

function UpdateCurrentBuilding(timestep)
	if currentBuilding ~= nil then
		local converted = ScreenToWorld(input.mousePosition)
		currentBuilding.position = converted
	end

	if input:GetMouseButtonPress(MOUSEB_LEFT) then
	end
end

function PlaceBuilding(type, location)
	log:Write(LOG_DEBUG, "population="..population..",building="..buildingPopulation..",total="..totalPopulation.."(cost="..buildings[type].cost..",add="..buildings[type].population..")")
	population = population - buildings[type].cost
	buildingPopulation = buildingPopulation + buildings[type].population
	if buildingPopulation > totalPopulation then
		population = population + buildings[type].population
		totalPopulation = buildingPopulation
	end

	if buildingRoot == nil then
		buildingRoot = scene_:CreateChild("BuildingRoot")
	end

	newBuilding = scene_:InstantiateXML(
		cache:GetResourceFileName(buildingPrefabs[type]),
		location,
		Quaternion())
	newBuilding.scale = newBuilding.scale * scaleFactor
	newBuilding:SetParent(buildingRoot)

	NextTurn()
end
