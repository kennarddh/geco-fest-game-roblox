local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local LobbyPlaceId = 9026225494


repeat
    task.wait()
until #Players:GetPlayers() >= 2

repeat
    task.wait()
until #Players:GetPlayers() <= 1

local success, result = pcall(function()
    TeleportService:TeleportAsync(LobbyPlaceId, Players:GetPlayers())
end)

if not success then
    warn("Teleeport Failed\nReason: " .. result)
end
