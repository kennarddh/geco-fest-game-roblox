local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService('ReplicatedStorage')

local player = Players.LocalPlayer 
local playerGui = player:WaitForChild("PlayerGui")

local LoadingScreen = require(ReplicatedFirst:WaitForChild("Modules").LoadingScreen)

ReplicatedFirst:RemoveDefaultLoadingScreen()

local LoadingScreenGui = LoadingScreen.new('Loading', playerGui)

task.wait(1)  -- Force screen to appear for a minimum number of seconds

local isSecondPlayerJoined = false
local isTimeout = false
local waitSecondPlayerTimeout = 10
local LobbyPlaceId = 9026225494

local waitSecondPlayerCoroutine = coroutine.create(function()
    local start = tick()

    while true do
        if isSecondPlayerJoined then
            break
        elseif tick() - start >= waitSecondPlayerTimeout then
            isTimeout = true

            ReplicatedStorage.Events.TeleportPlayer:FireServer(LobbyPlaceId)

            if LoadingScreenGui then
                LoadingScreenGui:destroy()
            end

            LoadingScreen.new('Teleporting\nto lobby', playerGui)

            break
        end

        task.wait()
    end
end)

coroutine.resume(waitSecondPlayerCoroutine)

repeat
    if isTimeout then
        break
    end

    task.wait()
until #Players:GetPlayers() >= 2

isSecondPlayerJoined = true

if not game:IsLoaded() then
	game.Loaded:Wait()
end

if LoadingScreenGui then
    LoadingScreenGui:destroy()
end
