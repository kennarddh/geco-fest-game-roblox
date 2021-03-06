local Players = game:GetService("Players")

local pad1 = workspace.Pads.Pad1
local pad2 = workspace.Pads.Pad2

local playerCount = 0


local function onCharacterAdded(character)
    local humanoid = character:WaitForChild('Humanoid')
    local humanoidRootPart = humanoid.RootPart

    humanoid.JumpPower = 0

    task.wait(1)

    playerCount += 1

    if playerCount == 1 then
        humanoidRootPart.CFrame = pad2.CFrame + Vector3.new(0, 5, 0)
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, pad1.Position)
    else
        humanoidRootPart.CFrame = pad1.CFrame + Vector3.new(0, 5, 0)
        humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, pad2.Position)
    end

    humanoid.AutoRotate = false

    character.Configuration.SpawnPad.Value = playerCount
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)