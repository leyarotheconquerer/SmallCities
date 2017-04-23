dialogList = {
	Costly = "UI/CostlyDialog.xml",
	Elephant = "UI/ElephantDialog.xml",
	Placement = "UI/PlacementDialog.xml",
	Tutorial1 = "UI/Tutorial1Dialog.xml",
	Tutorial2 = "UI/Tutorial2Dialog.xml",
	Tutorial3 = "UI/Tutorial3Dialog.xml",
	Tutorial3 = "UI/Tutorial4Dialog.xml",
}
dialogCallbacks = {}

function SpawnDialog(type, callback)
	local dialog = ui.root:CreateChild("Window")
	dialog:LoadXML(cache:GetResourceFileName(dialogList[type]))
	dialog.style = "Window"
	dialog.name = type
	dialog:AddTag("Dialog")

	dialogCallbacks[type] = callback

	local closers = dialog:GetChildrenWithTag("Close", true)
	for i,closer in ipairs(closers) do
		SubscribeToEvent(closer, "Pressed", "HandleCloseDialog")
	end
end

function HandleCloseDialog(type, data)
	local element = data["Element"]:Get("UIElement")
	while not element:HasTag("Dialog") and element ~= ui.root do
		element = element.parent
	end

	if element:HasTag("Dialog") then
		if dialogCallbacks[element.name] ~= nil then
			dialogCallbacks[element.name]()
			dialogCallbacks[element.name] = nil
		end
		element:Remove()
	end
end
