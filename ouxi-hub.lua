-- Please note that this is NOT my script, I found this at https://scriptblox.com/script/Elemental-Powers-Tycoon-OuxiHub-equip-any-power-11360. All I have done is manually improve it, it's under this repository because ai helped me fix mispellings and powers to add.
-- This is for Elemental Powers Tycoon.

-- Instances: 29 | Scripts: 2 | Modules: 0
local G2L = {};

-- StarterGui.Ouxi
G2L["1"] = Instance.new("ScreenGui", game.CoreGui);
G2L["1"]["IgnoreGuiInset"] = true;
G2L["1"]["AutoLocalize"] = false;
G2L["1"]["ScreenInsets"] = Enum.ScreenInsets.DeviceSafeInsets;
G2L["1"]["Name"] = [[Ouxi]];
G2L["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
G2L["1"]["ResetOnSpawn"] = false;

-- StarterGui.Ouxi.UI
G2L["2"] = Instance.new("Frame", G2L["1"]);
G2L["2"]["ZIndex"] = 999999999;
G2L["2"]["BorderSizePixel"] = 0;
G2L["2"]["BackgroundColor3"] = Color3.fromRGB(25, 25, 25);
G2L["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["2"]["Size"] = UDim2.new(0, 304, 0, 275);
G2L["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["2"]["Name"] = [[UI]];

-- StarterGui.Ouxi.UI.UICorner
G2L["3"] = Instance.new("UICorner", G2L["2"]);
G2L["3"]["CornerRadius"] = UDim.new(0, 4);

-- StarterGui.Ouxi.UI.Header
G2L["4"] = Instance.new("Frame", G2L["2"]);
G2L["4"]["ZIndex"] = 999999999;
G2L["4"]["BorderSizePixel"] = 0;
G2L["4"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["4"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["4"]["Size"] = UDim2.new(0.9900000095367432, 0, 0, 32);
G2L["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["4"]["Position"] = UDim2.new(0.5, 0, 0, 0);
G2L["4"]["Name"] = [[Header]];

-- StarterGui.Ouxi.UI.Header.NName
G2L["5"] = Instance.new("TextLabel", G2L["4"]);
G2L["5"]["ZIndex"] = 999999999;
G2L["5"]["BorderSizePixel"] = 0;
G2L["5"]["BackgroundColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["5"]["TextSize"] = 14;
G2L["5"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["5"]["Size"] = UDim2.new(0, 207, 0, 32);
G2L["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["5"]["Text"] = [[OuxiHub | Elemental Powers]];
G2L["5"]["Name"] = [[NName]];
G2L["5"]["BackgroundTransparency"] = 1;

-- StarterGui.Ouxi.UI.Header.UICorner
G2L["6"] = Instance.new("UICorner", G2L["4"]);
G2L["6"]["CornerRadius"] = UDim.new(0, 4);

-- StarterGui.Ouxi.UI.Header.Frame
G2L["7"] = Instance.new("Frame", G2L["4"]);
G2L["7"]["BorderSizePixel"] = 0;
G2L["7"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["7"]["Size"] = UDim2.new(1, 0, 0.34375, 0);
G2L["7"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["7"]["Position"] = UDim2.new(0, 0, 0.65625, 0);

-- StarterGui.Ouxi.UI.Powers
G2L["8"] = Instance.new("ScrollingFrame", G2L["2"]);
G2L["8"]["Active"] = true;
G2L["8"]["ZIndex"] = 999999999;
G2L["8"]["BorderSizePixel"] = 0;
G2L["8"]["BackgroundColor3"] = Color3.fromRGB(20, 20, 20);
G2L["8"]["AnchorPoint"] = Vector2.new(0.5, 0);
G2L["8"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
G2L["8"]["Size"] = UDim2.new(0, 285, 0, 210);
G2L["8"]["ScrollBarImageColor3"] = Color3.fromRGB(57, 57, 57);
G2L["8"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["8"]["ScrollBarThickness"] = 5;
G2L["8"]["Position"] = UDim2.new(0.5, 0, 0.1850000023841858, 0);
G2L["8"]["Name"] = [[Powers]];

-- StarterGui.Ouxi.UI.Powers.UIListLayout
G2L["9"] = Instance.new("UIListLayout", G2L["8"]);
G2L["9"]["Padding"] = UDim.new(0, 7);
G2L["9"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

-- StarterGui.Ouxi.UI.Powers.UIPadding
G2L["a"] = Instance.new("UIPadding", G2L["8"]);
G2L["a"]["PaddingTop"] = UDim.new(0, 7);
G2L["a"]["PaddingLeft"] = UDim.new(0, 7);

-- StarterGui.Ouxi.UI.Powers.Type
G2L["b"] = Instance.new("Frame", G2L["8"]);
G2L["b"]["ZIndex"] = 999999999;
G2L["b"]["BorderSizePixel"] = 0;
G2L["b"]["BackgroundColor3"] = Color3.fromRGB(15, 15, 15);
G2L["b"]["Size"] = UDim2.new(0, 264, 0, 26);
G2L["b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["b"]["Name"] = [[Type]];

-- StarterGui.Ouxi.UI.Powers.Type.UICorner
G2L["c"] = Instance.new("UICorner", G2L["b"]);
G2L["c"]["CornerRadius"] = UDim.new(0, 4);

-- StarterGui.Ouxi.UI.Powers.Type.TextLabel
G2L["d"] = Instance.new("TextLabel", G2L["b"]);
G2L["d"]["ZIndex"] = 999999999;
G2L["d"]["BorderSizePixel"] = 0;
G2L["d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["d"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["d"]["TextSize"] = 12;
G2L["d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["d"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["d"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["d"]["Text"] = [[Type ▼]];
G2L["d"]["BackgroundTransparency"] = 1;

-- StarterGui.Ouxi.UI.Powers.Type.TextLabel.UIPadding
G2L["e"] = Instance.new("UIPadding", G2L["d"]);
G2L["e"]["PaddingLeft"] = UDim.new(0, 7);

-- StarterGui.Ouxi.UI.Powers.Type.UIStroke
G2L["f"] = Instance.new("UIStroke", G2L["b"]);
G2L["f"]["Color"] = Color3.fromRGB(44, 44, 44);

-- StarterGui.Ouxi.UI.Powers.Power
G2L["10"] = Instance.new("Frame", G2L["8"]);
G2L["10"]["ZIndex"] = 999999999;
G2L["10"]["BorderSizePixel"] = 0;
G2L["10"]["BackgroundColor3"] = Color3.fromRGB(17, 17, 17);
G2L["10"]["Size"] = UDim2.new(0, 264, 0, 26);
G2L["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["10"]["Name"] = [[Power]];

-- StarterGui.Ouxi.UI.Powers.Power.UICorner
G2L["11"] = Instance.new("UICorner", G2L["10"]);
G2L["11"]["CornerRadius"] = UDim.new(0, 4);

-- StarterGui.Ouxi.UI.Powers.Power.Button
G2L["12"] = Instance.new("ImageButton", G2L["10"]);
G2L["12"]["ZIndex"] = 999999999;
G2L["12"]["BorderSizePixel"] = 0;
G2L["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["12"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["12"]["Name"] = [[Button]];
G2L["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["12"]["BackgroundTransparency"] = 1;

-- StarterGui.Ouxi.UI.Powers.Power.TextLabel
G2L["13"] = Instance.new("TextLabel", G2L["10"]);
G2L["13"]["ZIndex"] = 999999999;
G2L["13"]["BorderSizePixel"] = 0;
G2L["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["13"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["13"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["13"]["TextSize"] = 12;
G2L["13"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
G2L["13"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["13"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["13"]["Text"] = [[Power]];
G2L["13"]["BackgroundTransparency"] = 1;

-- StarterGui.Ouxi.UI.Powers.Power.TextLabel.UIPadding
G2L["14"] = Instance.new("UIPadding", G2L["13"]);
G2L["14"]["PaddingLeft"] = UDim.new(0, 40);

-- StarterGui.Ouxi.UI.Powers.Power.UIStroke
G2L["15"] = Instance.new("UIStroke", G2L["10"]);
G2L["15"]["Color"] = Color3.fromRGB(44, 44, 44);

-- StarterGui.Ouxi.UI.Header
G2L["16"] = Instance.new("TextLabel", G2L["2"]);
G2L["16"]["ZIndex"] = 999999999;
G2L["16"]["BorderSizePixel"] = 0;
G2L["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["16"]["TextXAlignment"] = Enum.TextXAlignment.Left;
G2L["16"]["FontFace"] = Font.new([[rbxasset://fonts/families/GothamSSm.json]], Enum.FontWeight.Regular, Enum.FontStyle.Normal);
G2L["16"]["TextSize"] = 10;
G2L["16"]["TextColor3"] = Color3.fromRGB(201, 201, 201);
G2L["16"]["Size"] = UDim2.new(0, 52, 0, 18);
G2L["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["16"]["Text"] = [[Powers :]];
G2L["16"]["Name"] = [[Header]];
G2L["16"]["BackgroundTransparency"] = 1;
G2L["16"]["Position"] = UDim2.new(0.032894738018512726, 0, 0.11636363714933395, 0);

-- StarterGui.Ouxi.UI.Handler
G2L["17"] = Instance.new("LocalScript", G2L["2"]);
G2L["17"]["Name"] = [[Handler]];

-- StarterGui.Ouxi.UI.Dragify
G2L["18"] = Instance.new("LocalScript", G2L["2"]);
G2L["18"]["Name"] = [[Dragify]];

-- StarterGui.Ouxi.UI.Close
G2L["19"] = Instance.new("Frame", G2L["2"]);
G2L["19"]["ZIndex"] = 999999999;
G2L["19"]["BorderSizePixel"] = 0;
G2L["19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["19"]["BackgroundTransparency"] = 1;
G2L["19"]["Size"] = UDim2.new(0, 32, 0, 32);
G2L["19"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["19"]["Position"] = UDim2.new(0.8930920958518982, 0, 0, 0);
G2L["19"]["Name"] = [[Close]];

-- StarterGui.Ouxi.UI.Close.ImageButton
G2L["1a"] = Instance.new("ImageButton", G2L["19"]);
G2L["1a"]["ZIndex"] = 999999999;
G2L["1a"]["BorderSizePixel"] = 0;
G2L["1a"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1a"]["Size"] = UDim2.new(1, 0, 1, 0);
G2L["1a"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1a"]["BackgroundTransparency"] = 1;

-- StarterGui.Ouxi.UI.Close.ImageLabel
G2L["1b"] = Instance.new("ImageLabel", G2L["19"]);
G2L["1b"]["ZIndex"] = 999999999;
G2L["1b"]["BorderSizePixel"] = 0;
G2L["1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1b"]["ImageColor3"] = Color3.fromRGB(255, 0, 0);
G2L["1b"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1b"]["Image"] = [[rbxassetid://7072720961]];
G2L["1b"]["Size"] = UDim2.new(0.5, 0, 0.5, 0);
G2L["1b"]["BorderColor3"] = Color3.fromRGB(0, 0, 0);
G2L["1b"]["BackgroundTransparency"] = 1;
G2L["1b"]["Position"] = UDim2.new(0.5, 0, 0.5, 0);

-- StarterGui.Ouxi.UI.DropShadow
G2L["1c"] = Instance.new("ImageLabel", G2L["2"]);
G2L["1c"]["ZIndex"] = 0;
G2L["1c"]["BorderSizePixel"] = 0;
G2L["1c"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1c"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1c"]["Image"] = [[rbxassetid://297694300]];
G2L["1c"]["Size"] = UDim2.new(1.2441110610961914, 0, 1.2205359935760498, 0);
G2L["1c"]["Name"] = [[DropShadow]];
G2L["1c"]["BackgroundTransparency"] = 1;
G2L["1c"]["Position"] = UDim2.new(0.5067567229270935, 0, 0.5024591684341431, 0);

-- StarterGui.Ouxi.UI.DropShadow
G2L["1d"] = Instance.new("ImageLabel", G2L["2"]);
G2L["1d"]["ZIndex"] = 0;
G2L["1d"]["BorderSizePixel"] = 0;
G2L["1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
G2L["1d"]["AnchorPoint"] = Vector2.new(0.5, 0.5);
G2L["1d"]["Image"] = [[rbxassetid://297694300]];
G2L["1d"]["Size"] = UDim2.new(1.2441110610961914, 0, 1.2205359935760498, 0);
G2L["1d"]["Name"] = [[DropShadow]];
G2L["1d"]["BackgroundTransparency"] = 1;
G2L["1d"]["Position"] = UDim2.new(0.5067567229270935, 0, 0.5024591684341431, 0);

-- StarterGui.Ouxi.UI.Handler
local function C_17()
local script = G2L["17"];

	local powers = {
		["Lava"] = {
			[1] = "Lava Katana",
			[2] = "Lava Ball",
			[3] = "Magma Fists",
			[4] = "Lava Dash",
			[5] = "Volcano Sentry",
			[6] = "Magma Spikes",
			[7] = "Nibiru"
		},
        ["Water"] = {
            [1] = "Atlan's Trident",
            [2] = "Jellyfish",
            [3] = "Bubbles",
            [4] = "Bubble Dash",
            [5] = "Aqua Trident",
            [6] = "Water Beam",
            [7] = "Big Tsunami"
        },
		["Bone"] = {
			[1] = "Bone Scythe",
			[2] = "Blaster",
			[3] = "Bones Barrage",
			[4] = "Flying Bone",
			[5] = "Bone Surge",
			[6] = "Twin Blasters",
			[7] = "Judgement Blast"
		},
		["Darkness"] = {
			[1] = "Shadow Sword",
			[2] = "Unseen Hands",
			[3] = "Unseen Barrage",
			[4] = "Dark Duo",
			[5] = "Abyss",
			[6] = "Dark Hold",
			[7] = "Dark Arc"
		},
		["Light"] = {
			[1] = "Light Saber",
			[2] = "Light Ball",
			[3] = "Light Orbs",
			[4] = "Blinding Light",
			[5] = "Shooting Star",
			[6] = "Light Speed",
			[7] = "Light Beam"
		},
		["Nature"] = {
			[1] = "Christmas Tree Sword",
			[2] = "Plantoid",
			[3] = "Spore Bombs",
			[4] = "Nature's Blessing",
			[5] = "Nuclear Spore",
			[6] = "Pine Burst",
			[7] = "Nature's Wrath"
		},
		["Ice"] = {
			[1] = "Frost Staff",
			[2] = "Frost Fire Ball",
			[3] = "Ice Disk",
			[4] = "Frost Fire Ball",
			[5] = "Snow Ball",
			[6] = "Ultracold Aura",
			[7] = "Ice Spikes"
		},
		["Thunder"] = {
			[1] = "Thunder Staff",
			[2] = "Bolt",
			[3] = "Barrage",
			[4] = "Discharge",
			[5] = "Flying Nimbus",
			[6] = "Lightning Strike",
			[7] = "Storm"
		},
		["Earth"] = {
			[1] = "Tectonic Hammer",
			[2] = "Stone Throw",
			[3] = "Rocks Barrage",
			[4] = "Large Boulder",
			[5] = "Burrow",
			[6] = "Stone Henge",
			[7] = "Earth Spikes"
		},
		["Fire"] = {
			[1] = "Fire Sword",
			[2] = "Fire Ball",
			[3] = "Fire Fly",
			[4] = "Fire Bomb",
			[5] = "Comet",
			[6] = "Combust",
			[7] = "Fire Shower"
		},
        ["Super Sonic"] = {
			[1] = "Sonic Blaster",
			[2] = "Sonic Barrage",
			[3] = "Sonic Twister",
			[4] = "Rebound Blast",
			[5] = "Rebound Teleport",
			[6] = "Sonic Boom",
			[7] = "Super Sonic Wave" 
		},
          ["experimental"] = {
			[1] = "Robux Beam",
			[2] = "Cruel Sun",
            [3] = "Cold Slap",
            [4] = "Omega Slap",
            [5] = "Time Slap",
            [6] = "Cosmic Anvil",
            [7] = "Jay",
            [8] = "Health Potion",
            [9] = "Speed Potion",
            [10] = "Portal Potion"
          },
            ["Rebirth"] = {
			[1] = "Dark Flames",
			[2] = "Draedon's Tech",
            [3] = "Yoru",
            [4] = "Plasma Orbs",
            [5] = "Undead Staff",
            [6] = "Elysian Beam",
            [7] = "Bubble Flail",
            [8] = "Poison Serpent",
            [9] = "Sonar"
          },
		["Technology"] = {
			[1] = "Hyper Sword",
			[2] = "Photon Blast",
			[3] = "Twin-Photon Blast",
			[4] = "Tesla Turret",
			[5] = "Orbital",
			[6] = "Tesseract",
			[7] = "Hyper Slash"
		},
		["Gravity"] = {
			[1] = "Gravity Katana",
			[2] = "Heavy Infliction",
			[3] = "Tectonic Barrage",
			[4] = "Gravity Orb",
			[5] = "Tectonic Burst",
			[6] = "Zero Gravity",
			[7] = "Gravity Globe"
		},
		["Time"] = {
			[1] = "Time Scepter",
			[2] = "Temporal Gate",
			[3] = "Warp Barrage",
			[4] = "Tempo Beam",
			[5] = "Time Trap",
			[6] = "Warp Bomb",
			[7] = "Grand Clock",
            [8] = "Time Slap"
		},
		["Crystal"] = {
			[1] = "Crystal Cleaver",
			[2] = "Crystal Mine",
			[3] = "Energy Crash",
			[4] = "Energy Crown",
			[5] = "Crystal Eruption",
			[6] = "Energy Crystal",
			[7] = "Crystal Surge"
		},
		["Venom"] = {
			[1] = "Venom Blade",
			[2] = "Poison Bullet",
			[3] = "Acid Rain",
			[4] = "Venom Stream",
			[5] = "Hardened Venom",
			[6] = "Poison Demon",
			[7] = "Bubbling Venom"
		},
		["Devil"] = {
			[1] = "Devil Sword",
			[2] = "Evil Bullet",
			[3] = "Fangs Barrage",
			[4] = "Evil Flash",
			[5] = "Demon Orb",
			[6] = "Demon Lock",
			[7] = "Dark Tsunami"
		},
		["Space"] = {
			[1] = "Space Gun",
			[2] = "Blackhole Orb",
			[3] = "Moon Splitter",
			[4] = "Asteroid Belt",
			[5] = "Meteor Jam",
			[6] = "Cosmic Remote",
			[7] = "Space Saucer"
		}
	}
	
	local function addLabel(string)
		local label = script.Parent.Powers.Type label.Visible = false
		local new = label:Clone()
		new.Visible = true
		new.Name = string
		new.TextLabel.Text = string.." ▼"
		new.Parent = label.Parent
	end
	
	local function addButton(string)
		local btn = script.Parent.Powers.Power btn.Visible = false
		local new = btn:Clone()
		new.Visible = true
		new.Name = string
		new.TextLabel.Text = string
		new.Parent = btn.Parent
		
		new.Button.MouseButton1Click:Connect(function()
			if game.PlaceId == 10253248401 then
				local args = {
					[1] = "equip_mystery_spell",
					[2] = string
				}
				game:GetService("ReplicatedStorage").RemoteEvent:FireServer(unpack(args))
			else
				print("Equiped", string)
			end
		end)
	end
	
	for key,value in pairs(powers) do
		addLabel(key)
		for i,value2 in pairs(value) do
			addButton(value2)
		end
	end
	
	script.Parent.Close.ImageButton.MouseButton1Click:Connect(function()
		script.Parent.Parent:Destroy()
		if script.Parent.Parent then
			script.Parent.Parent.Enabled = false
			if script.Parent.Parent.Enabled == true then
				script.Parent:Destroy()
				if script.Parent then
					script.Parent.Visible = false
					if script.Parent.Visible == true then
						print("[Ouxi]: Failed to close")
					end
				end
			end
		end
	end)

end;
task.spawn(C_17);
-- StarterGui.Ouxi.UI.Dragify
local function C_18()
local script = G2L["18"];
	local UserInputService = game:GetService("UserInputService")
	
	local gui = script.Parent
	
	local dragging
	local dragInput
	local dragStart
	local startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end;
task.spawn(C_18);

return G2L["1"], require;
