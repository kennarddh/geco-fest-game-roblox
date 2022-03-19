local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local eventsFolder = ReplicatedStorage.Events.Slingshot


local function removeProjectilePathBeam()
	game.Workspace.Terrain[string.format("%sBeamAttach0", Players.LocalPlayer.Name)]:Destroy()
	game.Workspace.Terrain[string.format("%sBeamAttach1", Players.LocalPlayer.Name)]:Destroy()
	game.Workspace.Terrain[string.format("%sBeam", Players.LocalPlayer.Name)]:Destroy()
end

eventsFolder.RemoveProjectilePathBeam.OnClientEvent:Connect(removeProjectilePathBeam)