-- aimbot.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Aimbot = {}
Aimbot.Enabled = false
Aimbot.Keybind = Enum.UserInputType.MouseButton2 -- Default
Aimbot.Mode = "Toggle" -- "Always", "Toggle", "Hold"
Aimbot.Prediction = 0.165
Aimbot.Target = nil
Aimbot.IsKeyDown = false

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
    if self.Target and self.Target.Character and self.Target.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = self.Target.Character.HumanoidRootPart
        local PredictedPos = HRP.Position + (HRP.Velocity * self.Prediction)
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, PredictedPos)
    end
end

RunService.Heartbeat:Connect(function()
    if not Aimbot.Enabled then return end

    if Aimbot.Mode == "Always" then
        Aimbot.Target = Aimbot:GetClosestPlayer()
        Aimbot:LockOn()

    elseif Aimbot.Mode == "Hold" then
        if Aimbot.IsKeyDown then
            Aimbot.Target = Aimbot:GetClosestPlayer()
            Aimbot:LockOn()
        end

    elseif Aimbot.Mode == "Toggle" then
        if Aimbot.Target then
            Aimbot:LockOn()
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Aimbot.Keybind then
        if Aimbot.Mode == "Hold" then
            Aimbot.IsKeyDown = true
        elseif Aimbot.Mode == "Toggle" then
            if Aimbot.Target then
                Aimbot.Target = nil
            else
                Aimbot.Target = Aimbot:GetClosestPlayer()
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Aimbot.Keybind and Aimbot.Mode == "Hold" then
        Aimbot.IsKeyDown = false
        Aimbot.Target = nil
    end
end)

return Aimbot
