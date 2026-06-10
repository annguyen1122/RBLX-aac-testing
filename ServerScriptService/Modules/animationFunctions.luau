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



return animationFunctions
