local StarterPlayer = game:GetService("StarterPlayer")

local SoundExpert = require(StarterPlayer.StarterPlayerScripts.sound.modules.SoundExpert)
local CheckpointSoundEffect = require(script.Parent.CheckpointSoundEffects)

SoundExpert:Init()
task.wait(1)
CheckpointSoundEffect:Start()