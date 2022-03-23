local Players = game:GetService('Players')
local ServerStorage = game:GetService('ServerStorage')
local TeleportService = game:GetService('TeleportService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local lobbyPlaceId = 9026225494

local function onDied(player)
    local otherPlayer

    for _, v in ipairs(Players:GetPlayers()) do
        if v.UserId ~= player.UserId then
            otherPlayer = v
        end
    end

    ServerStorage.Data.Wins[otherPlayer.UserId].Value += 1

    ReplicatedStorage.Events.ShowLoading:FireAllClients('Teleporting\nto lobby')

    local success, result = pcall(function()
        return TeleportService:TeleportPartyAsync(lobbyPlaceId, {
            player,
            otherPlayer
        })
    end)

    if not success then
        warn("Teleport Failed\nReason: " .. result)
    end
end

local function onCharacterAdded(player, character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        onDied(player)
    end)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
