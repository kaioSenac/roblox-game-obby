local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local SoundExpert = require(StarterPlayer.StarterPlayerScripts.sound.modules.SoundExpert)
local CheckpointPool = ReplicatedStorage.Events.Checkpoint

local CheckpointSoundEffect = {}

type CheckpointSoundEffect = typeof(CheckpointSoundEffect) & {}

function CheckpointSoundEffect.Start(self)
	local remoteEvent = CheckpointPool.RemoteEvent
	remoteEvent.OnClientEvent:Connect(function(...)
		self:onCheckpointReached(...)
	end)
	
	self.played = false
end

function CheckpointSoundEffect.onCheckpointReached(self, instance)
	if self.played then
		return
	end
	
	self.played = true
	
	SoundExpert:PlaySoundWithName("sound_005", true, function()
		self.played = false
	end)
end

return CheckpointSoundEffect :: CheckpointSoundEffect
