-- GUI Auto Collect by Radius (Delta Executor Compatible)

-- CONFIG DEFAULT
local Radius = 30
local AutoCollect = false

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AutoCollectGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 190)
Frame.Position = UDim2.new(0.05, 0, 0.45, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Auto Collect (Radius)"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Left

local ToggleBtn = Instance.new("TextButton", Frame)
ToggleBtn.Size = UDim2.new(1, -20, 0, 36)
ToggleBtn.Position = UDim2.new(0, 10, 0, 50)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleBtn.Text = "OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
ToggleBtn.TextSize = 14
ToggleBtn.Font = Enum.Font.GothamBold

local ToggleCorner = Instance.new("UICorner", ToggleBtn)
ToggleCorner.CornerRadius = UDim.new(0, 8)

local RadiusLabel = Instance.new("TextLabel", Frame)
RadiusLabel.Size = UDim2.new(1, -20, 0, 20)
RadiusLabel.Position = UDim2.new(0, 10, 0, 95)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "Radius: 30"
RadiusLabel.TextColor3 = Color3.fromRGB(200,200,200)
RadiusLabel.TextSize = 12
RadiusLabel.Font = Enum.Font.Gotham

-- Slider Bar
local SliderBar = Instance.new("Frame", Frame)
SliderBar.Size = UDim2.new(1, -20, 0, 8)
SliderBar.Position = UDim2.new(0, 10, 0, 120)
SliderBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
SliderBar.BorderSizePixel = 0

local BarCorner = Instance.new("UICorner", SliderBar)
BarCorner.CornerRadius = UDim.new(1, 0)

local SliderFill = Instance.new("Frame", SliderBar)
SliderFill.Size = UDim2.new(0.3, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SliderFill.BorderSizePixel = 0

local FillCorner = Instance.new("UICorner", SliderFill)
FillCorner.CornerRadius = UDim.new(1, 0)

-- Toggle Logic
ToggleBtn.MouseButton1Click:Connect(function()
    AutoCollect = not AutoCollect
    if AutoCollect then
        ToggleBtn.Text = "ON"
        ToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    else
        ToggleBtn.Text = "OFF"
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Slider Logic (Radius 5 - 150)
local dragging = false
local MIN_RADIUS, MAX_RADIUS = 5, 150

SliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pos, 0, 1, 0)
        Radius = math.floor(MIN_RADIUS + (MAX_RADIUS - MIN_RADIUS) * pos)
        RadiusLabel.Text = "Radius: " .. Radius
    end
end)

-- Auto Collect Loop
task.spawn(function()
    while true do
        task.wait(0.3)
        if AutoCollect and HRP and HRP.Parent then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") or v:IsA("Tool") then
                    local name = v.Name:lower()
                    if name:find("wood") or name:find("stone") or name:find("ore") then
                        local ok, dist = pcall(function()
                            return (HRP.Position - v.Position).Magnitude
                        end)
                        if ok and dist <= Radius then
                            firetouchinterest(HRP, v, 0)
                            firetouchinterest(HRP, v, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- Refresh HRP on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)
