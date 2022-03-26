local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventsFolder = ReplicatedStorage.Events.Slingshot

local projectile = game.ServerStorage.Slingshot.SlingshotProjectile

local t = ReplicatedStorage.Slingshot.Configuration.ProjectileT.Value
local CFrameProjectileMultiplier = ReplicatedStorage.Slingshot.Configuration.CFrameProjectileMultiplier.Value


local function fireProjectile(playerFired, mouseHit, toolHandlePosition)
	local projectileClone = projectile:clone()

	local gravity = Vector3.new(0, -game.Workspace.Gravity, 0)
	local cFrame = toolHandlePosition + CFrameProjectileMultiplier

	local velocity = (mouseHit - cFrame - 0.5 * gravity * t * t) / t

	local distance = (mouseHit - playerFired.Character.HumanoidRootPart.Position).magnitude	

	if distance > ReplicatedStorage.Slingshot.Configuration.MaxDistance.Value then return end

	projectileClone.Velocity = velocity

	projectileClone.CFrame = CFrame.new(cFrame)
	projectileClone.Parent = game.Workspace

	projectileClone:SetNetworkOwner(playerFired)
end

eventsFolder.FireProjectile.OnServerEvent:Connect(fireProjectile)