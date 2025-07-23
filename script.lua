local teamCheck = false
local fov = 100
local smoothing = 0.03
local predictionFactor = 0.1  -- Adjust this factor to improve prediction accuracy
local highlightEnabled = false  -- Variable to enable or disable target highlighting. Change to False if using an ESP script.
local lockPart = "Head"
 
local Toggle = false  -- Enable or disable toggle mode
local ToggleKey = Enum.KeyCode.E  -- Choose the key for toggling aimbot lock
 
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
 
StarterGui:SetCore("SendNotification", {
    Title = "Nova Aimbot",
    Text = "Nova Aimbot has succesfully loaded!",
    Icon = "rbxassetid://139544195716715", 
    Duration = 4
})

 
local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 1
FOVring.Radius = fov
FOVring.Transparency = 0.8
FOVring.Color = Color3.fromRGB(255, 128, 128)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
 
local currentTarget = nil
local aimbotEnabled = true
local toggleState = false  -- Variable to keep track of toggle state
local debounce = false  -- Debounce variable


-- Settings
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "CounterBlox | Nova ",
    LoadingTitle = "Loading UI.",
    LoadingSubtitle = "by zxbnzlol1 dsc",
    Theme = "Default",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = nil,
       FileName = "Big Hub"
    },
    Discord = {
       Enabled = false,
       Invite = "noinvitelink",
       RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
       Title = "Untitled",
       Subtitle = "Key System",
       Note = "No method of obtaining the key is provided",
       FileName = "Key",
       SaveKey = true,
       GrabKeyFromSite = false,
       Key = {"Hello"}
    }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local UItab = Window:CreateTab("Visuals", 4483362458)
local ThemesTab = Window:CreateTab("Themes", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local UpdatesTab = Window:CreateTab("Updates", 4483362458)



local SettingsConfigSection = SettingsTab:CreateSection("Config Settings")
-- Add a button to save the current configuration
local SaveButton = SettingsTab:CreateButton({
    Name = "Save Current Configuration",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "Configuration Saved!",
            Content = "Your settings have been saved successfully.",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- Add a button to load the saved configuration
local LoadButton = SettingsTab:CreateButton({
    Name = "Load Saved Configuration",
    Callback = function()
        Rayfield:LoadConfiguration()
        Rayfield:Notify({
            Title = "Configuration Loaded",
            Content = "Your settings have been loaded successfully.",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")



-- GUI container
local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "FPSCounterGUI"
fpsGui.ResetOnSpawn = false
fpsGui.IgnoreGuiInset = true
fpsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fpsGui.Parent = PlayerGui

-- Draggable frame
local dragFrame = Instance.new("Frame")
dragFrame.Size = UDim2.new(0, 200, 0, 30)
dragFrame.Position = UDim2.new(1, -210, 0, 10)
dragFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dragFrame.BackgroundTransparency = 0.2
dragFrame.BorderSizePixel = 0
dragFrame.Active = true
dragFrame.Draggable = true
dragFrame.Visible = false
dragFrame.Parent = fpsGui

-- Label inside frame
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 1, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextStrokeTransparency = 0.5
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = dragFrame

-- FPS logic
local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
	if not dragFrame.Visible then return end

	frameCount += 1
	local now = tick()
	if now - lastTime >= 1 then
		local fps = math.floor(frameCount / (now - lastTime))

		local pingValue = 0
		local perfStats = Stats:FindFirstChild("PerformanceStats")
		local pingStat = perfStats and perfStats:FindFirstChild("Ping")
		if pingStat and pingStat:IsA("NumberValue") then
			pingValue = math.floor(pingStat.Value)
		end

		fpsLabel.Text = "FPS: " .. fps .. " | Ping: " .. pingValue .. "ms"

		if pingValue <= 50 then
			fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
		elseif pingValue <= 100 then
			fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
		else
			fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
		end

		frameCount = 0
		lastTime = now
	end
end)

-- Toggle in Rayfield
SettingsTab:CreateToggle({
	Name = "Show FPS & Ping Counter",
	CurrentValue = false,
	Flag = "ShowFPSCounter",
	Callback = function(state)
		dragFrame.Visible = state
	end,
})

-- Theme Selector Dropdown
local ThemeDropdown = ThemesTab:CreateDropdown({
    Name = "Select Theme",
    Options = {
        "Default", 
        "Amber Glow", 
        "Amethyst", 
        "Bloom", 
        "Dark Blue", 
        "Green", 
        "Light", 
        "Ocean", 
        "Serenity"
    },
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Flag = "ThemeSelector",
    Callback = function(Selected)
        local themeMap = {
            ["Default"] = "Default",
            ["Amber Glow"] = "AmberGlow",
            ["Amethyst"] = "Amethyst",
            ["Bloom"] = "Bloom",
            ["Dark Blue"] = "DarkBlue",
            ["Green"] = "Green",
            ["Light"] = "Light",
            ["Ocean"] = "Ocean",
            ["Serenity"] = "Serenity"
        }
        
        local themeIdentifier = themeMap[Selected[1]]
        Window.ModifyTheme(themeIdentifier)
    end,
 })

local Label = UpdatesTab:CreateLabel("FPS and Ping counter is added.", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme
local Label = UpdatesTab:CreateLabel("ESP was succesfully working.", 4483362458, Color3.fromRGB(255, 255, 255), false) -- Title, Icon, Color, IgnoreTheme

-- Add this in the UItab section, before or after the other ESP sections
local PlayerESPSection = UItab:CreateSection("Player ESP Settings")

-- Player ESP settings
local playerESPSettings = {
    Enabled = false,
    FillColor = Color3.fromRGB(175, 25, 255),
    OutlineColor = Color3.fromRGB(255, 255, 255),
    FillTransparency = 0.5,
    OutlineTransparency = 0,
    DepthMode = "AlwaysOnTop",
    RainbowMode = false,
    RainbowSpeed = 1,
    ShowNameTags = true,
    NameTagSize = 14,
    ShowDistance = true
}

local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local lp = Players.LocalPlayer
local connections = {}
local rainbowHue = 0

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

-- Function to get the enemy team of the local player
local function getEnemyTeam()
    -- Replace these with the actual team names in your game
    local ATTACKER_TEAM = "Terrorists"
    local DEFENDER_TEAM = "Counter_Terrorists"
    
    if not lp.Team then return nil end
    
    if lp.Team.Name == ATTACKER_TEAM then
        return DEFENDER_TEAM
    elseif lp.Team.Name == DEFENDER_TEAM then
        return ATTACKER_TEAM
    end
    
    return nil
end

-- Function to check if a player is on the enemy team
local function isEnemy(plr)
    if not plr.Team then return false end
    local enemyTeam = getEnemyTeam()
    if not enemyTeam then return false end
    
    return plr.Team.Name == enemyTeam
end

-- Function to calculate distance between two positions
local function getDistanceFromPlayer(targetPosition)
    local character = lp.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return 0 end
    
    local rootPart = character.HumanoidRootPart
    return (rootPart.Position - targetPosition).Magnitude
end

-- Function to update rainbow colors
local function updateRainbowColors()
    if not playerESPSettings.RainbowMode then return end
    
    rainbowHue = (rainbowHue + 0.01 * playerESPSettings.RainbowSpeed) % 1
    local rainbowColor = Color3.fromHSV(rainbowHue, 1, 1)
    
    -- Update highlights
    for _, highlight in ipairs(Storage:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.FillColor = rainbowColor
        end
    end
    
    -- Update name tags and distance labels
    if playerESPSettings.ShowNameTags then
        for _, billboard in ipairs(Storage:GetChildren()) do
            if billboard:IsA("BillboardGui") then
                local textLabel = billboard.Frame.TextLabel
                local distanceLabel = billboard.Frame:FindFirstChild("DistanceLabel")
                
                textLabel.TextColor3 = rainbowColor
                if distanceLabel then
                    distanceLabel.TextColor3 = rainbowColor
                end
            end
        end
    end
end

-- Rainbow update connection
local rainbowConnection
local function setupRainbowUpdate()
    if rainbowConnection then
        rainbowConnection:Disconnect()
        rainbowConnection = nil
    end
    
    if playerESPSettings.Enabled and playerESPSettings.RainbowMode then
        rainbowConnection = game:GetService("RunService").Heartbeat:Connect(function()
            updateRainbowColors()
        end)
    end
end

local function createNameTag(plr, character)
    if not playerESPSettings.ShowNameTags then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = plr.Name .. "_NameTag"
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 1
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Adornee = character:WaitForChild("Head")
    billboard.Parent = Storage
    
    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Parent = billboard
    
    -- Name label
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Text = plr.Name
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextScaled = false
    textLabel.TextSize = playerESPSettings.NameTagSize
    textLabel.TextColor3 = playerESPSettings.RainbowMode and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
    textLabel.Parent = frame
    
    -- Distance label (if enabled)
    if playerESPSettings.ShowDistance then
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "DistanceLabel"
        distanceLabel.Text = "0 studs"
        distanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
        distanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.TextStrokeTransparency = 0.5
        distanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.TextScaled = false
        distanceLabel.TextSize = playerESPSettings.NameTagSize - 2
        distanceLabel.TextColor3 = playerESPSettings.RainbowMode and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
        distanceLabel.Parent = frame
        
        -- Create a loop to update the distance
        local distanceConnection
        distanceConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if character and character:FindFirstChild("Head") then
                local distance = math.floor(getDistanceFromPlayer(character.Head.Position))
                distanceLabel.Text = tostring(distance) .. " studs"
            else
                distanceConnection:Disconnect()
            end
        end)
        
        -- Store the connection so we can clean it up later
        if not connections[plr] then connections[plr] = {} end
        connections[plr].distanceConnection = distanceConnection
    end
    
    return billboard
end

local function Highlight(plr)
    if not playerESPSettings.Enabled then return end
    if plr == lp then return end -- Don't highlight local player
    if not isEnemy(plr) then return end -- Only highlight enemies
    
    -- Create highlight
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = playerESPSettings.RainbowMode and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
    Highlight.DepthMode = Enum.HighlightDepthMode[playerESPSettings.DepthMode]
    Highlight.FillTransparency = playerESPSettings.FillTransparency
    Highlight.OutlineColor = playerESPSettings.OutlineColor
    Highlight.OutlineTransparency = playerESPSettings.OutlineTransparency
    Highlight.Parent = Storage
    
    -- Create name tag
    local nameTag
    
    local function setupCharacter(char)
        if char then
            Highlight.Adornee = char
            if playerESPSettings.ShowNameTags then
                nameTag = createNameTag(plr, char)
            end
        end
    end
    
    local plrchar = plr.Character
    setupCharacter(plrchar)

    connections[plr] = connections[plr] or {}
    connections[plr].charAdded = plr.CharacterAdded:Connect(function(char)
        setupCharacter(char)
    end)
    connections[plr].charRemoving = plr.CharacterRemoving:Connect(function()
        if nameTag then
            nameTag:Destroy()
            nameTag = nil
        end
        if connections[plr] and connections[plr].distanceConnection then
            connections[plr].distanceConnection:Disconnect()
            connections[plr].distanceConnection = nil
        end
    end)
end

local function updateNameTags()
    for _, item in ipairs(Storage:GetChildren()) do
        if item:IsA("BillboardGui") then
            local textLabel = item.Frame.TextLabel
            if textLabel then
                textLabel.TextSize = playerESPSettings.NameTagSize
                textLabel.TextColor3 = playerESPSettings.RainbowMode and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
            end
            local distanceLabel = item.Frame:FindFirstChild("DistanceLabel")
            if distanceLabel then
                distanceLabel.TextSize = playerESPSettings.NameTagSize - 2
                distanceLabel.TextColor3 = playerESPSettings.RainbowMode and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
            end
        end
    end
end

local function setupPlayerESP()
    if playerESPSettings.Enabled then
        -- Clear existing highlights and name tags
        for i, v in pairs(Storage:GetChildren()) do
            if v:IsA("Highlight") or v:IsA("BillboardGui") then
                v:Destroy()
            end
        end
        
        -- Disconnect existing connections
        for plr, connTable in pairs(connections) do
            if connTable.charAdded then connTable.charAdded:Disconnect() end
            if connTable.charRemoving then connTable.charRemoving:Disconnect() end
            if connTable.distanceConnection then connTable.distanceConnection:Disconnect() end
        end
        connections = {}
        
        -- Setup new highlights for existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= lp then
                Highlight(player)
            end
        end
        
        -- Connect to new players joining
        Players.PlayerAdded:Connect(Highlight)
        
        -- Setup rainbow update if needed
        setupRainbowUpdate()
    else
        -- Clean up when disabled
        Storage:ClearAllChildren()
        for plr, connTable in pairs(connections) do
            if connTable.charAdded then connTable.charAdded:Disconnect() end
            if connTable.charRemoving then connTable.charRemoving:Disconnect() end
            if connTable.distanceConnection then connTable.distanceConnection:Disconnect() end
        end
        connections = {}
        
        if rainbowConnection then
            rainbowConnection:Disconnect()
            rainbowConnection = nil
        end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    local plrname = plr.Name
    if Storage[plrname] then
        Storage[plrname]:Destroy()
    end
    if Storage[plrname .. "_NameTag"] then
        Storage[plrname .. "_NameTag"]:Destroy()
    end
    if connections[plr] then
        if connections[plr].charAdded then connections[plr].charAdded:Disconnect() end
        if connections[plr].charRemoving then connections[plr].charRemoving:Disconnect() end
        if connections[plr].distanceConnection then connections[plr].distanceConnection:Disconnect() end
    end
end)

-- Main toggle
UItab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = playerESPSettings.Enabled,
    Flag = "PlayerESPEnabled",
    Callback = function(Value)
        playerESPSettings.Enabled = Value
        setupPlayerESP()
    end,
})

-- Name tags toggle
UItab:CreateToggle({
    Name = "Show Name Tags",
    CurrentValue = playerESPSettings.ShowNameTags,
    Flag = "PlayerESPShowNameTags",
    Callback = function(Value)
        playerESPSettings.ShowNameTags = Value
        if playerESPSettings.Enabled then
            setupPlayerESP()
        end
    end,
})

-- Distance display toggle
UItab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = playerESPSettings.ShowDistance,
    Flag = "PlayerESPShowDistance",
    Callback = function(Value)
        playerESPSettings.ShowDistance = Value
        if playerESPSettings.Enabled then
            setupPlayerESP()
        end
    end,
})

-- Name tag size slider
UItab:CreateSlider({
    Name = "Name Tag Size",
    Range = {8, 24},
    Increment = 1,
    Suffix = "px",
    CurrentValue = playerESPSettings.NameTagSize,
    Flag = "PlayerESPNameTagSize",
    Callback = function(Value)
        playerESPSettings.NameTagSize = Value
        updateNameTags()
    end,
})

-- Rainbow mode toggle
UItab:CreateToggle({
    Name = "Player Rainbow ESP",
    CurrentValue = playerESPSettings.RainbowMode,
    Flag = "PlayerRainbowMode",
    Callback = function(Value)
        playerESPSettings.RainbowMode = Value
        setupRainbowUpdate()
        
        -- Update all highlights with the new color mode
        for _, item in ipairs(Storage:GetChildren()) do
            if item:IsA("Highlight") then
                item.FillColor = Value and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
            elseif item:IsA("BillboardGui") then
                local textLabel = item.Frame.TextLabel
                local distanceLabel = item.Frame:FindFirstChild("DistanceLabel")
                
                if textLabel then
                    textLabel.TextColor3 = Value and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
                end
                if distanceLabel then
                    distanceLabel.TextColor3 = Value and Color3.fromHSV(rainbowHue, 1, 1) or playerESPSettings.FillColor
                end
            end
        end
    end,
})

-- Rainbow speed slider
UItab:CreateSlider({
    Name = "Player Rainbow Speed",
    Range = {0.5, 3},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = playerESPSettings.RainbowSpeed,
    Flag = "PlayerRainbowSpeed",
    Callback = function(Value)
        playerESPSettings.RainbowSpeed = Value
    end,
})

-- Fill color picker
UItab:CreateColorPicker({
    Name = "Player ESP Fill Color",
    Color = playerESPSettings.FillColor,
    Flag = "PlayerESPFillColor",
    Callback = function(Value)
        playerESPSettings.FillColor = Value
        if not playerESPSettings.RainbowMode then
            for _, item in ipairs(Storage:GetChildren()) do
                if item:IsA("Highlight") then
                    item.FillColor = Value
                elseif item:IsA("BillboardGui") then
                    local textLabel = item.Frame.TextLabel
                    local distanceLabel = item.Frame:FindFirstChild("DistanceLabel")
                    
                    if textLabel then
                        textLabel.TextColor3 = Value
                    end
                    if distanceLabel then
                        distanceLabel.TextColor3 = Value
                    end
                end
            end
        end
    end
})

-- Outline color picker
UItab:CreateColorPicker({
    Name = "Player ESP Outline Color",
    Color = playerESPSettings.OutlineColor,
    Flag = "PlayerESPOutlineColor",
    Callback = function(Value)
        playerESPSettings.OutlineColor = Value
        for _, highlight in ipairs(Storage:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight.OutlineColor = Value
            end
        end
    end
})

-- Fill transparency slider
UItab:CreateSlider({
    Name = "Player ESP Fill Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = playerESPSettings.FillTransparency,
    Flag = "PlayerESPFillTransparency",
    Callback = function(Value)
        playerESPSettings.FillTransparency = Value
        for _, highlight in ipairs(Storage:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight.FillTransparency = Value
            end
        end
    end,
})

-- Outline transparency slider
UItab:CreateSlider({
    Name = "Player ESP Outline Transparency",
    Range = {0, 1},
    Increment = 0.05,
    Suffix = "",
    CurrentValue = playerESPSettings.OutlineTransparency,
    Flag = "PlayerESPOutlineTransparency",
    Callback = function(Value)
        playerESPSettings.OutlineTransparency = Value
        for _, highlight in ipairs(Storage:GetChildren()) do
            if highlight:IsA("Highlight") then
                highlight.OutlineTransparency = Value
            end
        end
    end,
})

-- Initialize ESP if enabled by default
if playerESPSettings.Enabled then
    setupPlayerESP()
end


local flysigmasection = MainTab:CreateSection("Fly Cheats")
-- Store flight-related variables outside the toggle for access
local flying = false
local flyConnection1, flyConnection2
local flyBV
local currentFlySpeed = 50 -- Default speed

-- Create the speed slider first so it's available when the toggle is created
local SpeedSlider = MainTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 200},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = currentFlySpeed,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        currentFlySpeed = Value
    end,
})

local FlyToggle = MainTab:CreateToggle({
    Name = "Fly (Press F to activate)",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        if not Value then
            -- Clean up when toggle is turned off
            if flyConnection1 then
                flyConnection1:Disconnect()
                flyConnection1 = nil
            end
            if flyConnection2 then
                flyConnection2:Disconnect()
                flyConnection2 = nil
            end
            
            -- Reset flight state
            local player = game.Players.LocalPlayer
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                    if humanoid.RootPart and humanoid.RootPart:FindFirstChild("FlyBV") then
                        humanoid.RootPart.FlyBV:Destroy()
                    end
                end
            end
            flying = false
            return
        end
        
        -- Initialize flight system when toggle is on
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        -- Toggle flying when F key is pressed
        flyConnection1 = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
                flying = not flying
                
                if flying then
                    humanoid.PlatformStand = true -- Allows for free movement
                    -- Create a BodyVelocity for flight control
                    flyBV = Instance.new("BodyVelocity")
                    flyBV.Name = "FlyBV"
                    flyBV.Velocity = Vector3.new(0, 0, 0)
                    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    flyBV.P = 10000
                    flyBV.Parent = humanoid.RootPart
                else
                    humanoid.PlatformStand = false
                    -- Remove the BodyVelocity when not flying
                    if flyBV then
                        flyBV:Destroy()
                        flyBV = nil
                    end
                end
            end
        end)

        -- Flight control while flying
        flyConnection2 = game:GetService("RunService").Heartbeat:Connect(function()
            if flying and humanoid and humanoid.RootPart then
                local root = humanoid.RootPart
                local cam = workspace.CurrentCamera
                
                -- Get movement direction based on camera orientation
                local forward = cam.CFrame.LookVector
                local right = cam.CFrame.RightVector
                local up = Vector3.new(0, 1, 0)
                
                local direction = Vector3.new(0, 0, 0)
                
                -- Check for movement inputs
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + forward
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - forward
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + right
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - right
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + up
                end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                    direction = direction - up
                end
                
                -- Normalize and apply speed
                if direction.Magnitude > 0 then
                    direction = direction.Unit * currentFlySpeed
                end
                
                -- Apply velocity
                if flyBV then
                    flyBV.Velocity = direction
                end
            end
        end)
    end,
})

-- Configuration variables
local noclipEnabled = false
local noclipConnections = {}

-- No clip sections
local SIGMAClip = MainTab:CreateSection("NoClip")

-- NoClip function
local function noclipLoop()
    if noclipEnabled and game.Players.LocalPlayer.Character then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end

local NoclipToggle = MainTab:CreateToggle({
    Name = "NoClip (Press N to toggle)",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        noclipEnabled = Value
        
        if Value then
            -- Enable NoClip
            table.insert(noclipConnections, game:GetService("RunService").Stepped:Connect(noclipLoop))
            
            -- Toggle with N key
            table.insert(noclipConnections, game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
                if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
                    noclipEnabled = not noclipEnabled
                    Rayfield:Notify({
                        Title = "NoClip",
                        Content = noclipEnabled and "Enabled" or "Disabled",
                        Duration = 1,
                    })
                end
            end))
        else
            -- Disable NoClip and clean up connections
            for _, connection in pairs(noclipConnections) do
                connection:Disconnect()
            end
            noclipConnections = {}
            
            -- Restore collision
            if game.Players.LocalPlayer.Character then
                for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = true
                    end
                end
            end
        end
    end,
})

local flysigmasection = MainTab:CreateSection("Aim Assist")
-- Create Toggle for aimbotEnabled
MainTab:CreateToggle({
    Name = "Enable Aimassist",
    CurrentValue = aimbotEnabled,
    Flag = "AimbotToggle",
    Callback = function(Value)
        aimbotEnabled = Value
        print("Aimbot Enabled:", aimbotEnabled)
    end,
})
MainTab:CreateToggle({
    Name = "Show FOV Ring",
    CurrentValue = showFOV,
    Flag = "FOVRingToggle",
    Callback = function(Value)
        showFOV = Value
        FOVring.Visible = showFOV
        print("FOV Ring Visible:", showFOV)
    end,
})

MainTab:CreateSlider({
    Name = "FOV Size",
    Range = {10, 500}, -- Min and Max values
    Increment = 1,
    Suffix = "px",
    CurrentValue = fov,
    Flag = "FOVSlider",
    Callback = function(Value)
        fov = Value
        print("FOV set to:", fov)

        -- Optional: update your FOVring radius dynamically
        if FOVring then
            FOVring.Radius = fov
        end
    end,
})

-- Toggle: Highlight ESP On/Off
MainTab:CreateToggle({
    Name = "Enable Highlight ESP",
    CurrentValue = highlightEnabled,
    Flag = "HighlightToggle",
    Callback = function(Value)
        highlightEnabled = Value
        print("Highlight ESP:", highlightEnabled)
    end,
})


-- Toggle: Team Check On/Off
MainTab:CreateToggle({
    Name = "Enable Team Check",
    CurrentValue = teamCheck,
    Flag = "TeamCheckToggle",
    Callback = function(Value)
        teamCheck = Value
        print("Team Check:", teamCheck)
    end,
})


 
local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit
    local target = nil
    local mag = math.huge
    local screenCenter = workspace.CurrentCamera.ViewportSize / 2
 
    for i, v in pairs(Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild(lockPart) and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= Players.LocalPlayer and (v.Team ~= Players.LocalPlayer.Team or (not teamCheck)) then
            local screenPoint, onScreen = workspace.CurrentCamera:WorldToViewportPoint(v.Character[lockPart].Position)
            local distanceFromCenter = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
 
            if onScreen and distanceFromCenter <= fov then
                local magBuf = (v.Character[lockPart].Position - ray:ClosestPoint(v.Character[lockPart].Position)).Magnitude
 
                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
    end
 
    return target
end
 
local function updateFOVRing()
    FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
end
 
local function highlightTarget(target)
    if highlightEnabled and target and target.Character then
        local highlight = Instance.new("Highlight")
        highlight.Adornee = target.Character
        highlight.FillColor = Color3.fromRGB(255, 128, 128)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = target.Character
    end
end
 
local function removeHighlight(target)
    if highlightEnabled and target and target.Character and target.Character:FindFirstChildOfClass("Highlight") then
        target.Character:FindFirstChildOfClass("Highlight"):Destroy()
    end
end
 
local function predictPosition(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local velocity = target.Character.HumanoidRootPart.Velocity
        local position = target.Character[lockPart].Position
        local predictedPosition = position + (velocity * predictionFactor)
        return predictedPosition
    end
    return nil
end
 
local function handleToggle()
    if debounce then return end
    debounce = true
    toggleState = not toggleState
    wait(0.3)  -- Debounce time to prevent multiple toggles
    debounce = false
end
 
loop = RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        updateFOVRing()
 
        local localPlayer = Players.LocalPlayer.Character
        local cam = workspace.CurrentCamera
        local screenCenter = workspace.CurrentCamera.ViewportSize / 2
 
        if Toggle then
            if UserInputService:IsKeyDown(ToggleKey) then
                handleToggle()
            end
        else
            toggleState = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        end
 
        if toggleState then
            if not currentTarget then
                currentTarget = getClosest(cam.CFrame)
                highlightTarget(currentTarget)  -- Highlight the new target if enabled
            end
 
            if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockPart) then
                local predictedPosition = predictPosition(currentTarget)
                if predictedPosition then
                    workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, predictedPosition), smoothing)
                end
                FOVring.Color = Color3.fromRGB(0, 255, 0)  -- Change FOV ring color to green when locked onto a target
            else
                FOVring.Color = Color3.fromRGB(255, 128, 128)  -- Revert FOV ring color to original when not locked onto a target
            end
        else
            if currentTarget and highlightEnabled then
                removeHighlight(currentTarget)  -- Remove highlight from the old target
            end
            currentTarget = nil
            FOVring.Color = Color3.fromRGB(255, 128, 128)  -- Revert FOV ring color to original when not locked onto a target
        end
    end
end)

if highlightEnabled then
    -- apply highlights
end

if teamCheck and player.Team == LocalPlayer.Team then
    -- skip this player
end



local Teleportsection = MainTab:CreateSection("Teleport")

-- Teleportation variables
local teleporting = false
local autoTeleport = false
local teleportInterval = 2
local teleportKeybind = "T"
local teleportConnection = nil

-- Cache services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Function to get the opposite team
local function getOppositeTeam()
    if not game:FindFirstChild("Teams") then return nil end
    
    local localTeam = LocalPlayer.Team
    if not localTeam then return nil end
    
    -- Find all teams and identify the opposite one
    local teams = {}
    for _, team in ipairs(game.Teams:GetTeams()) do
        if team ~= localTeam then
            table.insert(teams, team)
        end
    end
    
    -- Return the first opposite team found (assuming there are only 2 teams)
    return teams[1]
end

-- Function to check if player is on the opposite team
local function isOppositeTeam(player)
    if player == LocalPlayer then return false end
    
    local oppositeTeam = getOppositeTeam()
    if not oppositeTeam then return true end -- If no teams, treat everyone as opposite
    
    return player.Team == oppositeTeam
end

-- Function to get all opposite team players
local function getOppositeTeamPlayers()
    local enemies = {}
    local oppositeTeam = getOppositeTeam()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if isOppositeTeam(player) and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                table.insert(enemies, player.Character)
            end
        end
    end
    
    return enemies
end

-- Improved teleport function with team check
local function teleportToRandomEnemy()
    -- Validate local character
    if not LocalPlayer.Character then 
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "Your character doesn't exist",
            Duration = 3,
            Image = 4483362458
        })
        return false 
    end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then 
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "HumanoidRootPart not found",
            Duration = 3,
            Image = 4483362458
        })
        return false 
    end
    
    -- Get opposite team players
    local enemies = getOppositeTeamPlayers()
    if #enemies == 0 then
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "No valid enemies found",
            Duration = 3,
            Image = 4483362458
        })
        return false
    end
    
    -- Select random enemy
    local randomEnemy = enemies[math.random(1, #enemies)]
    local enemyRoot = randomEnemy:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then return false end
    
    -- Teleport with offset and face same direction
    local offset = Vector3.new(0, 3, 0)
    humanoidRootPart.CFrame = CFrame.new(enemyRoot.Position + offset, enemyRoot.Position)
    
    Rayfield:Notify({
        Title = "Teleport Success",
        Content = "Teleported to enemy",
        Duration = 1,
        Image = 4483362458
    })
    return true
end

-- Teleportation variables
local teleporting = false
local autoTeleport = false
local teleportDelay = 3 -- Default delay between auto-teleports
local teleportKeybind = "T"
local teleportConnection = nil
local lastTeleportTime = 0
local isTeleportingNow = false -- Prevents overlapping teleports

-- Cache services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Improved teleport function with proper timing
local function teleportToRandomEnemy()
    if isTeleportingNow then return false end
    isTeleportingNow = true
    
    -- Anti-spam protection
    local currentTime = os.clock()
    if currentTime - lastTeleportTime < 0.5 then 
        isTeleportingNow = false
        return false 
    end
    lastTeleportTime = currentTime
    
    -- Validate local character
    if not LocalPlayer.Character then 
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "Your character doesn't exist",
            Duration = 3,
            Image = 4483362458
        })
        isTeleportingNow = false
        return false 
    end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then 
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "HumanoidRootPart not found",
            Duration = 3,
            Image = 4483362458
        })
        isTeleportingNow = false
        return false 
    end
    
    -- Get opposite team players
    local enemies = getOppositeTeamPlayers()
    if #enemies == 0 then
        Rayfield:Notify({
            Title = "Teleport Failed",
            Content = "No valid enemies found",
            Duration = 3,
            Image = 4483362458
        })
        isTeleportingNow = false
        return false
    end
    
    -- Select random enemy
    local randomEnemy = enemies[math.random(1, #enemies)]
    local enemyRoot = randomEnemy:FindFirstChild("HumanoidRootPart")
    if not enemyRoot then 
        isTeleportingNow = false
        return false 
    end
    
    -- Teleport with offset and face same direction
    local offset = Vector3.new(0, 3, 0)
    humanoidRootPart.CFrame = CFrame.new(enemyRoot.Position + offset, enemyRoot.Position)
    
    Rayfield:Notify({
        Title = "Teleport Success",
        Content = string.format("Teleported to enemy\nNext in: %.1fs", teleportDelay),
        Duration = math.min(teleportDelay, 3), -- Show notification for delay time or max 3 seconds
        Image = 4483362458
    })
    
    isTeleportingNow = false
    return true
end

local TeleportToggle = MainTab:CreateToggle({
    Name = "Enable Teleport System",
    CurrentValue = false,
    Flag = "TeleportToggle",
    Callback = function(Value)
        teleporting = Value
        if not Value and autoTeleport then
            AutoTeleportToggle:Set(false)
        end
    end,
})

local TeleportKeybind = MainTab:CreateKeybind({
    Name = "Teleport to Enemy (Current: "..teleportKeybind..")",
    CurrentKeybind = teleportKeybind,
    HoldToInteract = false,
    Flag = "TeleportKeybind",
    Callback = function(Keybind)
        if teleporting then
            teleportToRandomEnemy()
        else
            Rayfield:Notify({
                Title = "System Disabled",
                Content = "Enable the teleport system first",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

TeleportKeybind.OnKeybindChanged = function(newKeybind)
    teleportKeybind = newKeybind
    TeleportKeybind:Set({
        Name = "Teleport to Enemy (Current: "..teleportKeybind..")"
    })
end

local AutoTeleportToggle = MainTab:CreateToggle({
    Name = "Auto Teleport to Enemies",
    CurrentValue = false,
    Flag = "AutoTeleportToggle",
    Callback = function(Value)
        autoTeleport = Value
        
        if teleportConnection then
            teleportConnection:Disconnect()
            teleportConnection = nil
        end
        
        if autoTeleport and teleporting then
            local lastTeleport = 0
            teleportConnection = RunService.Heartbeat:Connect(function()
                local now = os.clock()
                if now - lastTeleport >= teleportDelay then
                    teleportToRandomEnemy()
                    lastTeleport = now
                end
            end)
        end
    end,
})

local TeleportDelaySlider = MainTab:CreateSlider({
    Name = "Auto-Teleport Delay (seconds)",
    Range = {1, 10}, -- 1 to 10 seconds range
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = teleportDelay,
    Flag = "TeleportDelay",
    Callback = function(Value)
        teleportDelay = Value
    end,
})

MainTab:CreateButton({
    Name = "Teleport Now",
    Callback = function()
        if teleporting then
            teleportToRandomEnemy()
        else
            Rayfield:Notify({
                Title = "System Disabled",
                Content = "Enable the teleport system first",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})

local Input = MainTab:CreateInput({
    Name = "Player Username",
    PlaceholderText = "Enter username",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        -- Store the input text in targetUsername
        targetUsername = Text
    end,
})

local Button = MainTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        local players = game:GetService("Players")
        local targetPlayer = players:FindFirstChild(targetUsername)
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local localPlayer = players.LocalPlayer
            if localPlayer.Character then
                localPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
                Rayfield:Notify({
                    Title = "Teleport Success",
                    Content = "Teleported to "..targetUsername,
                    Duration = 3,
                    Image = 4483362458,
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "Your character doesn't exist",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found or doesn't have character",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- Add this in the MainTab section
local SpeedSection = MainTab:CreateSection("Speed Settings")

local walkSpeedSettings = {
    Enabled = false,  -- Master switch for the feature
    Active = false,   -- Whether speed is currently applied
    Speed = 50,       -- Default speed value
    ToggleKey = Enum.KeyCode.F
}

-- Function to update walk speed
local function updateWalkSpeed()
    if not game.Players.LocalPlayer or not game.Players.LocalPlayer.Character then return end
    
    local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
    if humanoid then
        if walkSpeedSettings.Enabled and walkSpeedSettings.Active then
            sethiddenproperty(humanoid, "WalkSpeed", walkSpeedSettings.Speed)
        else
            sethiddenproperty(humanoid, "WalkSpeed", 16) -- Default speed
        end
    end
end

-- Main toggle switch
local SpeedToggle = MainTab:CreateToggle({
    Name = "Enable Speed Feature",
    CurrentValue = walkSpeedSettings.Enabled,
    Flag = "WalkSpeedEnabled",
    Callback = function(Value)
        walkSpeedSettings.Enabled = Value
        walkSpeedSettings.Active = Value -- Turn on when enabling
        updateWalkSpeed()
        
        Rayfield:Notify({
            Title = "Speed Feature " .. (Value and "Enabled" or "Disabled"),
            Content = Value and "Press "..tostring(walkSpeedSettings.ToggleKey).." to toggle" or "Speed reset to default",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Speed slider
MainTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 150},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = walkSpeedSettings.Speed,
    Flag = "WalkSpeedValue",
    Callback = function(Value)
        walkSpeedSettings.Speed = Value
        if walkSpeedSettings.Enabled and walkSpeedSettings.Active then
            updateWalkSpeed()
        end
    end,
})

-- Keybind setup
local SpeedKeybind = MainTab:CreateKeybind({
    Name = "Toggle Speed Keybind",
    CurrentKeybind = walkSpeedSettings.ToggleKey,
    HoldToInteract = false,
    Flag = "WalkSpeedKeybind",
    Callback = function(Key)
        walkSpeedSettings.ToggleKey = Key
        Rayfield:Notify({
            Title = "Speed Keybind Updated",
            Content = "Press "..tostring(Key).." to toggle speed",
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

-- Keybind listener
local function handleKeybind(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == walkSpeedSettings.ToggleKey and walkSpeedSettings.Enabled then
        walkSpeedSettings.Active = not walkSpeedSettings.Active
        updateWalkSpeed()
        
        Rayfield:Notify({
            Title = "Speed " .. (walkSpeedSettings.Active and "ON" or "OFF"),
            Content = walkSpeedSettings.Active and ("Speed: "..walkSpeedSettings.Speed) or "Default speed",
            Duration = 1.5,
            Image = 4483362458,
        })
    end
end

-- Initialize
game:GetService("UserInputService").InputBegan:Connect(handleKeybind)

-- Handle character changes
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if walkSpeedSettings.Enabled then
        updateWalkSpeed()
    end
end)

-- Cleanup
Rayfield:DestroySignal():Connect(function()
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end
    -- Clean up player connections
    for player, connTable in pairs(connections) do
        if connTable.charAdded then connTable.charAdded:Disconnect() end
        if connTable.charRemoving then connTable.charRemoving:Disconnect() end
    end
    connections = {}
end)

-- Cleanup
Rayfield:DestroySignal():Connect(function()
    -- Reset speed when script is destroyed
    if game.Players.LocalPlayer.Character then
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            sethiddenproperty(humanoid, "WalkSpeed", 16)
        end
    end
end)

-- Cleanup
Rayfield:DestroySignal():Connect(function()
    if toggleConnection then
        toggleConnection:Disconnect()
        toggleConnection = nil
    end
    if rainbowConnection then
        rainbowConnection:Disconnect()
    end
    -- Clean up player connections
    for player, connection in pairs(playerConnections) do
        connection:Disconnect()
    end
    playerConnections = {}
end)

local fpsGui = Instance.new("ScreenGui")
fpsGui.Name = "FPSCounterGUI"
fpsGui.ResetOnSpawn = false
fpsGui.IgnoreGuiInset = true
fpsGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 120, 0, 30)
fpsLabel.Position = UDim2.new(1, -130, 0, 10)
fpsLabel.AnchorPoint = Vector2.new(0, 0)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextStrokeTransparency = 0.7
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."
fpsLabel.Visible = false
fpsLabel.Parent = fpsGui

local RunService = game:GetService("RunService")

local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
	if not fpsLabel.Visible then return end

	frameCount += 1
	local now = tick()
	if now - lastTime >= 1 then
		local fps = math.floor(frameCount / (now - lastTime))
		fpsLabel.Text = "FPS: " .. fps
		frameCount = 0
		lastTime = now
	end
end)
