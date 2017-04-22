buildingPrefabs = {
	SimpleResidential = "Objects/Buildings/SimpleResidential.xml",
	Slant = "Objects/Buildings/Slant.xml",
	Tower = "Objects/Buildings/Tower.xml",
	WedgeResidential = "Objects/Buildings/WedgeResidential.xml",
	ClicheResidential = "Objects/Buildings/ClicheResidential.xml",
}

currentBuilding = nil

function HoldBuilding(type)
	if currentBuilding ~= nil then
		currentBuilding:Remove()
		currentBuilding = nil
	end

	currentBuilding = scene_:InstantiateXML(
		cache:GetResourceFileName(buildingPrefabs[type]),
		Vector3(0, 0, 0),
		Quaternion())
end

function UpdateCurrentBuilding(timestep)
	if currentBuilding ~= nil then
		local converted = ScreenToWorld(input.mousePosition)
		currentBuilding.position = converted
	end
end
