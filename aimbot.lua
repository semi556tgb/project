-- aimbot.lua

local aimbot = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local CurrentTarget = nil
local AimbotEnabled = false
local AimKey = Enum.KeyCode.Unknown

function aimbot.SetKeybind(keycode)
    AimKey = keycode
end

function aimbot.Toggle(state)
    AimbotEnabled = state
    if not state then
        CurrentTarget = nil
    end
end

function aimbot.GetClosestTarget()
    local closest = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closest = player
                end
            end
        end
    end

    return closest
end

function aimbot.HighlightTarget(player)
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("Highlight") then
            p.Character.Highlight.Enabled = false
        end
    end

    if player and player.Character then
        local highlight = player.Character:FindFirstChild("Highlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
        end
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Enabled = true
    end
end

function aimbot.LockOntoTarget()
    CurrentTarget = aimbot.GetClosestTarget()
    aimbot.HighlightTarget(CurrentTarget)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == AimKey then
        aimbot.LockOntoTarget()
    end
end)

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("HumanoidRootPart") then
        local aimPart = CurrentTarget.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, aimPart.Position)
    end
end)

return aimbot
