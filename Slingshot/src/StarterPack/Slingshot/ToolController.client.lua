local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

Players.LocalPlayer.CharacterAdded:Wait()

local mouse = game.Players.LocalPlayer:GetMouse()

local tool = script.Parent

local eventsFolder = ReplicatedStorage.Events.Slingshot

local RELOAD_ACTION = "reloadWeapon"

local FIRE_RATE = tool.Configuration.FireRate.Value
local RELOAD_TIME = tool.Configuration.ReloadTime.Value
local MAX_BULLET = tool.Configuration.MaxBullet.Value

local timeOfPreviousShot = 0
local bullet = 0
local isReloading = false


local function updateBullet(callback)
	local BulletText = Players.LocalPlayer.PlayerGui.ScreenGui.Slingshot.SlingshotBullet.TextLabel

	local newValue = callback(bullet)

	bullet = newValue

	BulletText.Text = newValue
end

local function onAction(actionName, inputState)
	if actionName == RELOAD_ACTION and inputState == Enum.UserInputState.Begin then
		isReloading = true

		task.wait(RELOAD_TIME)

		updateBullet(function()
			return MAX_BULLET
		end)

		isReloading = false
	end
end

local function canShootWeapon()
	local currentTime = tick()

	local result = (not (currentTime - timeOfPreviousShot < FIRE_RATE)) and bullet > 0 and (not isReloading)

	return result
end

local function fireWeapon()
	local player = tool.Parent

	local humanoid = player:WaitForChild('Humanoid')

	if not humanoid then return end

	if not canShootWeapon() then return end

	local distance = (mouse.Hit.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

	if distance > ReplicatedStorage.Slingshot.Configuration.MaxDistance.Value then return end

	updateBullet(function(oldValue)
		return oldValue - 1
	end)

	eventsFolder.FireProjectile:FireServer(mouse.Hit.p, tool.Handle.Position)

	timeOfPreviousShot = tick()
end

local function toolEquipped()
	ContextActionService:BindAction(RELOAD_ACTION, onAction, true, Enum.KeyCode.R)
end

local function toolUnequipped()
	ContextActionService:UnbindAction(RELOAD_ACTION)
end

local function toolActivated()
	if canShootWeapon() then
		fireWeapon()
	end
end

Players.LocalPlayer:WaitForChild('PlayerGui'):WaitForChild('ScreenGui'):WaitForChild('Slingshot'):WaitForChild('SlingshotBullet'):WaitForChild('TextLabel')

updateBullet(function()
	return MAX_BULLET
end)

tool.Equipped:Connect(toolEquipped)
tool.Unequipped:Connect(toolUnequipped)
tool.Activated:Connect(toolActivated)
