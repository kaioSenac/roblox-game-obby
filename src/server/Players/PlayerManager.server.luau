local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animations = require(ReplicatedStorage.Configs.Animations)
local PlayerActions = require(script.Parent.PlayerActions)

local function attibutePowers(humanoid)
	humanoid.WalkSpeed = 30
	humanoid.JumpPower = 80
end

local function overrideDefaultAnimations(plr: Player)
	plr.CharacterAppearanceLoaded:Connect(function(character: Model)
		local animate = character:FindFirstChild("Animate")
		if not animate then
			return
		end
		
		animate.walk.WalkAnim.AnimationId = Animations.DEFAULT_WALK
		animate.jump.JumpAnim.AnimationId = Animations.DEFAULT_JUMP
		animate.fall.FallAnim.AnimationId = Animations.DEFAULT_FALL
		animate.idle.Animation1.AnimationId = Animations.DEFAULT_IDLE1
		animate.idle.Animation2.AnimationId = Animations.DEFAULT_IDLE2	
	end)
end

Players.PlayerAdded:Connect(function(player)
	player:SetAttribute("Stage", 1)
	
	overrideDefaultAnimations(player)
	
	player.CharacterAdded:Connect(function(character)
		PlayerActions.teleportPlayerToCurrentStage(player)
		
		local humanoid = character:WaitForChild("Humanoid")
		
		attibutePowers(humanoid)
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	player:SetAttribute("Stage", 1)
end)