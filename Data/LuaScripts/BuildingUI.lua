buildingOrder = {
	"SimpleResidential",
	"Slant",
	"SlantLeft",
	"Tower",
	"WedgeResidential",
	"WedgeResidentialLeft",
	"ClicheResidential",
}
buildings = {
	SimpleResidential = {
		name = "Simple Residential",
		image = "Urho2D/SimpleResidential.png",
		imageWidth = 256,
		imageHeight = 256,
		population = 1,
		cost = 0
	},
	Slant = {
		name = "Slant",
		image = "Urho2D/Slant.png",
		imageWidth = 256,
		imageHeight = 256,
		population = 0,
		cost = 1
	},
	SlantLeft = {
		name = "Slant Left",
		image = "Urho2D/SlantLeft.png",
		imageWidth = 256,
		imageHeight = 256,
		population = 0,
		cost = 1
	},
	Tower = {
		name = "Tower",
		image = "Urho2D/Tower.png",
		imageWidth = 128,
		imageHeight = 512,
		population = 0,
		cost = 1
	},
	WedgeResidential = {
		name = "Wedge Residential",
		image = "Urho2D/WedgeResidential.png",
		imageWidth = 256,
		imageHeight = 256,
		population = 1,
		cost = 2
	},
	WedgeResidentialLeft = {
		name = "Wedge Residential Left",
		image = "Urho2D/WedgeResidentialLeft.png",
		imageWidth = 256,
		imageHeight = 256,
		population = 1,
		cost = 2
	},
	ClicheResidential = {
		name = "Cliche Residential",
		image = "Urho2D/ClicheResidential.png",
		imageWidth = 256,
		imageHeight = 256,
		population = 4,
		cost = 2
	}
}

function LoadBuildingUI(scrollView)
	local dude = ui.root:GetChild("Dude", true)
	for i, key in ipairs(buildingOrder) do
		local building = buildings[key]
		local buildingElement = scrollView:CreateChild("Button")
		buildingElement:LoadXML(cache:GetResourceFileName("UI/Building.xml"))
		buildingElement.style = "Button"
		buildingElement.name = key
		buildingElement:AddTag("Building")

		local popText = buildingElement:GetChild("Population", true):GetChild("Text")
		popText.text = building.population
		local costText = buildingElement:GetChild("Cost", true):GetChild("Text")
		costText.text = building.cost
		local image = buildingElement:GetChild("Image", true):GetChild()
		image.texture = cache:GetResource("Texture2D", building.image)
	end
	SubscribeToEvent("UIMouseClick", "HandleBuildingClick")
end

function HandleBuildingClick(type, data)
	local element = data["Element"]:Get("UIElement")
	if element ~= nil then
		while (element ~= ui.root) do
			element = element.parent
			if (element:HasTag("Building")) then
				HoldBuilding(element.name)
			end
		end
	else
		log:Write(LOG_DEBUG, "There's no element here")
	end
end