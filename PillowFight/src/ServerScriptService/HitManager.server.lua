local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

repeat
    task.wait()
until #Players:GetPlayers() >= 2


local function onPlayerHit(playerFired)
    local otherPlayer

    for _, v in ipairs(Players:GetPlayers()) do
        if v.UserId ~= playerFired.UserId then
            otherPlayer = v
        end
    end

    otherPlayer.Character:WaitForChild("Humanoid").Health -= 10
end

ReplicatedStorage.Events.HitPlayer.OnServerEvent:Connect(onPlayerHit)
