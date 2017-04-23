activeBuildingPrefabs = {
	SimpleResidential = "Objects/ActiveBuildings/SimpleResidential.xml",
	Slant = "Objects/ActiveBuildings/Slant.xml",
	SlantLeft = "Objects/ActiveBuildings/SlantLeft.xml",
	Tower = "Objects/ActiveBuildings/Tower.xml",
	WedgeResidential = "Objects/ActiveBuildings/WedgeResidential.xml",
	WedgeResidentialLeft = "Objects/ActiveBuildings/WedgeResidentialLeft.xml",
	ClicheResidential = "Objects/ActiveBuildings/ClicheResidential.xml",
}
buildingPrefabs = {
	SimpleResidential = "Objects/Buildings/SimpleResidential.xml",
	Slant = "Objects/Buildings/Slant.xml",
	SlantLeft = "Objects/Buildings/SlantLeft.xml",
	Tower = "Objects/Buildings/Tower.xml",
	WedgeResidential = "Objects/Buildings/WedgeResidential.xml",
	WedgeResidentialLeft = "Objects/Buildings/WedgeResidentialLeft.xml",
	ClicheResidential = "Objects/Buildings/ClicheResidential.xml",
}

currentBuilding = nil
population = 0
buildingPopulation = 0
totalPopulation = 0

function HoldBuilding(type)
	if currentBuilding ~= nil then
		currentBuilding:Remove()
		currentBuilding = nil
	end

	currentBuilding = scene_:InstantiateXML(
		cache:GetResourceFileName(buildingPrefabs[type]),
		Vector3(0, 0, 5),
		Quaternion())
	currentBuilding.scale = currentBuilding.scale * scaleFactor
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
	newBuilding = scene_:InstantiateXML(
		cache:GetResourceFileName(buildingPrefabs[type]),
		location,
		Quaternion())
	newBuilding.scale = newBuilding.scale * scaleFactor
end
