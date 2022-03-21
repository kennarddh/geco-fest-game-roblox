local Players = game:GetService("Players")
local RunService = game:GetService('RunService')

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

local controlModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))


local function reverseNumberPositiveNegative(num)
	return -num
end

local function onUpdate()
	local moveVectorDirection = controlModule:GetMoveVector()

	if player.Character.Configuration.SpawnPad.Value == 1 then
		moveVectorDirection = Vector3.new(
			reverseNumberPositiveNegative(moveVectorDirection.X),
			moveVectorDirection.Y,
			reverseNumberPositiveNegative(moveVectorDirection.Z)
		)
	end

	local moveVector = Vector3.new(0, 0, moveVectorDirection.Z)

	if player.Character.Configuration.SpawnPad.Value == 2 then
		if moveVectorDirection.Z == -1 then
			if player:DistanceFromCharacter(otherPlayer.Character:WaitForChild('Humanoid').RootPart.Position) <= 5 then
				moveVector = Vector3.new(0, 0, 0)
			end
		end
	else
		if moveVectorDirection.Z == 1 then
			if player:DistanceFromCharacter(otherPlayer.Character:WaitForChild('Humanoid').RootPart.Position) <= 5 then
				moveVector = Vector3.new(0, 0, 0)
			end
		end
	end


	player.Character.Humanoid:Move(moveVector, false)
    player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
end

if not player.Character then
	player.CharacterAdded:Wait()
end

RunService:BindToRenderStep('OnMove', Enum.RenderPriority.Character.Value, onUpdate)