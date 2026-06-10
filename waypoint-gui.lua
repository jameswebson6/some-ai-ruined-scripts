-- Waypoint GUI v7 (ESP + Save/Load + Toggle)  -- GAME-DEPENDENT Edition
-- Solara ready~ :3

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

--------------------------------------------------
-- GAME-DEPENDENT SAVE FILE
--------------------------------------------------
local placeId = tostring(game.PlaceId)
local saveFile = "waypoints_" .. placeId .. ".json"
--------------------------------------------------
-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WaypointGUI"
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 420)
Frame.Position = UDim2.new(0, 20, 0.5, -210)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Waypoints"
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Color selector grid
local ColorSelector = Instance.new("Frame")
ColorSelector.Size = UDim2.new(1, -10, 0, 80)
ColorSelector.Position = UDim2.new(0, 5, 0, 35)
ColorSelector.BackgroundTransparency = 1
ColorSelector.Parent = Frame

local GridLayout = Instance.new("UIGridLayout")
GridLayout.Parent = ColorSelector
GridLayout.CellSize = UDim2.new(0.32, 0, 0.45, 0)
GridLayout.FillDirectionMaxCells = 3
GridLayout.CellPadding = UDim2.new(0.02, 0, 0.05, 0)

-- Colors
local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 128, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(200, 0, 255),
    Color3.fromRGB(255, 128, 0),
}

local selectedColor = nil
local adding = false
local waypoints = {}
local guiEnabled = true

-- Scrollable list
local WaypointList = Instance.new("ScrollingFrame")
WaypointList.Size = UDim2.new(1, -10, 1, -125)
WaypointList.Position = UDim2.new(0, 5, 0, 120)
WaypointList.CanvasSize = UDim2.new(0,0,0,0)
WaypointList.BackgroundTransparency = 1
WaypointList.ScrollBarThickness = 6
WaypointList.AutomaticCanvasSize = Enum.AutomaticSize.Y
WaypointList.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = WaypointList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0,5)

-- Save waypoints to file
local function saveWaypoints()
    local data = {}
    for _,wp in ipairs(waypoints) do
        table.insert(data, {
            name = wp.label.Text,
            pos = {wp.part.Position.X, wp.part.Position.Y, wp.part.Position.Z},
            color = {wp.part.Color.R, wp.part.Color.G, wp.part.Color.B}
        })
    end
    if writefile then
        writefile(saveFile, HttpService:JSONEncode(data))
    end
end

-- Load waypoints from file
local function loadWaypoints()
    if readfile and isfile and isfile(saveFile) then
        local data = HttpService:JSONDecode(readfile(saveFile))
        for _,info in ipairs(data) do
            local pos = Vector3.new(info.pos[1], info.pos[2], info.pos[3])
            local color = Color3.new(info.color[1], info.color[2], info.color[3])
            -- direct create with saved name
            local function spawnSaved()
                local part = Instance.new("Part")
                part.Size = Vector3.new(2,2,2)
                part.Shape = Enum.PartType.Ball
                part.Anchored = true
                part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Color = color
                part.Position = pos
                part.Parent = workspace

                local light = Instance.new("PointLight")
                light.Color = color
                light.Range = 15
                light.Brightness = 5
                light.Parent = part

                -- Billboard ESP
                local billboard = Instance.new("BillboardGui")
                billboard.Size = UDim2.new(0,100,0,30)
                billboard.AlwaysOnTop = true
                billboard.Adornee = part
                billboard.Parent = part

                local text = Instance.new("TextLabel")
                text.Size = UDim2.new(1,0,1,0)
                text.BackgroundTransparency = 1
                text.Text = info.name
                text.TextColor3 = color
                text.Font = Enum.Font.GothamBold
                text.TextScaled = true
                text.Parent = billboard

                -- GUI entry
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1,0,0,30)
                container.BackgroundTransparency = 1
                container.Parent = WaypointList

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.5, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = info.name
                label.TextColor3 = color
                label.Font = Enum.Font.Gotham
                label.TextScaled = true
                label.Parent = container

                local toggle = Instance.new("TextButton")
                toggle.Size = UDim2.new(0.25, 0, 1, 0)
                toggle.Position = UDim2.new(0.5, 0, 0, 0)
                toggle.BackgroundColor3 = Color3.fromRGB(0,100,0)
                toggle.Text = "ON"
                toggle.TextColor3 = Color3.new(1,1,1)
                toggle.Font = Enum.Font.GothamBold
                toggle.TextScaled = true
                toggle.Parent = container

                local active = true
                toggle.MouseButton1Click:Connect(function()
                    active = not active
                    part.Transparency = active and 0 or 1
                    light.Enabled = active
                    billboard.Enabled = active
                    toggle.Text = active and "ON" or "OFF"
                    toggle.BackgroundColor3 = active and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
                end)

                local delete = Instance.new("TextButton")
                delete.Size = UDim2.new(0.25, 0, 1, 0)
                delete.Position = UDim2.new(0.75, 0, 0, 0)
                delete.BackgroundColor3 = Color3.fromRGB(200,0,0)
                delete.Text = "DEL"
                delete.TextColor3 = Color3.new(1,1,1)
                delete.Font = Enum.Font.GothamBold
                delete.TextScaled = true
                delete.Parent = container

                delete.MouseButton1Click:Connect(function()
                    part:Destroy()
                    container:Destroy()
                    for i=#waypoints,1,-1 do
                        if waypoints[i].part == part then
                            table.remove(waypoints, i)
                            break
                        end
                    end
                    saveWaypoints()
                end)

                table.insert(waypoints, {part=part, label=label, toggle=toggle, delete=delete})
            end
            spawnSaved()
        end
    end
end

-- Create waypoint function (manual add)
local function createWaypoint(position, color)
    local name = "Waypoint " .. tostring(#waypoints+1)

    -- rename prompt
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 150, 0, 30)
    input.Position = UDim2.new(0.5, -75, 0.5, -15)
    input.Text = "Enter Name"
    input.PlaceholderText = "Waypoint Name"
    input.TextScaled = true
    input.TextColor3 = Color3.new(1,1,1)
    input.BackgroundColor3 = Color3.fromRGB(50,50,50)
    input.ClearTextOnFocus = true
    input.Parent = ScreenGui
    input:CaptureFocus()

    local renamed = false
    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            if input.Text ~= "" then
                name = input.Text
            end
            input:Destroy()
            renamed = true
        end
    end)

    repeat task.wait() until renamed

    local part = Instance.new("Part")
    part.Size = Vector3.new(2,2,2)
    part.Shape = Enum.PartType.Ball
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Position = position
    part.Parent = workspace

    local light = Instance.new("PointLight")
    light.Color = color
    light.Range = 15
    light.Brightness = 5
    light.Parent = part

    -- Billboard ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0,100,0,30)
    billboard.AlwaysOnTop = true
    billboard.Adornee = part
    billboard.Parent = part

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = name
    text.TextColor3 = color
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
    text.Parent = billboard

    -- GUI entry
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1,0,0,30)
    container.BackgroundTransparency = 1
    container.Parent = WaypointList

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = color
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.Parent = container

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.25, 0, 1, 0)
    toggle.Position = UDim2.new(0.5, 0, 0, 0)
    toggle.BackgroundColor3 = Color3.fromRGB(0,100,0)
    toggle.Text = "ON"
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.GothamBold
    toggle.TextScaled = true
    toggle.Parent = container

    local active = true
    toggle.MouseButton1Click:Connect(function()
        active = not active
        part.Transparency = active and 0 or 1
        light.Enabled = active
        billboard.Enabled = active
        toggle.Text = active and "ON" or "OFF"
        toggle.BackgroundColor3 = active and Color3.fromRGB(0,100,0) or Color3.fromRGB(100,0,0)
    end)

    local delete = Instance.new("TextButton")
    delete.Size = UDim2.new(0.25, 0, 1, 0)
    delete.Position = UDim2.new(0.75, 0, 0, 0)
    delete.BackgroundColor3 = Color3.fromRGB(200,0,0)
    delete.Text = "DEL"
    delete.TextColor3 = Color3.new(1,1,1)
    delete.Font = Enum.Font.GothamBold
    delete.TextScaled = true
    delete.Parent = container

    delete.MouseButton1Click:Connect(function()
        part:Destroy()
        container:Destroy()
        for i=#waypoints,1,-1 do
            if waypoints[i].part == part then
                table.remove(waypoints, i)
                break
            end
        end
        saveWaypoints()
    end)

    table.insert(waypoints, {part=part, label=label, toggle=toggle, delete=delete})
    saveWaypoints()
end

-- Color buttons
for _,color in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,0,0,0)
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.Parent = ColorSelector

    btn.MouseButton1Click:Connect(function()
        selectedColor = color
        adding = true
    end)
end

-- Place in world
Mouse.Button1Down:Connect(function()
    if adding and selectedColor then
        local target = Mouse.Hit
        if target then
            createWaypoint(target.p, selectedColor)
        end
        adding = false
        selectedColor = nil
    end
end)

-- Toggle GUI visibility with `
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Backquote then
        guiEnabled = not guiEnabled
        ScreenGui.Enabled = guiEnabled
        for _,wp in ipairs(waypoints) do
            if wp.part:FindFirstChildOfClass("BillboardGui") then
                wp.part.BillboardGui.Enabled = guiEnabled
            end
        end
    end
end)

-- Load saved
loadWaypoints()
