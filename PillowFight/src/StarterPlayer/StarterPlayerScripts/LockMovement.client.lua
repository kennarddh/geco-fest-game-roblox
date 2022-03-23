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

local function roundVector3Value(value)
	if value == 0 then
		return 0
	elseif value > 0 then
		return 1
	else
		return -1
	end
end

local function roundVector3(vector3)
	return Vector3.new(
		0,
		roundVector3Value(vector3.Y),
		roundVector3Value(vector3.Z)
	)
end

local function onUpdate()
	local moveVectorDirection = controlModule:GetMoveVector()

	moveVectorDirection = roundVector3(moveVectorDirection)

	if player.Character:WaitForChild("Configuration"):WaitForChild("SpawnPad").Value == 1 then
		moveVectorDirection = Vector3.new(
			reverseNumberPositiveNegative(moveVectorDirection.X),
			moveVectorDirection.Y,
			reverseNumberPositiveNegative(moveVectorDirection.Z)
		)
	end

	local moveVector = Vector3.new(0, 0, moveVectorDirection.Z)

	if player.Character:WaitForChild("Configuration"):WaitForChild("SpawnPad").Value == 2 then
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