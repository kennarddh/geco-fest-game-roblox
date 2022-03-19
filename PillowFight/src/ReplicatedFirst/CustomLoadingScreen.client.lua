local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer 
local playerGui = player:WaitForChild("PlayerGui")


local function ShowGui(text)
    local screenGui = Instance.new("ScreenGui")

    screenGui.IgnoreGuiInset = true
    screenGui.Parent = playerGui

    local textLabel = Instance.new("TextLabel")

    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    textLabel.Text = text
    textLabel.TextSize = 28

    textLabel.Parent = screenGui

    local loadingRing = Instance.new("ImageLabel")

    loadingRing.Size = UDim2.new(0, 256, 0, 256)
    loadingRing.BackgroundTransparency = 1
    loadingRing.Image = "rbxassetid://4965945816"
    loadingRing.AnchorPoint = Vector2.new(0.5, 0.5)
    loadingRing.Position = UDim2.new(0.5, 0, 0.5, 0)

    loadingRing.Parent = screenGui

    -- Remove the default loading screen
    ReplicatedFirst:RemoveDefaultLoadingScreen()

    local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
    local tween = TweenService:Create(loadingRing, tweenInfo, { Rotation = 360 })

    tween:Play()

    return screenGui
end

local loadingGui = ShowGui('Loading')

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

            local success, _ = pcall(function()
                TeleportService:TeleportAsync(LobbyPlaceId, { Players.LocalPlayer })
            end)

            if not success then
                warn("Failed to teleport to lobby")
            end

            if loadingGui then
                loadingGui:Destroy()
            end

            ShowGui('Teleporting\nto lobby')

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
until #Players:GetPlayers() > 2

if not game:IsLoaded() then
	game.Loaded:Wait()
end

if loadingGui then
    loadingGui:Destroy()
end
