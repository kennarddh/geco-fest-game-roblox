local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local tool: Tool = script.Parent

local hitAnimation = tool:WaitForChild("Animations"):WaitForChild("Hit")

local timeOfPreviousShot = 0

local player = Players.LocalPlayer

local otherPlayer

repeat
    task.wait()
until #Players:GetPlayers() >= 2

for _, v in ipairs(Players:GetPlayers()) do
	if v.UserId ~= player.UserId then
		otherPlayer = v
	end
end


local FireRate = tool.Configuration.FireRate.Value


local function canShootWeapon()
	local currentTime = tick()

	local result = not (currentTime - timeOfPreviousShot < FireRate)

	return result
end

local function onUnequipped()
    local humanoid = player.Character:WaitForChild("Humanoid")

    if humanoid then
        task.wait()

        humanoid:EquipTool(tool)
    end
end

local function onActivated()
    local animator = player.Character:WaitForChild('Humanoid'):FindFirstChildOfClass("Animator")

    if animator then
        local animationTrack = animator:LoadAnimation(hitAnimation)

        animationTrack:Play()
    end

    if player:DistanceFromCharacter(otherPlayer.Character:WaitForChild('Humanoid').RootPart.Position) >= 6 then
        return
    end

    if not canShootWeapon() then return end

    ReplicatedStorage.Events.HitPlayer:FireServer()

    timeOfPreviousShot = tick()
end

local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")

    humanoid:EquipTool(tool)
end

if player.Character then
    onCharacterAdded(player.Character)
else
    player.CharacterAdded:Connect(onCharacterAdded)
end

tool.Unequipped:Connect(onUnequipped)
tool.Activated:Connect(onActivated)
