--[[
    @file: SoundReproduce.luau
    @description: Reproducao de audio
    @author: SeuNome
    @created: 2026-11-08
    @updated: 2026-11-08
]]

local SoundReproducer = {}
SoundReproducer.__index = SoundReproducer

export type SoundReproducer = typeof(setmetatable({} :: {
    pool: { [string]: Sound },
    playing: Sound,
    waitEvent: BindableEvent,
    poolLoaded: boolean
}, SoundReproducer))

--[[
    @function: SoundReproducer.new
    @description: Criar a instancia que reproduz audio

    @param pool: Folder - Diretorio onde esta o assets de musica

    @return SoundReproducer
]]
function SoundReproducer.new(pool: Folder | Instance): SoundReproducer
    if not pool then
        return {} :: any
    end

    local self = setmetatable({}, SoundReproducer)

    self.playing = false
    self.waitEvent = nil
    self.pool = {}

    task.spawn(function()
        for _, soundInstance in pairs(pool:GetChildren()) do
            if soundInstance:IsA("Sound") then
                self.pool[soundInstance.Name] = soundInstance
            end
        end

        if self.waitEvent then
            self.waitEvent:Fire()
            self.waitEvent:Destroy()
        end
    end)

    return self
end

--[[
    @function: SoundReproducer.WaitPool
    @description: Esperar o pool carregar

    @param self: SoundReproducer - A propria instancia

    @return void
]]
function SoundReproducer.WaitPool(self: SoundReproducer): ()
    local waitEvent

    if not self.waitEvent then
        waitEvent = Instance.new("BindableEvent")
        self.waitEvent = waitEvent
    end

    waitEvent.Event:Wait()
end

--[[
    @function: SoundReproducer.Play
    @description: Descreva o objetivo da função.

    @param self: SoundReproducer - A propria instancia
    @param name: string - O nome da musica
    @param wait: boolean - Deve esperar a musica terminar? (pode travar o codigo)

    @return void
]]
function SoundReproducer.Play(self: SoundReproducer, name: string, waits: boolean): ()
    local soundInstance

    soundInstance = self.pool[name]
    if not soundInstance then return end

    soundInstance.Volume = 0.2
    soundInstance:Play()

    self.playing = soundInstance

    if waits then
        soundInstance.Ended:Wait()
        self.playing = nil :: any
    end

    soundInstance.Ended:Connect(function()
        self.playing = nil :: any
    end)
end

--[[
    @function: SoundReproducer.Stop
    @description: Parar o son que esta tocando

    @param self: SoundReproducer - A propria instancia
    @return void
]]
function SoundReproducer.Stop(self: SoundReproducer)
    if self.playing then
        self.playing:Stop()
    end
end

return SoundReproducer