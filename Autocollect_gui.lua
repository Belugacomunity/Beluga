-- Auto Collect GUI (Mobile-Friendly, Delta Compatible)

-- CONFIG
local Radius = 40
local AutoCollect = false

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LP = Players.LocalPlayer

-- SAFE PARENT GUI (lebih stabil di mobile)
local PlayerGui = LP:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoCollectGUI_Mobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- MAIN FRAME
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.fromScale(0.75, 0.28)
Frame.Position = UDim2.fromScale(0.125, 0.55)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 14)

-- TITLE
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.fromScale(1, 0.25)
Title.Position = UDim2.fromScale(0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Auto Collect (Radius)"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold

-- TOGGLE
local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.fromScale(0.9, 0.25)
Toggle.Position = UDim2.fromScale(0.05, 0.3)
Toggle.Text = "OFF"
Toggle.TextScaled = true
Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
Toggle.TextColor3 = Color3.fromRGB(255,80,80)
Toggle.Font = Enum.Font.GothamBold
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 10)

-- RADIUS LABEL
local RadiusLabel = Instance.new("TextLabel", Frame)
RadiusLabel.Size = UDim2.fromScale(1, 0.18)
RadiusLabel.Position = UDim2.fromScale(0, 0.6)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Radius: 40"
RadiusLabel.TextScaled = true
RadiusLabel.TextColor3 = Color3.fromRGB(200,200,200)
RadiusLabel.Font = Enum.Font.Gotham

-- SIMPLE SLIDER (tap kiri/kanan)
local SliderLeft = Instance.new("TextButton", Frame)
SliderLeft.Size = UDim2.fromScale(0.2, 0.18)
SliderLeft.Position = UDim2.fromScale(0.05, 0.8)
SliderLeft.Text = "-"
SliderLeft.TextScaled = true
SliderLeft.Font = Enum.Font.GothamBold
SliderLeft.BackgroundColor3 = Color3.fromRGB(45,45,45)
SliderLeft.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SliderLeft).CornerRadius = UDim.new(0, 10)

local SliderRight = Instance.new("TextButton", Frame)
SliderRight.Size = UDim2.fromScale(0.2, 0.18)
SliderRight.Position = UDim2.fromScale(0.75, 0.8)
SliderRight.Text = "+"
SliderRight.TextScaled = true
SliderRight.Font = Enum.Font.GothamBold
SliderRight.BackgroundColor3 = Color3.fromRGB(45,45,45)
SliderRight.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", SliderRight).CornerRadius = UDim.new(0, 10)

-- LOGIC
Toggle.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    if AutoCollect then
        Toggle.Text = "ON"
        Toggle.TextColor3 = Color3.fromRGB(80,255,80)
        Toggle.BackgroundColor3 = Color3.fromRGB(40,80,40)
    else
        Toggle.Text = "OFF"
        Toggle.TextColor3 = Color3.fromRGB(255,80,80)
        Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end
end)

local MIN_RADIUS, MAX_RADIUS, STEP = 10, 150, 10

local function updateRadius()
    RadiusLabel.Text = "Radius: " .. Radius
end

SliderLeft.MouseButton1Click:Connect(function()
    Radius = math.max(MIN_RADIUS, Radius - STEP)
    updateRadius()
end)

SliderRight.MouseButton1Click:Connect(function()
    Radius = math.min(MAX_RADIUS, Radius + STEP)
    updateRadius()
end)

-- AUTO COLLECT LOOP
task.spawn(function()
    while task.wait(0.4) do
        if AutoCollect then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("Part") then
                        local n = v.Name:lower()
                        if n:find("wood") or n:find("stone") or n:find("ore") then
                            local d = (hrp.Position - v.Position).Magnitude
                            if d <= Radius then
                                firetouchinterest(hrp, v, 0)
                                firetouchinterest(hrp, v, 1)
                            end
                        end
                    end
                end
            end
        end
    end
end)

print("AutoCollect GUI Mobile Loaded")
