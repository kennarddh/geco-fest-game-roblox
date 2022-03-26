local TweenService = game:GetService("TweenService")

local LoadingScreen = {}
LoadingScreen.__index = LoadingScreen

function LoadingScreen.new(text, playerGui)
    local LoadingScreenCopy = {}

    setmetatable(LoadingScreenCopy, LoadingScreen)


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

    local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
    local tween = TweenService:Create(loadingRing, tweenInfo, { Rotation = 360 })

    tween:Play()

    LoadingScreenCopy.screenGui = screenGui

    return LoadingScreenCopy
end

function LoadingScreen:destroy()
    self.screenGui:Destroy()
end

return LoadingScreen