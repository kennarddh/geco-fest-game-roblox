local Players = game:GetService("Players")

local walkAnimation = 'rbxassetid://9155045502'


local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	for _, track in pairs(animator:GetPlayingAnimationTracks()) do
		track:Stop(0)
	end

	local animateScript = character:WaitForChild("Animate")

	animateScript.run.RunAnim.AnimationId = walkAnimation
	animateScript.walk.WalkAnim.AnimationId = walkAnimation
end

local function onPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(onCharacterAdded)
end
 
Players.PlayerAdded:Connect(onPlayerAdded)