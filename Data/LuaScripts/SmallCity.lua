require("Data/LuaScripts/BuildingUI")
require("Data/LuaScripts/Construction")
require("Data/LuaScripts/Elephant")
require("Data/LuaScripts/Dialogs")

local BACKGROUND_SIZE = 2048;
local FOREGROUND_SIZE = 1024;

scene_ = nil
cameraNode_ = nil
scaleFactor = 0
debug_ = false

function Start()
	log:SetLevel(LOG_DEBUG)
	log:Write(LOG_DEBUG, "I'm alive!")

	scene_ = SetupScene()
	LoadUI()
	LoadLevel()

	SubscribeToEvent("Update", "HandleUpdate")
	SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate")
	SubscribeToEvent("PhysicsCollisionStart", "HandleNodeCollisionStart")

	SpawnDialog("Tutorial1", function()
		SpawnDialog("Tutorial2", function()
			SpawnDialog("Tutorial3", function()
				SpawnDialog("Tutorial4")
			end)
		end)
	end)
end

function HandleNodeCollisionStart(type, data)
	log:Write(LOG_DEBUG, "Generic event handle")
end

function Stop()
	scene_:delete()
end

function SetupScene()
	scene = Scene:new()
	scene:CreateComponent("Octree")
	scene:CreateComponent("PhysicsWorld2D")
	scene:CreateComponent("DebugRenderer")

	cameraNode_ = scene:CreateChild("Camera")
	local camera = cameraNode_:CreateComponent("Camera")
	cameraNode_:SetPosition(Vector3(0, 0, -10))
	camera.orthographic = true
	camera.orthoSize = graphics.height * PIXEL_SIZE

	local viewport = Viewport:new(scene, cameraNode_:GetComponent("Camera"))
	renderer:SetViewport(0, viewport)

	graphics:SetWindowTitle("Small Cities")

	return scene;
end

function LoadLevel()
	scaleFactor = graphics.height / BACKGROUND_SIZE;
	local background = scene_:InstantiateXML(
		cache:GetResourceFileName("Objects/Background.xml"),
		Vector3(0, 0, 10),
		Quaternion())
	background:SetScale2D(Vector2(scaleFactor, scaleFactor))
	audio:SetMasterGain("Music", .5)
	local music = background:CreateComponent("SoundSource")
	music.soundType = "Music"
	music:Play(cache:GetResource("Sound", "Sounds/Background.wav"))
	SubscribeToEvent(background, "SoundFinished", "HandleMusicComplete")

	scaleFactor = graphics.height / FOREGROUND_SIZE;
	local base = scene_:InstantiateXML(
		cache:GetResourceFileName("Objects/Base.xml"),
		Vector3(0, -scaleFactor * 5.12, 5),
		Quaternion())
	base.scale = base.scale * scaleFactor;
end

function LoadUI()
	local uiStyle = cache:GetResource("XMLFile", "UI/DefaultStyle.xml")
	ui.root.defaultStyle = uiStyle

	local hud = ui.root:CreateChild("Window")
	hud:LoadXML(cache:GetResourceFileName("UI/HUD.xml"))

	local scrollView = ui.root:GetChild("Buildings", true)
	if scrollView ~= nil then
		LoadBuildingUI(scrollView)
	else
		log:Write(LOG_DEBUG, "Couldn't find Buildings element")
	end

	local summonElephant = ui.root:CreateChild("Button")
	summonElephant:LoadXML(cache:GetResourceFileName("UI/SummonElephant.xml"))
	summonElephant.style = "Button"
	SubscribeToEvent(summonElephant, "Pressed", function(type, data)
		SummonElephant()
	end)

	input.mouseVisible = true
end

function ScreenToWorld(coordinates)
	local converted = Vector3(
		(coordinates.x - graphics.width * .5) * PIXEL_SIZE,
		(graphics.height * .5 - coordinates.y) * PIXEL_SIZE,
		5)
	return converted
end

function HandleUpdate(type, data)
	local timestep = data["TimeStep"]:GetFloat()
	if input:GetKeyDown(KEY_DOWN) then
		cameraNode_:Translate2D(Vector2(0, -1) * timestep)
	end
	if input:GetKeyDown(KEY_UP) then
		cameraNode_:Translate2D(Vector2(0, 1) * timestep)
	end
	if input:GetKeyDown(KEY_LEFT) then
		cameraNode_:Translate2D(Vector2(-1, 0) * timestep)
	end
	if input:GetKeyDown(KEY_RIGHT) then
		cameraNode_:Translate2D(Vector2(1, 0) * timestep)
	end
	if input:GetKeyDown(KEY_ESCAPE) then
		engine:Exit()
	end
	if input:GetKeyPress(KEY_F12) then
		debug_ = not debug_
	end
	if not dayOfTheElephant then
		UpdateStatsUI(timestep)
		UpdateCurrentBuilding(timestep)
	end
end

function HandlePostRenderUpdate(type, data)
	if debug_ then
		scene_:GetComponent("PhysicsWorld2D"):DrawDebugGeometry(true)
	end
end

function HandleMusicComplete(type, data)
	log:Write(LOG_DEBUG, "Music has finished, restarting")
	local node = data["Node"]:Get("Node")
	if node ~= nil then
		local source = node:CreateComponent("SoundSource")
		source:Play(cache:GetResource("Sound", "Sounds/Background.wav"))
	else
		log:Write(LOG_DEBUG, "Sound source not found")
	end
end

function PlaySound(file)
	local soundNode = scene_:CreateChild("Sound")
	local soundSource = soundNode:CreateComponent("SoundSource")
	soundSource:Play(cache:GetResource("Sound", file))
	soundSource.autoRemove = true
end
