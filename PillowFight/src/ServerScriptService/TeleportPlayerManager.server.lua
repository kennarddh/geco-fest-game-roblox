local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")


local function onTeleportPlayer(playerFired, placeId)
    local success, result = pcall(function()
        TeleportService:TeleportAsync(placeId, { playerFired })
    end)

    if not success then
        warn("Teleeport Failed\nReason: " .. result)
    end
end

ReplicatedStorage.Events.TeleportPlayer.OnServerEvent:Connect(onTeleportPlayer)