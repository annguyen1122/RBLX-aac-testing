local animationFunctions = {}

function animationFunctions.placeholderDeath(animator)
	--TEMP ANIMATION TEST
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://109882656860274"
	local animationTrack = animator:LoadAnimation(animation)
	animationTrack:Play()
	animationTrack:GetMarkerReachedSignal("fallenDown"):Wait()
	animationTrack:Destroy()

	local animationDowned = Instance.new("Animation")
	animationDowned.AnimationId = "rbxassetid://75885028653234"
	local animationTrackDowned = animator:LoadAnimation(animationDowned)
	animationTrackDowned:Play()
	
	return animationTrackDowned
end

function animationFunctions.swordLungeMirrored(animator)
	local animation = Instance.new("Animation")
	animation.AnimationId = 'rbxassetid://121072191175888'
	local animtrack = animator:LoadAnimation(animation)
	animtrack:Play()
	animtrack:GetMarkerReachedSignal("prepare"):Connect(function()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://12222225"
		sound.Playing = true
		sound.Parent = animator.Parent
	end)
	animtrack:GetMarkerReachedSignal("lunge"):Connect(function()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://12222208"
		sound.Playing = true
		sound.Parent = animator.Parent
	end)
	
	game.Debris:AddItem(animtrack, 5)
end

function animationFunctions.swordIdle(animator)
	local animation = Instance.new("Animation")
	animation.AnimationId = 'rbxassetid://103420326914248'
	local animtrack = animator:LoadAnimation(animation)
	animtrack:Play()
	
	return animtrack
end



return animationFunctions
