if game.CoreGui:FindFirstChild("FLY GUI V1") then
    game.CoreGui.MyFlyScript:Destroy()
end

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local flying = false
local speed = 2

-- GUI SETUP
local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "MyFlyScript"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 130, 0, 150)
frame.Position = UDim2.new(0, 10, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true -- Agar bisa digeser di layar HP

local corner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "FLY MOBILE"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.8, 0, 0, 35)
flyBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
flyBtn.Text = "FLY: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flyBtn.TextColor3 = Color3.new(1, 1, 1)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0.55, 0)
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

local addBtn = Instance.new("TextButton", frame)
addBtn.Size = UDim2.new(0.35, 0, 0, 30)
addBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
addBtn.Text = "+"
addBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
addBtn.TextColor3 = Color3.new(1, 1, 1)

local subBtn = Instance.new("TextButton", frame)
subBtn.Size = UDim2.new(0.35, 0, 0, 30)
subBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
subBtn.Text = "-"
subBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
subBtn.TextColor3 = Color3.new(1, 1, 1)

-- LOGIC
local function toggleFly()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    local cam = workspace.CurrentCamera

    if flying then
        flying = false
        flyBtn.Text = "FLY: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        hum.PlatformStand = false
    else
        flying = true
        flyBtn.Text = "FLY: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        hum.PlatformStand = true

        task.spawn(function()
            while flying and char and hrp do
                runService.RenderStepped:Wait()
                hrp.Velocity = Vector3.new(0, 0, 0)
                if hum.MoveDirection.Magnitude > 0 then
                    local lookVec = cam.CFrame.LookVector
                    hrp.CFrame = hrp.CFrame * CFrame.new(hum.MoveDirection.X * speed, (lookVec.Y * speed), hum.MoveDirection.Z * speed)
                end
            end
        end)
    end
end

flyBtn.MouseButton1Click:Connect(toggleFly)
addBtn.MouseButton1Click:Connect(function() speed = speed + 1 speedLabel.Text = "Speed: "..speed end)
subBtn.MouseButton1Click:Connect(function() if speed > 1 then speed = speed - 1 speedLabel.Text = "Speed: "..speed end end)
