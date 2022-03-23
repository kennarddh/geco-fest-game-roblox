local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Players = game:GetService("Players")

local player = Players.LocalPlayer 
local playerGui = player:WaitForChild("PlayerGui")

local LoadingScreen = require(ReplicatedFirst:WaitForChild("Modules").LoadingScreen)

local function onShowLoading(text)
    LoadingScreen.new(text, playerGui)
end

ReplicatedStorage.Events.ShowLoading.onClientEvent:Connect(onShowLoading)