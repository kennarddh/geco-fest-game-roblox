local UserInputService = game:GetService('UserInputService')
local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

Players.LocalPlayer.CharacterAdded:Wait()

local humanoidRootPart = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

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

local t = ReplicatedStorage.Slingshot.Configuration.ProjectileT.Value

local CFrameProjectileMultiplier = ReplicatedStorage.Slingshot.Configuration.CFrameProjectileMultiplier.Value

local projectilePathBeamConnection

local beamAttach0, beamAttach1, beam

local function updateBullet(callback)
	local BulletText = Players.LocalPlayer.PlayerGui.ScreenGui.Slingshot.SlingshotBullet.TextLabel

	local newValue = callback(bullet)

	bullet = newValue

	BulletText.Text = newValue
end

local function onAction(actionName, inputState, inputObject)
	if actionName == RELOAD_ACTION and inputState == Enum.UserInputState.Begin then
		isReloading = true

		wait(RELOAD_TIME)

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
	local toolHandlePosition = tool.Handle.Position

	local player = tool.Parent

	local humanoid = player:WaitForChild('Humanoid')

	if not humanoid then return end
	
	if not canShootWeapon() then return end
	
	local distance = (mouse.Hit.p - Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
	
	if distance > ReplicatedStorage.Slingshot.Configuration.MaxDistance.Value then return end
	
	updateBullet(function(oldValue) 
		return oldValue - 1
	end)
	
	eventsFolder.FireProjectile:FireServer(mouse.Hit.p, tool.Handle.Position)
	
	timeOfPreviousShot = tick()
end

local function beamProjectile(g, v0, x0, t1)
	-- calculate the bezier points
	local c = 0.5 * 0.5 * 0.5;
	local p3 = 0.5 * g * t1 * t1 + v0 * t1 + x0;
	local p2 = p3 - (g * t1 * t1 + v0 * t1) / 3;
	local p1 = (c * g * t1 * t1 + 0.5 * v0 * t1 + x0 - c * (x0 + p3)) / (3 * c) - p2;

	-- the curve sizes
	local curve0 = (p1 - x0).Magnitude;
	local curve1 = (p2 - p3).Magnitude;

	-- build the world CFrames for the attachments
	local b = (x0 - p3).Unit
	local r1 = (p1 - x0).Unit
	local u1 = r1:Cross(b).Unit
	local r2 = (p2 - p3).Unit
	local u2 = r2:Cross(b).Unit
	b = u1:Cross(r1).Unit

	local cf1 = CFrame.new(
		x0.x, x0.y, x0.z,
		r1.x, u1.x, b.x,
		r1.y, u1.y, b.y,
		r1.z, u1.z, b.z
	)

	local cf2 = CFrame.new(
		p3.x, p3.y, p3.z,
		r2.x, u2.x, b.x,
		r2.y, u2.y, b.y,
		r2.z, u2.z, b.z
	)

	return curve0, -curve1, cf1, cf2;
end

local function showProjectilePathBeam(beam, attach0, attach1)
	local distance = (mouse.Hit.p - Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude

	if distance > ReplicatedStorage.Slingshot.Configuration.MaxDistance.Value then
		beam.Enabled = false
		
		return
	else
		beam.Enabled = true
	end
	
	local g = Vector3.new(0, -game.Workspace.Gravity, 0)
	local x0 = tool.Handle.Position + CFrameProjectileMultiplier
	local v0 = (mouse.Hit.p - x0 - 0.5 * g * t * t) / t

	local curve0, curve1, cf1, cf2 = beamProjectile(g, v0, x0, t)
	beam.CurveSize0 = curve0
	beam.CurveSize1 = curve1
	
	-- convert world space CFrames to be relative to the attachment parent
	attach0.CFrame = attach0.Parent.CFrame:inverse() * cf1
	attach1.CFrame = attach1.Parent.CFrame:inverse() * cf2
end

local function toolEquipped()
	beamAttach0 = Instance.new("Attachment", game.Workspace.Terrain)
	beamAttach1 = Instance.new("Attachment", game.Workspace.Terrain)
	
	beam = Instance.new("Beam", game.Workspace.Terrain)

	beamAttach0.Name = string.format("%sBeamAttach0", Players.LocalPlayer.Name)
	beamAttach1.Name = string.format("%sBeamAttach1", Players.LocalPlayer.Name)
	beam.Name = string.format("%sBeam", Players.LocalPlayer.Name)
	
	beam.FaceCamera = true
	beam.Width0 = 0.5
	beam.Width1 = 0.5
	
	beam.Attachment0 = beamAttach0
	beam.Attachment1 = beamAttach1
	
	projectilePathBeamConnection = RunService.RenderStepped:Connect(function(step)
		showProjectilePathBeam(beam, beamAttach0, beamAttach1)
	end)
	
	ContextActionService:BindAction(RELOAD_ACTION, onAction, true, Enum.KeyCode.R)
end

local function toolUnequipped()
	projectilePathBeamConnection:Disconnect()
	
	beam:Destroy()
	beamAttach0:Destroy()
	beamAttach1:Destroy()
	
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