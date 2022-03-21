local Players = game:GetService("Players")

local player = Players.LocalPlayer

local tool: Tool = script.Parent


local function onUnequipped()
    local humanoid = player.Character:WaitForChild("Humanoid")

    if humanoid then
        task.wait()
        humanoid:EquipTool(tool)
    end
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid:EquipTool(tool)
end

player.CharacterAdded:Connect(onCharacterAdded)

tool.Unequipped:Connect(onUnequipped)