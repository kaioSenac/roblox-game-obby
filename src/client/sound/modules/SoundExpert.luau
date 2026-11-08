local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Configs.Constants)

local SoundExpert = {}

type SoundExpert = typeof(SoundExpert) & {
    initialized: boolean,
    replicatedSounds: { [string]: Sound }
}

function SoundExpert.Init(self: SoundExpert): ()
    assert(not self.initialized, "sound expert has been initialized")

    self.replicatedSounds = {}
    self.initialized = true

    local assetsFolder = Constants.ASSETS
    
    for _, instance in pairs(assetsFolder:GetChildren()) do
        if not instance:IsA("Sound") then
            continue
        end
        
        self.replicatedSounds[instance.Name] = instance
    end

    if #self.replicatedSounds > 0 then
        self.initialized = false
        warn("you can repeat SoundExpert initialization")
        return false
    end

    return true
end

function SoundExpert.PlaySoundWithName(self: SoundExpert, name: string, wait: boolean?, bind: () -> ()?): ()
    assert(self.initialized == true, 'voce nao pode usar isso sem antes ter inicializado com INIT')

    local soundInstance

    soundInstance = self.replicatedSounds[name]
    if not soundInstance then
        return
    end

    soundInstance:Play()

    if wait then
        soundInstance.Ended:Connect(bind)
    end
end

return SoundExpert :: SoundExpert