local BACKGROUND_SIZE = 2048;
local FOREGROUND_SIZE = 1024;
scene_ = nil
cameraNode_ = nil
scaleFactor = 0

function Start()
	log:SetLevel(LOG_DEBUG)
	log:Write(LOG_DEBUG, "I'm alive!")

	scaleFactor = (graphics.height * PIXEL_SIZE) / (BACKGROUND_SIZE * PIXEL_SIZE);
	scene_ = SetupScene()

	local background = scene_:InstantiateXML(
		cache:GetResourceFileName("Objects/Background.xml"),
		Vector3(0, 0, 10),
		Quaternion())
	background:SetScale2D(Vector2(scaleFactor, scaleFactor))

	scaleFactor = (graphics.height * PIXEL_SIZE) / (FOREGROUND_SIZE * PIXEL_SIZE);
	local base = scene_:InstantiateXML(
		cache:GetResourceFileName("Objects/Base.xml"),
		-- Vector3(0, -2.5, 5),
		Vector3(0, -scaleFactor * 5.12, 5),
		Quaternion())

	SubscribeToEvent("Update", "HandleUpdate")
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

	return scene;
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
end
