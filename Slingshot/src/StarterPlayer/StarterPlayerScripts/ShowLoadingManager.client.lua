local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LoadingScreen = require(ReplicatedStorage:WaitForChild("Modules").LoadingScreen)

local function onShowLoading(text)
    LoadingScreen.new(text, playerGui)
end

ReplicatedStorage.Events.Slingshot.ShowLoading.onClientEvent:Connect(onShowLoading)