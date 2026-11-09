local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Pool = require(ReplicatedStorage.external.Pool)
local SoundExpert = require(StarterPlayer.StarterPlayerScripts.modules.SoundExpert)
local SoundManifest = require(StarterPlayer.StarterPlayerScripts.modules.SoundManifest)
local SoundReproduce = require(StarterPlayer.StarterPlayerScripts.modules.SoundReproduce)
local Wrapper = require(ReplicatedStorage.external.Pool.Wrapper)
local Constants = require(script.Parent.Constants)

local PlayerActionPool = Wrapper.new("PlayerActionPool")
local CheckpointPool = Pool.new("CheckpointPool")
local MainPlayerAudioReproducer = SoundExpert.new("Auff man", SoundManifest)
-- local AmbientationAudioReproducer = SoundReproduce.new(StarterPlayer.StarterPlayerScripts.modules.SoundExpert:WaitForChild("Auff man"))
local SoundEffectAudioReproducer = SoundReproduce.new(StarterPlayer.StarterPlayerScripts.modules.SoundExpert:WaitForChild("Auff man"))

local Player = Constants.PLAYER

local sfxAudios = {
    "005",
    "006"
}

local currentAmbientationSoundCode = {
    "001",
    "002",
    "003"
}

-- local function overrideDefaultPlayerSounds() end

local function removeDefaultPlayerSounds(character)
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    for _, instance in pairs(humanoidRootPart:GetChildren()) do
        if instance:IsA("Sound") then
            instance:Destroy()
        end
    end
end

local function onCheckpointRechead(instance)
    local hitSoundCode = sfxAudios[1]
    SoundEffectAudioReproducer:Play(hitSoundCode, false)
end

local function main()
    CheckpointPool:BindRemoteEvent(onCheckpointRechead)
    
    Player.CharacterAdded:Connect(function(character)
        PlayerActionPool:Fire("teleportPlayerCurrentStage")
        PlayerActionPool:Fire("grantPlayerHumanoidHabilities", character)
    end)

    Player.CharacterAppearanceLoaded:Connect(function(char: Model)
        removeDefaultPlayerSounds(char)
        MainPlayerAudioReproducer:Play("002", false)
    end)
end

main()