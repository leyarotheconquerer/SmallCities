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
	
end
