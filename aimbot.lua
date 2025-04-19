local Aimbot = {}
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Enabled = false
local CurrentKey = Enum.KeyCode.E -- Default key
local Target = nil

function Aimbot.SetKeybind(key)
    if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
        CurrentKey = key
        print("Aimbot Keybind updated to:", key.Name)
    end
end

function Aimbot.Toggle(state)
    Enabled = state
end

function Aimbot.GetClosestPlayer()
    local closest = nil
    local shortest = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = workspace.CurrentCamera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end
    return closest
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == CurrentKey and Enabled then
        Target = Aimbot.GetClosestPlayer()
        if Target then
            print("Locked onto:", Target.Name)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
    end
end)

return Aimbot
