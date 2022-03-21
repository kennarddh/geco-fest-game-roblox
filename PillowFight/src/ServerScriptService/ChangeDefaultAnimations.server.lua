local Players = game:GetService("Players")

local walkAnimation = 'rbxassetid://9066203817'
local idleAnim = 'rbxassetid://9066203817'


local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	for _, track in pairs(animator:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end

	local animateScript = character:WaitForChild("Animate")

	animateScript.run.RunAnim.AnimationId = walkAnimation
	animateScript.walk.WalkAnim.AnimationId = walkAnimation
	animateScript.idle.Animation1.AnimationId = idleAnim
	animateScript.idle.Animation2.AnimationId = idleAnim
end

local function onPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(onCharacterAdded)
end
 
Players.PlayerAdded:Connect(onPlayerAdded)