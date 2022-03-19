local Players = game:GetService('Players')
local TweenService = game:GetService("TweenService")
local DebrisService = game:GetService("Debris")
local TeleportService = game:GetService("TeleportService")

local targets = script.Parent.Targets

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local slingshotEventsFolder = ReplicatedStorage.Events.Slingshot

local ServerStorage = game:GetService("ServerStorage")

local ServerStorageSlingshotData = ServerStorage.Data.Slingshot
local ServerStorageData = ServerStorage.Data

local requiredPointsToWin = ServerStorageSlingshotData.Configuration.RequiredPointsToWin.Value

local lobbyPlaceId = 9026225494

function shakePart(part)
	local cycleDuration = 0.1
	local totalDuration = 0.2
	local volatility = 0.5

	local savedPosition = part.Position

	local tweeninfo = TweenInfo.new(
		cycleDuration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		0,
		false,
		0
	)


	for _ = 0, totalDuration - cycleDuration, cycleDuration do
		local position = savedPosition + Vector3.new(
			math.random(-1, 1),
			math.random(-1, 1),
			math.random(-1, 1)
		) * volatility

		local tween = TweenService:Create(
			part,
			tweeninfo,
			{ Position = position }
		)

		tween:Play()

		tween.Completed:Wait()
	end

	TweenService:Create(
		part,
		tweeninfo,
		{Position = savedPosition}
	):Play()
end

local function showIndicator(target, points)
	local indicatorGui = Instance.new("BillboardGui")
	indicatorGui.AlwaysOnTop = true

	indicatorGui.Size = UDim2.new(10, 0, 10, 0)

	local offsetX = math.random(-10, 10) / 10
	local offsetY = math.random(-10, 10) / 10
	local offsetZ = math.random(-10, 10) / 10
	
	indicatorGui.StudsOffset = Vector3.new(offsetX, offsetY, offsetZ)

	local indicatorLabel = Instance.new("TextLabel")

	indicatorLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	
	indicatorLabel.Position = UDim2.new(0.5, 0, 0.5, 0)

	indicatorLabel.TextScaled = true
	indicatorLabel.BackgroundTransparency = 1

	indicatorLabel.Text = string.format("%s/%s", points, requiredPointsToWin)

	indicatorLabel.Size = UDim2.new(0, 0, 0, 0)

	indicatorLabel.TextColor3 = Color3.new(0, 0, 0)

	indicatorLabel.Parent = indicatorGui

	indicatorGui.Parent = target

	indicatorLabel:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3)
	
	wait(0.3)
	
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
	
	local guiUpTween = TweenService:Create(indicatorGui, tweenInfo, {
		StudsOffset = indicatorGui.StudsOffset + Vector3.new(0, 1, 0)
	})

	local textFadeTween = TweenService:Create(indicatorLabel, tweenInfo, {
		TextTransparency = 1
	})

	guiUpTween:Play()
	textFadeTween:Play()

	DebrisService:AddItem(indicatorGui, 0.3)
end

local function targetHit(projectile, target)
	if projectile.Name ~= 'SlingshotProjectile' then return end

	if projectile:GetAttribute("AlreadyHit") then return end

	projectile.HitParticleEmitter:Emit(100)

	local playerFired = projectile:GetNetworkOwner()

	ServerStorageSlingshotData.Points[playerFired.Name].Value += 1

	projectile:SetAttribute("AlreadyHit", true)

	if ServerStorageSlingshotData.Points[playerFired.Name].Value >= requiredPointsToWin then
		slingshotEventsFolder.RemoveProjectilePathBeam:FireClient(playerFired)
		
		if playerFired.Backpack:FindFirstChild("Slingshot") then
			playerFired.Backpack.Slingshot:Destroy()
		else
			if playerFired.Character:FindFirstChild("Slingshot") then
				playerFired.Character.Slingshot:Destroy()
			end
		end

		ServerStorageData.Wins[playerFired.Name].Value += 1

		playerFired.leaderstats.Wins.Value = ServerStorageData.Wins[playerFired.Name].Value

		ServerStorageSlingshotData.Points[playerFired.Name].Value = 0
		

		ServerStorageSlingshotData.Points[playerFired.Name]:Destroy()
		
		TeleportService:TeleportAsync(lobbyPlaceId, { playerFired })
	end

	local showIndicatorCoroutine = coroutine.create(showIndicator)
	
	local shakePartCoroutine = coroutine.create(shakePart)
	
	if ServerStorageSlingshotData.Points:FindFirstChild(playerFired.Name) then
		coroutine.resume(
			showIndicatorCoroutine,
			target,
			ServerStorageSlingshotData.Points[playerFired.Name].Value
		)
	end
	
	coroutine.resume(
		shakePartCoroutine,
		target
	)
end

local function onPlayerAdded(player)
	local points = Instance.new('IntValue')

	points.Name = player.Name

	points.Parent = ServerStorageSlingshotData.Points
end

local function onPlayerRemoved(player)
	if not ServerStorageSlingshotData.Points:FindFirstChild(player.Name) then return end
	
	ServerStorageSlingshotData.Points[player.Name]:Destroy()
end

local function onTouch(hit, target)
	targetHit(hit, target)
end

for _, target in ipairs(targets:GetChildren()) do
	target.Touched:Connect(function(hit)
		onTouch(hit, target)
	end)
end

Players.PlayerRemoving:Connect(onPlayerRemoved)


Players.PlayerAdded:Connect(onPlayerAdded)
