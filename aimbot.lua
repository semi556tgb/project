local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Aimbot = {}
Aimbot.Enabled = false
Aimbot.Keybind = Enum.UserInputType.MouseButton2 -- Default
Aimbot.Target = nil
Aimbot.Prediction = 0.165 -- Default prediction

function Aimbot:GetClosestPlayer()
    local MaxDistance = math.huge
    local TargetPlayer = nil

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Player.Character.HumanoidRootPart
            local PredictedPos = HRP.Position + (HRP.Velocity * Aimbot.Prediction)
            local ScreenPoint, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(PredictedPos)
            local Distance = (Vector2.new(ScreenPoint.X, ScreenPoint.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude

            if OnScreen and Distance < MaxDistance then
                MaxDistance = Distance
                TargetPlayer = Player
            end
        end
    end

    return TargetPlayer
end

function Aimbot:LockOn()
    local target = self:GetClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local PredictedPos = target.Character.HumanoidRootPart.Position + (target.Character.HumanoidRootPart.Velocity * self.Prediction)
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, PredictedPos)
    end
end

RunService.Heartbeat:Connect(function()
    if Aimbot.Enabled and Aimbot.Target then
        Aimbot:LockOn()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Aimbot.Keybind then
        Aimbot.Target = Aimbot:GetClosestPlayer()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Aimbot.Keybind then
        Aimbot.Target = nil
    end
end)

return Aimbot
