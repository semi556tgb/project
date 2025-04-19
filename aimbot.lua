local aimbot = {}

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Enabled = false
local Keybind = Enum.KeyCode.E
local Target = nil

function aimbot.GetClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    for i, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            local distance = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closest = player
            end
        end
    end
    return closest
end

function aimbot.LockOnTarget(player)
    if Target and Target.Character and Target.Character:FindFirstChild("Highlight") then
        Target.Character.Highlight:Destroy()
    end
    Target = player
    if Target and Target.Character then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.Parent = Target.Character
    end
end

function aimbot.Toggle(state)
    Enabled = state
    if Enabled then
        print("Aimbot Enabled")
    else
        print("Aimbot Disabled")
        if Target and Target.Character and Target.Character:FindFirstChild("Highlight") then
            Target.Character.Highlight:Destroy()
        end
        Target = nil
    end
end

function aimbot.SetKeybind(key)
    Keybind = key
    print("Aimbot keybind set to:", key.Name)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Keybind and Enabled then
        local closest = aimbot.GetClosestPlayer()
        if closest then
            aimbot.LockOnTarget(closest)
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") and Enabled then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Character.HumanoidRootPart.Position)
    end
end)

return aimbot
