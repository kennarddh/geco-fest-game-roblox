local Players = game:GetService("Players")
local RunService = game:GetService('RunService')

local player = Players.LocalPlayer

local ControlModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))

local function onUpdate()
	local moveVectorDirection = ControlModule:GetMoveVector()

	local moveVector = Vector3.new(0, moveVectorDirection.Y, moveVectorDirection.Z)

	player.Character.Humanoid:Move(moveVector, true)
end

player.CharacterAdded:Wait()

RunService:BindToRenderStep('OnMove', Enum.RenderPriority.Character.Value, onUpdate)