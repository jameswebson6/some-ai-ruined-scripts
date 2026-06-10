-- ImpulseController + Actions (Sit / Lay) GUI
-- Single copy-and-paste LocalScript. Client-side only.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- marker
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

-- fling state
local hiddenfling = false
local flingThread
local flingKey = Enum.KeyCode.F

-- smoothing state
local accelSmoothing  = false
local smoothingFactor = 0.15
local smoothBoundKey  = nil
local smoothedDV      = Vector3.zero

local function getHRP()
	local char = player.Character
	return char and char:FindFirstChild("HumanoidRootPart")
end

local function fling()
	local movel = 0.1
	while hiddenfling do
		local success = pcall(function()
			local hrp = getHRP()
			if hrp then
				local vel = hrp.Velocity
				hrp.Velocity = vel * 100000000000 + Vector3.new(0, 100000000000, 0)
				RunService.RenderStepped:Wait()
				hrp.Velocity = vel
				RunService.Stepped:Wait()
				hrp.Velocity = vel + Vector3.new(0, movel, 0)
				movel = -movel
			end
		end)
		if not success then RunService.Heartbeat:Wait() end
		RunService.Heartbeat:Wait()
	end
end

local function toggleFling()
	hiddenfling = not hiddenfling
	if hiddenfling then
		if not flingThread or coroutine.status(flingThread) == "dead" then
			flingThread = coroutine.create(fling)
			coroutine.resume(flingThread)
		end
	end
end

-- Character tracking
local root, humanoid
local function getRootAndHumanoid()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart"), char:WaitForChild("Humanoid")
end

root, humanoid = getRootAndHumanoid()
player.CharacterAdded:Connect(function(char)
	root     = char:WaitForChild("HumanoidRootPart")
	humanoid = char:WaitForChild("Humanoid")
	-- clear smoothing buffer on respawn so stale velocity doesn't carry over
	smoothedDV = Vector3.zero
end)

-- Movement config
local movements = {
	forward  = {name = "Forward",  defaultKey = Enum.KeyCode.R,            dv = 100, enabled = true},
	backward = {name = "Backward", defaultKey = Enum.KeyCode.T,            dv = 100, enabled = true},
	left     = {name = "Left",     defaultKey = Enum.KeyCode.Minus,        dv = 100, enabled = true},
	right    = {name = "Right",    defaultKey = Enum.KeyCode.Equals,       dv = 100, enabled = true},
	up       = {name = "Up",       defaultKey = Enum.KeyCode.LeftBracket,  dv = 100, enabled = true},
	down     = {name = "Down",     defaultKey = Enum.KeyCode.RightBracket, dv = 100, enabled = true},
}

local active = {}

local function computeDeltaV()
	if not root then return Vector3.zero end
	local v = Vector3.zero
	for movementType, data in pairs(movements) do
		if not data.enabled then continue end
		if not active[data.currentKey] then continue end
		if movementType == "forward"  then v += root.CFrame.LookVector  *  data.dv
		elseif movementType == "backward" then v += -root.CFrame.LookVector *  data.dv
		elseif movementType == "left"     then v += -root.CFrame.RightVector *  data.dv
		elseif movementType == "right"    then v +=  root.CFrame.RightVector *  data.dv
		elseif movementType == "up"       then v +=  root.CFrame.UpVector    *  data.dv
		elseif movementType == "down"     then v += -root.CFrame.UpVector    *  data.dv
		end
	end
	return v
end

local function applyImpulseForHeld()
	if not root then return end
	local dv = computeDeltaV()
	if dv.Magnitude > 0 then
		root:ApplyImpulse(root.AssemblyMass * dv)
	end
end

for _, data in pairs(movements) do
	data.currentKey = data.defaultKey
end

-- Lay
local function doLay()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart") or root
	if not hum or not hrp then return end
	hum.Sit = true
	task.wait()
	hrp.CFrame = hrp.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
	for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
		pcall(function() track:Stop() end)
	end
end

local actions = {
	sit = {name = "Sit", key = Enum.KeyCode.G, enabled = true, callback = function()
		local char = player.Character
		if not char then return end
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		if hum then hum.Sit = true end
	end},
	lay = {name = "Lay", key = Enum.KeyCode.H, enabled = true, callback = doLay},
}

-- ======= GUI =======
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ImpulseControllerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 600)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Text = "Impulse Controller"
title.BorderSizePixel = 0
title.Parent = mainFrame
title.Active = true

do
	local dragging, dragStart, startPos = false, Vector2.new(), UDim2.new()
	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos  = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScrollFrame"
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

-- Fling section
local flingLabel = Instance.new("TextLabel")
flingLabel.Size = UDim2.new(1, -10, 0, 25)
flingLabel.Position = UDim2.new(0, 5, 0, 5)
flingLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flingLabel.TextSize = 14
flingLabel.Font = Enum.Font.Gotham
flingLabel.Text = "FLING"
flingLabel.BorderSizePixel = 0
flingLabel.Parent = scrollFrame

local flingToggle = Instance.new("TextButton")
flingToggle.Name = "FlingToggle"
flingToggle.Size = UDim2.new(0, 80, 0, 25)
flingToggle.Position = UDim2.new(1, -90, 0, 5)
flingToggle.BackgroundColor3 = Color3.fromRGB(100, 30, 30)
flingToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flingToggle.TextSize = 12
flingToggle.Font = Enum.Font.Gotham
flingToggle.Text = "OFF"
flingToggle.BorderSizePixel = 0
flingToggle.Parent = scrollFrame

local flingKeyLabel = Instance.new("TextLabel")
flingKeyLabel.Size = UDim2.new(0, 100, 0, 18)
flingKeyLabel.Position = UDim2.new(0, 5, 0, 35)
flingKeyLabel.BackgroundTransparency = 1
flingKeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
flingKeyLabel.TextSize = 12
flingKeyLabel.Font = Enum.Font.Gotham
flingKeyLabel.Text = "Fling Key (press to set):"
flingKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
flingKeyLabel.Parent = scrollFrame

local flingKeyInput = Instance.new("TextBox")
flingKeyInput.Name = "FlingKeyInput"
flingKeyInput.Size = UDim2.new(0, 60, 0, 18)
flingKeyInput.Position = UDim2.new(0, 110, 0, 35)
flingKeyInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flingKeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
flingKeyInput.TextSize = 12
flingKeyInput.Font = Enum.Font.Gotham
flingKeyInput.Text = tostring(flingKey):gsub("Enum.KeyCode.", "")
flingKeyInput.ClearTextOnFocus = false
flingKeyInput.BorderSizePixel = 0
flingKeyInput.Parent = scrollFrame

flingKeyInput.FocusLost:Connect(function()
	local kc = Enum.KeyCode[flingKeyInput.Text:upper()]
	if kc then flingKey = kc; flingKeyInput.Text = tostring(kc):gsub("Enum.KeyCode.", "")
	else flingKeyInput.Text = tostring(flingKey):gsub("Enum.KeyCode.", "") end
end)
flingKeyInput.Focused:Connect(function()
	local conn
	conn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			flingKey = input.KeyCode
			flingKeyInput.Text = tostring(flingKey):gsub("Enum.KeyCode.", "")
			conn:Disconnect()
		end
	end)
end)

local yOffset = 70

-- ======= Movement rows =======
for movementType, data in pairs(movements) do
	local frame = Instance.new("Frame")
	frame.Name = movementType .. "Frame"
	frame.Size = UDim2.new(1, -10, 0, 90)
	frame.Position = UDim2.new(0, 5, 0, yOffset)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.BorderSizePixel = 1
	frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	frame.Parent = scrollFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 80, 0, 20)
	nameLabel.Position = UDim2.new(0, 5, 0, 5)
	nameLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 12
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = data.name
	nameLabel.BorderSizePixel = 0
	nameLabel.Parent = frame

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ToggleBtn"
	toggleBtn.Size = UDim2.new(0, 60, 0, 20)
	toggleBtn.Position = UDim2.new(1, -65, 0, 5)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.TextSize = 11
	toggleBtn.Font = Enum.Font.Gotham
	toggleBtn.Text = "ON"
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Parent = frame

	local keyLabel = Instance.new("TextLabel")
	keyLabel.Size = UDim2.new(0, 50, 0, 18)
	keyLabel.Position = UDim2.new(0, 5, 0, 30)
	keyLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	keyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	keyLabel.TextSize = 10
	keyLabel.Font = Enum.Font.Gotham
	keyLabel.Text = "Key:"
	keyLabel.BorderSizePixel = 0
	keyLabel.Parent = frame

	local keyInput = Instance.new("TextBox")
	keyInput.Name = "KeyInput"
	keyInput.Size = UDim2.new(0, 70, 0, 18)
	keyInput.Position = UDim2.new(0, 55, 0, 30)
	keyInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyInput.TextSize = 10
	keyInput.Font = Enum.Font.Gotham
	keyInput.Text = tostring(data.currentKey):gsub("Enum.KeyCode.", "")
	keyInput.BorderSizePixel = 0
	keyInput.Parent = frame

	local dvLabel = Instance.new("TextLabel")
	dvLabel.Size = UDim2.new(0, 50, 0, 18)
	dvLabel.Position = UDim2.new(0, 135, 0, 30)
	dvLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	dvLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	dvLabel.TextSize = 10
	dvLabel.Font = Enum.Font.Gotham
	dvLabel.Text = "Value:"
	dvLabel.BorderSizePixel = 0
	dvLabel.Parent = frame

	local dvInput = Instance.new("TextBox")
	dvInput.Name = "DVInput"
	dvInput.Size = UDim2.new(0, 70, 0, 18)
	dvInput.Position = UDim2.new(0, 185, 0, 30)
	dvInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	dvInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	dvInput.TextSize = 10
	dvInput.Font = Enum.Font.Gotham
	dvInput.Text = tostring(data.dv)
	dvInput.BorderSizePixel = 0
	dvInput.Parent = frame

	local instrLabel = Instance.new("TextLabel")
	instrLabel.Size = UDim2.new(1, -10, 0, 30)
	instrLabel.Position = UDim2.new(0, 5, 0, 50)
	instrLabel.BackgroundTransparency = 1
	instrLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	instrLabel.TextSize = 9
	instrLabel.Font = Enum.Font.Gotham
	instrLabel.Text = "Key name (e.g., R, T, Space, W)\nValue: studs/second"
	instrLabel.TextWrapped = true
	instrLabel.TextXAlignment = Enum.TextXAlignment.Left
	instrLabel.TextYAlignment = Enum.TextYAlignment.Top
	instrLabel.BorderSizePixel = 0
	instrLabel.Parent = frame

	toggleBtn.MouseButton1Click:Connect(function()
		data.enabled = not data.enabled
		toggleBtn.BackgroundColor3 = data.enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(120, 80, 80)
		toggleBtn.Text = data.enabled and "ON" or "OFF"
	end)

	keyInput.FocusLost:Connect(function()
		local kc = Enum.KeyCode[keyInput.Text:upper()]
		if kc then data.currentKey = kc; keyInput.Text = tostring(kc):gsub("Enum.KeyCode.", "")
		else keyInput.Text = tostring(data.currentKey):gsub("Enum.KeyCode.", "") end
	end)
	keyInput.Focused:Connect(function()
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				data.currentKey = input.KeyCode
				keyInput.Text = tostring(data.currentKey):gsub("Enum.KeyCode.", "")
				conn:Disconnect()
			end
		end)
	end)

	dvInput.FocusLost:Connect(function()
		local value = tonumber(dvInput.Text)
		if value and value > 0 then data.dv = value
		else dvInput.Text = tostring(data.dv) end
	end)

	yOffset = yOffset + 100
end

-- ======= Smoothing row (styled like movement rows) =======
local smoothFrame = Instance.new("Frame")
smoothFrame.Name = "SmoothingFrame"
smoothFrame.Size = UDim2.new(1, -10, 0, 90)
smoothFrame.Position = UDim2.new(0, 5, 0, yOffset)
smoothFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
smoothFrame.BorderSizePixel = 1
smoothFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
smoothFrame.Parent = scrollFrame

local smoothNameLabel = Instance.new("TextLabel")
smoothNameLabel.Size = UDim2.new(0, 80, 0, 20)
smoothNameLabel.Position = UDim2.new(0, 5, 0, 5)
smoothNameLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
smoothNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothNameLabel.TextSize = 12
smoothNameLabel.Font = Enum.Font.GothamBold
smoothNameLabel.Text = "Smoothing"
smoothNameLabel.BorderSizePixel = 0
smoothNameLabel.Parent = smoothFrame

local smoothToggleBtn = Instance.new("TextButton")
smoothToggleBtn.Name = "SmoothToggleBtn"
smoothToggleBtn.Size = UDim2.new(0, 60, 0, 20)
smoothToggleBtn.Position = UDim2.new(1, -65, 0, 5)
smoothToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 80, 80) -- starts OFF
smoothToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothToggleBtn.TextSize = 11
smoothToggleBtn.Font = Enum.Font.Gotham
smoothToggleBtn.Text = "OFF"
smoothToggleBtn.BorderSizePixel = 0
smoothToggleBtn.Parent = smoothFrame

local smoothKeyLabel = Instance.new("TextLabel")
smoothKeyLabel.Size = UDim2.new(0, 50, 0, 18)
smoothKeyLabel.Position = UDim2.new(0, 5, 0, 30)
smoothKeyLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
smoothKeyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
smoothKeyLabel.TextSize = 10
smoothKeyLabel.Font = Enum.Font.Gotham
smoothKeyLabel.Text = "Key:"
smoothKeyLabel.BorderSizePixel = 0
smoothKeyLabel.Parent = smoothFrame

local smoothKeyInput = Instance.new("TextBox")
smoothKeyInput.Name = "SmoothKeyInput"
smoothKeyInput.Size = UDim2.new(0, 70, 0, 18)
smoothKeyInput.Position = UDim2.new(0, 55, 0, 30)
smoothKeyInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
smoothKeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothKeyInput.TextSize = 10
smoothKeyInput.Font = Enum.Font.Gotham
smoothKeyInput.Text = "None"       -- unbound at start
smoothKeyInput.ClearTextOnFocus = false
smoothKeyInput.BorderSizePixel = 0
smoothKeyInput.Parent = smoothFrame

local smoothFactorLabel = Instance.new("TextLabel")
smoothFactorLabel.Size = UDim2.new(0, 50, 0, 18)
smoothFactorLabel.Position = UDim2.new(0, 135, 0, 30)
smoothFactorLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
smoothFactorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
smoothFactorLabel.TextSize = 10
smoothFactorLabel.Font = Enum.Font.Gotham
smoothFactorLabel.Text = "Factor:"
smoothFactorLabel.BorderSizePixel = 0
smoothFactorLabel.Parent = smoothFrame

local smoothFactorInput = Instance.new("TextBox")
smoothFactorInput.Name = "SmoothFactorInput"
smoothFactorInput.Size = UDim2.new(0, 70, 0, 18)
smoothFactorInput.Position = UDim2.new(0, 185, 0, 30)
smoothFactorInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
smoothFactorInput.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothFactorInput.TextSize = 10
smoothFactorInput.Font = Enum.Font.Gotham
smoothFactorInput.Text = "0.15"    -- default factor
smoothFactorInput.BorderSizePixel = 0
smoothFactorInput.Parent = smoothFrame

local smoothInstrLabel = Instance.new("TextLabel")
smoothInstrLabel.Size = UDim2.new(1, -10, 0, 30)
smoothInstrLabel.Position = UDim2.new(0, 5, 0, 50)
smoothInstrLabel.BackgroundTransparency = 1
smoothInstrLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
smoothInstrLabel.TextSize = 9
smoothInstrLabel.Font = Enum.Font.Gotham
smoothInstrLabel.Text = "Key toggles smoothing ON/OFF. Factor: 0.01 (heavy) – 1.0 (instant). Default 0.15"
smoothInstrLabel.TextWrapped = true
smoothInstrLabel.TextXAlignment = Enum.TextXAlignment.Left
smoothInstrLabel.TextYAlignment = Enum.TextYAlignment.Top
smoothInstrLabel.BorderSizePixel = 0
smoothInstrLabel.Parent = smoothFrame

-- helper so both the button click and the keybind stay in sync
local function setSmoothingEnabled(enabled)
	accelSmoothing = enabled
	if not enabled then smoothedDV = Vector3.zero end
	smoothToggleBtn.BackgroundColor3 = accelSmoothing
		and Color3.fromRGB(80, 120, 80)
		or  Color3.fromRGB(120, 80, 80)
	smoothToggleBtn.Text = accelSmoothing and "ON" or "OFF"
end

smoothToggleBtn.MouseButton1Click:Connect(function()
	setSmoothingEnabled(not accelSmoothing)
end)

smoothKeyInput.Focused:Connect(function()
	smoothKeyInput.Text = "..."
	local conn
	conn = UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			smoothBoundKey = input.KeyCode
			smoothKeyInput.Text = tostring(smoothBoundKey):gsub("Enum.KeyCode.", "")
			conn:Disconnect()
		end
	end)
end)
smoothKeyInput.FocusLost:Connect(function()
	if smoothKeyInput.Text == "" or smoothKeyInput.Text == "..." then
		smoothBoundKey = nil
		smoothKeyInput.Text = "None"
	else
		local kc = Enum.KeyCode[smoothKeyInput.Text:upper()]
		if kc then
			smoothBoundKey = kc
			smoothKeyInput.Text = tostring(kc):gsub("Enum.KeyCode.", "")
		else
			smoothKeyInput.Text = smoothBoundKey
				and tostring(smoothBoundKey):gsub("Enum.KeyCode.", "")
				or "None"
		end
	end
end)
-- ughhh im such a webson...
smoothFactorInput.FocusLost:Connect(function()
	local v = tonumber(smoothFactorInput.Text)
	if v and v > 0 and v <= 1 then
		smoothingFactor = v
	else
		smoothFactorInput.Text = tostring(smoothingFactor)
	end
end)

yOffset = yOffset + 100

-- ======= Action rows (Sit / Lay) =======
local actionYOffset = yOffset + 5
for actionKey, action in pairs(actions) do
	local frame = Instance.new("Frame")
	frame.Name = actionKey .. "Frame"
	frame.Size = UDim2.new(1, -10, 0, 70)
	frame.Position = UDim2.new(0, 5, 0, actionYOffset)
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.BorderSizePixel = 1
	frame.BorderColor3 = Color3.fromRGB(80, 80, 80)
	frame.Parent = scrollFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 100, 0, 20)
	nameLabel.Position = UDim2.new(0, 5, 0, 5)
	nameLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 12
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Text = action.name
	nameLabel.BorderSizePixel = 0
	nameLabel.Parent = frame

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ToggleBtn"
	toggleBtn.Size = UDim2.new(0, 60, 0, 20)
	toggleBtn.Position = UDim2.new(1, -65, 0, 5)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.TextSize = 11
	toggleBtn.Font = Enum.Font.Gotham
	toggleBtn.Text = action.enabled and "ON" or "OFF"
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Parent = frame

	local keyLabel = Instance.new("TextLabel")
	keyLabel.Size = UDim2.new(0, 50, 0, 18)
	keyLabel.Position = UDim2.new(0, 5, 0, 30)
	keyLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	keyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	keyLabel.TextSize = 10
	keyLabel.Font = Enum.Font.Gotham
	keyLabel.Text = "Key:"
	keyLabel.BorderSizePixel = 0
	keyLabel.Parent = frame

	local keyInput = Instance.new("TextBox")
	keyInput.Name = "ActionKeyInput"
	keyInput.Size = UDim2.new(0, 70, 0, 18)
	keyInput.Position = UDim2.new(0, 55, 0, 30)
	keyInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyInput.TextSize = 10
	keyInput.Font = Enum.Font.Gotham
	keyInput.Text = tostring(action.key):gsub("Enum.KeyCode.", "")
	keyInput.BorderSizePixel = 0
	keyInput.Parent = frame

	toggleBtn.MouseButton1Click:Connect(function()
		action.enabled = not action.enabled
		toggleBtn.BackgroundColor3 = action.enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(120, 80, 80)
		toggleBtn.Text = action.enabled and "ON" or "OFF"
	end)

	keyInput.FocusLost:Connect(function()
		local kc = Enum.KeyCode[keyInput.Text:upper()]
		if kc then action.key = kc; keyInput.Text = tostring(kc):gsub("Enum.KeyCode.", "")
		else keyInput.Text = tostring(action.key):gsub("Enum.KeyCode.", "") end
	end)
	keyInput.Focused:Connect(function()
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				action.key = input.KeyCode
				keyInput.Text = tostring(action.key):gsub("Enum.KeyCode.", "")
				conn:Disconnect()
			end
		end)
	end)

	actionYOffset = actionYOffset + 80
end

yOffset = actionYOffset + 10
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset + 20)

-- Fling button
flingToggle.MouseButton1Click:Connect(function()
	toggleFling()
	flingToggle.BackgroundColor3 = hiddenfling and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(100, 30, 30)
	flingToggle.Text = hiddenfling and "ON" or "OFF"
end)

-- ======= Input =======
UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

	-- Smoothing toggle keybind
	if smoothBoundKey and input.KeyCode == smoothBoundKey then
		setSmoothingEnabled(not accelSmoothing)
	end

	-- Movement keys
	for _, data in pairs(movements) do
		if input.KeyCode == data.currentKey then
			active[input.KeyCode] = true
			-- burst impulse only when smoothing is OFF
			if not accelSmoothing then
				applyImpulseForHeld()
			end
		end
	end

	-- Actions
	for _, action in pairs(actions) do
		if action.enabled and input.KeyCode == action.key then
			pcall(action.callback)
		end
	end

	-- Fling key
	if input.KeyCode == flingKey then
		toggleFling()
		flingToggle.BackgroundColor3 = hiddenfling and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(100, 30, 30)
		flingToggle.Text = hiddenfling and "ON" or "OFF"
	end
end)

UserInputService.InputEnded:Connect(function(input)
	active[input.KeyCode] = nil
end)

-- ======= Heartbeat: smoothing lerp =======
RunService.Heartbeat:Connect(function(dt)
	if not accelSmoothing then
		smoothedDV = Vector3.zero  -- decay buffer when off
		return
	end

	local hrp = getHRP()
	if not hrp then return end

	-- build target from all currently held movement keys
	local target = Vector3.zero
	for movementType, data in pairs(movements) do
		if not data.enabled then continue end
		if not active[data.currentKey] then continue end
		if movementType == "forward"  then target += hrp.CFrame.LookVector  *  data.dv
		elseif movementType == "backward" then target += -hrp.CFrame.LookVector *  data.dv
		elseif movementType == "left"     then target += -hrp.CFrame.RightVector *  data.dv
		elseif movementType == "right"    then target +=  hrp.CFrame.RightVector *  data.dv
		elseif movementType == "up"       then target +=  hrp.CFrame.UpVector    *  data.dv
		elseif movementType == "down"     then target += -hrp.CFrame.UpVector    *  data.dv
		end
	end

	-- lerp toward target
	smoothedDV = smoothedDV:Lerp(target, math.clamp(smoothingFactor, 0, 1))

	-- apply scaled impulse
	if smoothedDV.Magnitude > 0 then
		local scale = math.min(1, math.max(0.001, dt * 60))
		pcall(function()
			hrp:ApplyImpulse(hrp.AssemblyMass * smoothedDV * scale)
		end)
	end
end)

-- end of script
